# fitness_app

A new Flutter project.

## Local API authentication

The app's login and sign-up screens use the Express API in the `fitness_api`
folder. Start it with `node server.js` from that folder after configuring its
database.

The default API address is `http://10.0.2.2:3000` on the Android emulator and
`http://localhost:3000` on desktop targets. For a physical device, pass the
computer's LAN address when starting Flutter:

```shell
flutter run --dart-define=FITNESS_API_URL=http://<computer-ip>:3000
```

Sign-up asks for username, email, and password. Since the API also requires a
name, the app sends the username as the name. The API hashes passwords with
bcrypt; password hashing is not done in the app. The debug Android build allows
HTTP for local development only. Use HTTPS for a deployed API.
Browser builds also need CORS enabled on the API server.

## App structure

- `lib/screens/` contains the login, sign-up, and dashboard views.
- `lib/view_models/` contains authentication and dashboard UI state.
- `lib/services/` handles API requests.
- `lib/widgets/` contains reusable form controls, dashboard cards, and navigation.
- `lib/theme/` and `lib/models/` hold shared styling and navigation destinations.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
