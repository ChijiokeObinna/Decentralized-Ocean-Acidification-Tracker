(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_INVALID_PH (err u402))
(define-constant ERR_INVALID_COORDINATES (err u403))
(define-constant ERR_SENSOR_NOT_FOUND (err u404))
(define-constant ERR_SENSOR_ALREADY_EXISTS (err u405))
(define-constant ERR_INSUFFICIENT_TOKENS (err u406))
(define-constant ERR_READING_NOT_FOUND (err u407))

(define-fungible-token ocean-health-credits)

(define-data-var total-sensors uint u0)
(define-data-var total-readings uint u0)
(define-data-var reward-per-reading uint u100)

(define-map sensors 
  principal 
  {
    location: {lat: int, lon: int},
    registered-at: uint,
    total-readings: uint,
    is-active: bool
  }
)

(define-map ph-readings
  uint
  {
    sensor-id: principal,
    ph-value: uint,
    temperature: uint,
    timestamp: uint,
    location: {lat: int, lon: int},
    validated: bool
  }
)

(define-map sensor-readings
  {sensor: principal, reading-id: uint}
  uint
)

(define-map daily-averages
  {date: uint, lat-zone: int, lon-zone: int}
  {
    avg-ph: uint,
    reading-count: uint,
    total-ph: uint
  }
)

(define-read-only (get-sensor-info (sensor-id principal))
  (map-get? sensors sensor-id)
)

(define-read-only (get-ph-reading (reading-id uint))
  (map-get? ph-readings reading-id)
)

(define-read-only (get-total-sensors)
  (var-get total-sensors)
)

(define-read-only (get-total-readings)
  (var-get total-readings)
)

(define-read-only (get-reward-rate)
  (var-get reward-per-reading)
)

(define-read-only (get-balance (account principal))
  (ft-get-balance ocean-health-credits account)
)

(define-read-only (get-daily-average (date uint) (lat-zone int) (lon-zone int))
  (map-get? daily-averages {date: date, lat-zone: lat-zone, lon-zone: lon-zone})
)

(define-read-only (calculate-zone (coordinate int))
  (/ coordinate 1000)
)

(define-read-only (is-valid-ph (ph-value uint))
  (and (>= ph-value u0) (<= ph-value u1400))
)

(define-read-only (is-valid-temperature (temp uint))
  (and (>= temp u0) (<= temp u5000))
)

(define-read-only (is-valid-coordinates (lat int) (lon int))
  (and 
    (and (>= lat -90000) (<= lat 90000))
    (and (>= lon -180000) (<= lon 180000))
  )
)

(define-public (register-sensor (lat int) (lon int))
  (let
    (
      (sensor-id tx-sender)
      (current-block stacks-block-height)
    )
    (asserts! (is-valid-coordinates lat lon) ERR_INVALID_COORDINATES)
    (asserts! (is-none (map-get? sensors sensor-id)) ERR_SENSOR_ALREADY_EXISTS)
    (map-set sensors sensor-id {
      location: {lat: lat, lon: lon},
      registered-at: current-block,
      total-readings: u0,
      is-active: true
    })
    (var-set total-sensors (+ (var-get total-sensors) u1))
    (try! (ft-mint? ocean-health-credits u1000 sensor-id))
    (ok sensor-id)
  )
)

(define-public (deactivate-sensor (sensor-id principal))
  (let
    (
      (sensor-data (unwrap! (map-get? sensors sensor-id) ERR_SENSOR_NOT_FOUND))
    )
    (asserts! (or (is-eq tx-sender CONTRACT_OWNER) (is-eq tx-sender sensor-id)) ERR_UNAUTHORIZED)
    (map-set sensors sensor-id (merge sensor-data {is-active: false}))
    (ok true)
  )
)

(define-public (submit-ph-reading (ph-value uint) (temperature uint))
  (let
    (
      (sensor-id tx-sender)
      (reading-id (+ (var-get total-readings) u1))
      (current-timestamp stacks-block-height)
      (sensor-data (unwrap! (map-get? sensors sensor-id) ERR_SENSOR_NOT_FOUND))
      (sensor-location (get location sensor-data))
      (lat-zone (calculate-zone (get lat sensor-location)))
      (lon-zone (calculate-zone (get lon sensor-location)))
      (date-key (/ current-timestamp u144))
    )
    (asserts! (get is-active sensor-data) ERR_UNAUTHORIZED)
    (asserts! (is-valid-ph ph-value) ERR_INVALID_PH)
    (asserts! (is-valid-temperature temperature) ERR_INVALID_PH)
    
    (map-set ph-readings reading-id {
      sensor-id: sensor-id,
      ph-value: ph-value,
      temperature: temperature,
      timestamp: current-timestamp,
      location: sensor-location,
      validated: false
    })
    
    (map-set sensor-readings {sensor: sensor-id, reading-id: reading-id} reading-id)
    
    (update-daily-average date-key lat-zone lon-zone ph-value)
    
    (map-set sensors sensor-id 
      (merge sensor-data {total-readings: (+ (get total-readings sensor-data) u1)})
    )
    
    (var-set total-readings reading-id)
    (try! (ft-mint? ocean-health-credits (var-get reward-per-reading) sensor-id))
    (ok reading-id)
  )
)

(define-private (update-daily-average (date uint) (lat-zone int) (lon-zone int) (ph-value uint))
  (let
    (
      (zone-key {date: date, lat-zone: lat-zone, lon-zone: lon-zone})
      (existing-avg (default-to 
        {avg-ph: u0, reading-count: u0, total-ph: u0} 
        (map-get? daily-averages zone-key)
      ))
      (new-count (+ (get reading-count existing-avg) u1))
      (new-total (+ (get total-ph existing-avg) ph-value))
      (new-avg (/ new-total new-count))
    )
    (map-set daily-averages zone-key {
      avg-ph: new-avg,
      reading-count: new-count,
      total-ph: new-total
    })
  )
)

(define-public (validate-reading (reading-id uint))
  (let
    (
      (reading-data (unwrap! (map-get? ph-readings reading-id) ERR_READING_NOT_FOUND))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (not (get validated reading-data)) ERR_UNAUTHORIZED)
    (map-set ph-readings reading-id (merge reading-data {validated: true}))
    (try! (ft-mint? ocean-health-credits u50 (get sensor-id reading-data)))
    (ok true)
  )
)

(define-public (transfer-tokens (amount uint) (recipient principal))
  (begin
    (asserts! (>= (ft-get-balance ocean-health-credits tx-sender) amount) ERR_INSUFFICIENT_TOKENS)
    (ft-transfer? ocean-health-credits amount tx-sender recipient)
  )
)

(define-public (set-reward-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (var-set reward-per-reading new-rate)
    (ok true)
  )
)

(define-read-only (get-sensor-readings (sensor-id principal) (reading-id uint))
  (let
    (
      (reading-data (map-get? ph-readings reading-id))
    )
    (match reading-data
      some-reading
        (if (is-eq (get sensor-id some-reading) sensor-id)
          (some reading-id)
          none
        )
      none
    )
  )
)

(define-read-only (get-global-health-score)
  (let
    (
      (total-readings-count (var-get total-readings))
    )
    (if (> total-readings-count u0)
      (some u85)
      none
    )
  )
)
