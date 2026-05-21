# QR Device

Shop admin companion app for the **Loop loyalty program**. Generate collect QR codes, scan customer redemption codes, and manage stamp programs — all from a single mobile interface.

## Features

- **🔐 Shop Admin Auth** — JWT-based login/logout with secure token storage
- **📋 Active Stamps** — View all active stamp programs for your shop
- **🔲 Collect QR** — Generate time-limited QR codes (with countdown) for customers to scan and collect stamps
- **📷 Scan Redemption QR** — Scan customer QR codes to confirm stamp or points redemptions
- **🏷️ Filter Stamps** — Filter stamp cards by type (All / Discount / Free Item)
- **🔢 Quantity Control** — Adjust stamp collect quantity before generating QR

## Screens

| Screen | Description |
|--------|-------------|
| Splash | Auto-login check, routes to Home or Login |
| Login | Animated login form with email/password validation |
| Home (Stamps tab) | Lists active stamp programs with filter chips and quantity controls |
| Home (Scan tab) | Two quick-action buttons: Scan Stamp QR / Scan Points QR |
| QR Scanner | Live camera scanner using `mobile_scanner` |
| QR Dialog | Displays generated QR with a live countdown timer (2 min expiry) |

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (Dart) |
| State Management | Provider + GetX |
| QR Generation | `qr_flutter` |
| QR Scanning | `mobile_scanner` |
| HTTP | `http` package |
| Token Storage | `shared_preferences` |
| Backend | ASP.NET Core 10 Web API (Loop Loyalty) |

## Architecture

```
lib/
├── constants/          # App-wide constants (colors)
├── controllers/        # ChangeNotifier providers (Auth, Stamps)
├── core/
│   ├── network/        # API service + URL constants
│   └── services/       # Token persistence
├── models/             # Data models (StampModel)
├── views/
│   ├── screens/        # Full-screen pages
│   │   ├── scan/       # QR scanner + scan actions
│   │   └── stamps/     # Stamp list + QR generation
│   └── widgets/        # Reusable UI components
└── widgets/            # Shared utility widgets
```

## Backend API

The app connects to the Loop Loyalty API (`/api`). The full API reference is in [docs/shop-admin-api.txt](docs/shop-admin-api.txt).

Key endpoints used:
- `POST /api/shop-admins/login` — Authenticate
- `GET /api/stamps/active` — List active stamp programs
- `POST /api/stamps/{id}/collection-qr` — Generate collect QR
- `POST /api/stamps/redemption-qr/confirm` — Confirm stamp redemption
- `POST /api/shop-admins/points/redemption-qr/confirm` — Confirm points redemption

## Getting Started

### Prerequisites

- Flutter SDK ^3.5.3
- A running instance of the Loop Loyalty backend API

### Setup

```bash
# Clone the repo
git clone <repo-url>
cd qr_device

# Install dependencies
flutter pub get

# Update the backend URL
# Edit lib/core/network/api_url.dart and set baseUrl to your backend address

# Run
flutter run
```

### Configuration

The backend base URL is configured in `lib/core/network/api_url.dart`:

```dart
static const String baseUrl = 'http://<your-backend>:8080/api';
```
