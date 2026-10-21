# JIP Company Management — Frontend

A Flutter application for managing companies and their services through the JIP REST API.

## Features

- View companies, registration numbers, and associated services.
- Create a company with form validation.
- Create a service with a company dropdown.
- Validate required fields and service prices.
- Display API loading states and error messages.
- Refresh the company list after creating records.

## Tech Stack

- Flutter and Dart
- Material Design
- Provider for state management
- HTTP for REST API requests

## Prerequisites

- Flutter SDK
- Dart SDK (included with Flutter)
- JIP backend running locally
- Google Chrome for web testing

## Setup

1. Clone the repository and navigate to the frontend folder.
2. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

3. Ensure the backend is running and accessible at:

   `http://localhost:3000`

4. Check the Flutter environment:

   ```bash
   flutter doctor
   ```

## Run the Application

Launch the app in Chrome:

```bash
flutter run -d chrome
```

## Validation

Run static analysis:

```bash
flutter analyze
```

Run Flutter tests:

```bash
flutter test
```

## API Configuration

The API base URL is configured in `lib/services/api_service.dart`.

Default local development URL:

`http://localhost:3000`

For Android emulator testing, use `http://10.0.2.2:3000`. For a physical device, use the backend computer's reachable local IP address and ensure the network and firewall permit access.

## Main Screens

- **Company List:** Displays companies and their associated services.
- **Create Company:** Creates a company with a name and registration number.
- **Create Service:** Creates a service linked to a selected company, including its description and price.
