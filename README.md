##  Overview

A blockchain-based solution for transparently tracking ocean pH levels using decentralized sensor buoys. This smart contract creates an immutable global database of ocean acidification data with token-based incentives for environmental monitoring.

## 🎯 Problem & Solution

**Problem:** Ocean acidification data is severely underreported, making it difficult to track global marine ecosystem health.

**Solution:** Decentralized sensor network on blockchain that provides:
- 🔒 Immutable pH measurement logs
- 🌍 Global public accessibility
- 💰 Token rewards for data contributors
- 📊 Real-time ocean health scoring

## ⚡ Core Features

### 🔧 Sensor Management
- Register ocean sensor buoys with GPS coordinates
- Activate/deactivate sensors
- Track sensor performance metrics

### 📈 Data Collection
- Submit pH and temperature readings
- Automatic geospatial zone averaging
- Timestamp-verified measurements
- Data validation system

### 💎 Token Economy
- **Ocean Health Credits (OHC)** - Native fungible token
- Earn 100 OHC per pH reading submitted
- Bonus 50 OHC for validated readings
- Transferable token rewards

### 🌐 Global Analytics
- Daily pH averages by geographic zones
- Global ocean health score calculation
- Historical data access
- Real-time monitoring dashboard

## 🚀 Quick Start

### Prerequisites
- Clarinet CLI installed
- Stacks wallet for testing

### Installation
```bash
clarinet new ocean-tracker
cd ocean-tracker
# Replace contract file with provided code
clarinet check
clarinet test
```

### 📝 Usage Examples

#### Register a Sensor Buoy
```clarity
(contract-call? .decentralized-ocean-acidification-tracker register-sensor 25000 -80000)
;; Registers sensor at coordinates 25.0°N, 80.0°W (Miami Coast)
```

#### Submit pH Reading
```clarity
(contract-call? .decentralized-ocean-acidification-tracker submit-ph-reading u820 u2500)
;; pH: 8.20, Temperature: 25.0°C
```

#### Check Ocean Health Score
```clarity
(contract-call? .decentralized-ocean-acidification-tracker get-global-health-score)
;; Returns percentage score based on recent pH readings
```

#### View Your Token Balance
```clarity
(contract-call? .decentralized-ocean-acidification-tracker get-balance tx-sender)
```

## 🔍 Smart Contract Functions

### Public Functions
| Function | Description |
|----------|-------------|
| `register-sensor` | Register new sensor with coordinates |
| `submit-ph-reading` | Submit pH and temperature data |
| `validate-reading` | Admin validates sensor reading |
| `transfer-tokens` | Transfer OHC tokens |
| `deactivate-sensor` | Disable sensor |
| `set-reward-rate` | Admin adjusts token rewards |

### Read-Only Functions
| Function | Description |
|----------|-------------|
| `get-sensor-info` | Get sensor details |
| `get-ph-reading` | Get specific pH reading |
| `get-daily-average` | Get daily average for zone |
| `get-global-health-score` | Current ocean health percentage |
| `get-balance` | Check OHC token balance |

## 📊 Data Structure

### pH Values
- Stored as integers (multiply by 100)
- Example: pH 8.20 = `u820`
- Valid range: 0.0 - 14.0

### Coordinates
- Stored as integers (multiply by 1000)
- Example: 25.5°N = `25500`
- Latitude: -90000 to 90000
- Longitude: -180000 to 180000

### Temperature
- Stored as integers (multiply by 100)
- Example: 25.5°C = `u2550`
- Valid range: 0.0°C - 50.0°C

## 🏆 Token Economics

- **Initial Registration:** 1,000 OHC
- **Per Reading:** 100 OHC
- **Validation Bonus:** 50 OHC
- **Total Supply:** Dynamic (minted on contribution)

## 🛡️ Security Features

- Input validation for all pH and coordinate data
- Sensor ownership verification
- Admin-only validation controls
- Duplicate sensor prevention
- Reading authenticity checks

## 🌍 Environmental Impact

This system enables:
- 📈 Better climate change monitoring
- 🔬 Scientific research transparency  
- 🌊 Marine conservation efforts
- 💡 Data-driven policy decisions
- 🤝 Global collaboration on ocean health

## 🔮 Future Enhancements

- IoT sensor integration APIs
- Advanced ML-based anomaly detection
- Carbon credit marketplace integration
- Mobile app for citizen scientists
- Satellite data cross-validation

## 📄 License

MIT License - Building for ocean conservation 🌊

## 🤝 Contributing

Join the mission to save our oceans! Submit PRs, report issues, or propose new features.

---

*Made with 💙 for ocean conservation and blockchain transparency*

## 🆕 Recent Enhancements

### 🚀 Bulk Reading Submission
- Submit up to 5 pH and temperature readings in a single transaction
- Reduces transaction costs for high-volume data collection
- Maintains all validation and reward mechanisms for each reading
- Enhances scalability for sensor networks

#### Submit Bulk Readings
```clarity
(contract-call? .decentralized-ocean-acidification-tracker submit-bulk-readings
  (list {ph-value: u820, temperature: u2500} {ph-value: u815, temperature: u2520}))
;; Submits two readings: pH 8.20/25.0°C and pH 8.15/25.2°C
```

### Updated Smart Contract Functions

#### Public Functions (Updated)
| Function | Description |
|----------|-------------|
| `register-sensor` | Register new sensor with coordinates |
| `submit-ph-reading` | Submit pH and temperature data |
| `submit-bulk-readings` | Submit multiple pH and temperature readings (up to 5) |
| `validate-reading` | Admin validates sensor reading |
| `transfer-tokens` | Transfer OHC tokens |
| `deactivate-sensor` | Disable sensor |
| `set-reward-rate` | Admin adjusts token rewards |

#OceanTech #BulkData #EfficiencyUpgrade

## 🚨 Critical pH Alert System

### 🌊 Automated Ocean Acidification Monitoring
- **Real-time Alerts**: Automatically triggers alerts when pH levels drop below critical thresholds
- **Configurable Thresholds**: Admin-adjustable pH alert levels (default: 7.0)
- **Geospatial Tracking**: Alerts include precise location data for targeted response
- **Immutable Records**: All alerts stored on-chain for transparency and accountability

#### Set Critical pH Threshold
```clarity
(contract-call? .decentralized-ocean-acidification-tracker set-critical-ph-threshold u650)
;; Sets alert threshold to pH 6.50
```

#### Check Current Threshold
```clarity
(contract-call? .decentralized-ocean-acidification-tracker get-critical-ph-threshold)
;; Returns current alert threshold value
```

#### View Critical Alert
```clarity
(contract-call? .decentralized-ocean-acidification-tracker get-critical-ph-alert u123)
;; Retrieves details of alert ID 123
```

### Updated Smart Contract Functions

#### Public Functions (Updated)
| Function | Description |
|----------|-------------|
| `register-sensor` | Register new sensor with coordinates |
| `submit-ph-reading` | Submit pH and temperature data |
| `submit-bulk-readings` | Submit multiple pH and temperature readings (up to 5) |
| `validate-reading` | Admin validates sensor reading |
| `transfer-tokens` | Transfer OHC tokens |
| `deactivate-sensor` | Disable sensor |
| `set-reward-rate` | Admin adjusts token rewards |
| `set-critical-ph-threshold` | Admin sets critical pH alert threshold |

#### Read-Only Functions (Updated)
| Function | Description |
|----------|-------------|
| `get-sensor-info` | Get sensor details |
| `get-ph-reading` | Get specific pH reading |
| `get-daily-average` | Get daily average for zone |
| `get-global-health-score` | Current ocean health percentage |
| `get-balance` | Check OHC token balance |
| `get-critical-ph-threshold` | Get current alert threshold |
| `get-critical-ph-alert` | Get specific critical alert details |

#OceanHealth #CriticalAlerts #EnvironmentalMonitoring

## 🔄 Sensor Location Update Feature

### 🌐 Dynamic Sensor Relocation
- **Adaptive Positioning**: Registered sensors can update GPS coordinates in real-time
- **Mobile Sensor Support**: Enables buoys that drift or relocate with ocean currents
- **Data Accuracy Enhancement**: Maintains precise geospatial tracking for acidification monitoring
- **Operational Flexibility**: Reduces need for sensor re-registration during deployments

#### Update Sensor Location
```clarity
(contract-call? .decentralized-ocean-acidification-tracker update-sensor-location 26000 -81000)
;; Updates sensor to new coordinates 26.0°N, 81.0°W
```

### Updated Smart Contract Functions

#### Public Functions (Updated)
| Function | Description |
|----------|-------------|
| `register-sensor` | Register new sensor with coordinates |
| `submit-ph-reading` | Submit pH and temperature data |
| `submit-bulk-readings` | Submit multiple pH and temperature readings (up to 5) |
| `validate-reading` | Admin validates sensor reading |
| `transfer-tokens` | Transfer OHC tokens |
| `deactivate-sensor` | Disable sensor |
| `set-reward-rate` | Admin adjusts token rewards |
| `set-critical-ph-threshold` | Admin sets critical pH alert threshold |
| `update-sensor-location` | Update GPS coordinates for active sensors |

#SensorMobility #AdaptiveMonitoring #GeoUpdates
