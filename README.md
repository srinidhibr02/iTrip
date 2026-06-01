# iTrip

**Taste the journey, before it begins.**

AI-powered smart travel companion and trip advisor for India — road trips, tourism, budget planning, and real-time travel intelligence.

## Features

- **Smart Trip Advisor** — Multi-day planner with AI suggestions, trip types & modes
- **Nearby Discovery** — Attractions, waterfalls, restaurants, fuel, EV charging, hotels
- **Intelligent Routes** — Scenic, fastest, safest, budget & bike-friendly options
- **Experience Before You Travel** — Road preview, ghats, weather, timeline (USP)
- **Budget Estimator** — Fuel, tolls, stay, food with backpacker/luxury modes
- **Tour Packages** — Adventure, bike tours, family holidays
- **AI Travel Advisor** — Conversational route, hotel & weather assistance
- **Community** — Trip stories, hazard reports, route reviews
- **Emergency & Safety** — SOS, helplines, live location sharing
- **Gamification** — Badges, explorer levels, leaderboard

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (Dart 3.9+) |
| State | Riverpod |
| Navigation | GoRouter |
| Backend | Firebase (Auth, Firestore, Storage, FCM, Analytics, Crashlytics) |
| Maps | Google Maps Flutter, Geolocator |
| Offline | Hive |
| Architecture | Clean Architecture, Repository Pattern |

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── app.dart                  # Root widget
├── bootstrap.dart            # Initialization
├── core/                     # Theme, router, constants, widgets
├── domain/entities/          # Business entities
├── data/                     # Repositories, datasources
└── features/                 # Feature modules (presentation)
    ├── splash/
    ├── onboarding/
    ├── auth/
    ├── home/
    ├── trip_planner/
    ├── nearby/
    ├── routes/
    ├── experience/
    ├── budget/
    ├── packages/
    ├── community/
    ├── profile/
    ├── settings/
    ├── ai_assistant/
    ├── emergency/
    ├── gamification/
    └── map/
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Firebase project
- Google Maps API key

### Setup

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Environment variables**
   ```bash
   cp .env.example .env
   # Add your API keys to .env
   ```

   **Android Maps key** — add to `android/local.properties`:
   ```
   GOOGLE_MAPS_API_KEY=your_key_here
   ```

3. **Firebase**
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   Update `lib/bootstrap.dart` to use `DefaultFirebaseOptions.currentPlatform`.

4. **Deploy Firestore rules**
   ```bash
   firebase deploy --only firestore:rules
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Demo Mode

Use **"Continue as Guest (Demo)"** on the login screen to explore the app without Firebase credentials.

## Firebase Collections

| Collection | Purpose |
|------------|---------|
| `users` | User profiles |
| `trips` | Trip plans |
| `routes` | Route data & reviews |
| `reviews` | Place/route reviews |
| `packages` | Tour packages |
| `posts` | Community feed |
| `notifications` | Push notifications |
| `saved_places` | Bookmarked places |
| `expenses` | Group trip expenses |

## Configuration Checklist

- [ ] Run `flutterfire configure`
- [ ] Add `google-services.json` (Android) & `GoogleService-Info.plist` (iOS)
- [ ] Set Google Maps API key in `.env` and `AndroidManifest.xml`
- [ ] Enable Firebase Auth, Firestore, Storage, FCM in console
- [ ] Deploy `firebase/firestore.rules`

## License

Proprietary — iTrip © 2025
