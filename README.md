# letsvote

LetsVote demonstrates how code can be shared across web, mobile, and the server.

It uses Flutter for iOS / Android, Polymer for the web, and
[shelf](https://pub.dartlang.org/packages/shelf) on the server

# How to run

Use pub to run the web app:

```
cd letsvote_web
pub serve
```

Use flutter to run the mobile app:

```
cd letsvote_mobile
flutter run
```

Use dart to run the web server:

```
cd letsvote_web
pub run bin/server.dart
```

# Configuration

To configure the web server each app points to:

*Web:* Use `letsvote_web/web/config.yaml`

*Flutter:* Use `letsvote_mobile/config.yaml` to configure what server the web connects to.

# IntellJ multi-module setup

It is convenient to have a single project that contains each sub-project as a
module.

1. open project settings (cmd+;)
2. open "Modules" page
3. remove the exisiting module
4. click "+" and select letsvote_mobile.iml file
5. click "+" and select letsvote_web.iml file
6. click "+" and select letsvote_server.iml file


After Step 3 Intellij will need the Flutter SDK to be set again. Go to
Preferences (cmd+,) and re-select your flutter SDK path
