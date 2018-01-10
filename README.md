# letsvote

LetsVote demonstrates how code can be shared across web, mobile, and the server.

It uses Flutter for iOS / Android, Polymer for the web, and
[shelf](https://pub.dartlang.org/packages/shelf) on the server

# How to run

Use pub to run the web app:

```
cd letsvote_web
pub get
pub serve
```

Use flutter to run the mobile app:

```
cd letsvote_mobile
flutter packages get
flutter run
```

Use dart to run the web server:

```
cd letsvote_web
pub get
pub run bin/server.dart
```

# Configuration

Use `letsvote_web/web/config.yaml` to configure what server the web connects to.



