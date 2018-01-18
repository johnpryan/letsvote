# Sharing is Caring

There are [many tactics][code-reuse-tactics] for making code reusable. Most of
these focus on reusing code within the same app or project. For example, a
codebase that implements `calculateSalesTax()` for each product will be hard to
maintain.

But the type of reuse that is required for client-side programming is much more
difficult. An app may need to ship to all three of the major client-side
platforms: Android, iOS, and web. This type of reuse requires three things: 

1. A language that can run on all three platforms
2. Tools for building usable, professional, and beautiful UIs for each platform.
3. Good strategies for sharing important code with different UIs

Between Android and iOS, [Flutter][flutter] has proven it can bridge the gap.
But the Web is very different than mobile. There are important differences like
accessibility, XHR, and other web-only APIs. At the end of the day, web
developers still need to embrace the platform to deliver a good experience.

At AppTree, we calculate that we share ~70% of our codebase between all three
platforms. These are some tactics that worked for us. They are simple rules, but
not necessarily easy to implement. This post will focus on three rules:

1. Use a layered architecture
2. Remove logic from views.
3. Inject dependencies

## Layered architecture

Layering is a very common technique for breaking apart a complicated app. In the
context of client-side applications, the views and services are decoupled from
the rest of the application:

![layers](layers.png)

The Model is placed outside of the stack because it is often desirable to share
common types throughout your application, but this is not required. Usually it's
cumbersome to make each layer define it's own types. For example, three types
for UserLoginResponse (services), User (controllers), and UserViewModel
(views) may be overkill for your app.

The Controller is a placeholder for any important domain-specific code. It
does not necessarily mean to use a controller class. In fact, this layer can be
completely replaced with other patterns (Redux, Flux, or any other *Ux.) The
important thing is that the Views and Services are treated as abstract
interfaces.

The Views are where widgets (Flutter) and components (web) are defined.
Typically there is a higher-level view or widget that the controller is
interacting with. This view is not reusable across apps, but it may use views
that are very simple and reusable. It has a 1-to-1 relationship with the
controller. Views can be independent of their controller (simple), or treat their
controller as a Presenter (smart).

TODO: image

Services are any piece of your app that interacts with the platform or a remote
server. Firebase, JSON / HTTP services, Websockets, filesystem access, etc are
all examples of a service.

There are use-cases that don't lend themselves well to this layered
architecture. For example, a map. It makes much more sense to make the Views
(implemented in both Flutter or Web) responsible for using their own "service"
for displaying a map. On Flutter, it would be a Widget using a Plugin
(package:map_view) and an HTML library on web (package:google_maps) 

## Remove View Logic

Traditionally, views are platform-specific. Even if you are only building a
Flutter app, you may want:

1. Fast unit tests
2. To build command-line tools for interacting with services
3. A cleaner library and package structure

If you are also targeting web, you may want:
 
1. To make big changes to your architecture 
2. Fix bugs once

So as a rule of thumb, remove as much important logic from views as possible.

## Inject dependencies

Services may need to use different implementations on each platform. Firebase is
one example. You may choose to implement a high-level wrapper around your
firebase services and use the Flutter plugin on mobile, and the JavaScript
wrapper on web. For example:

```dart
abstract class MyFirebaseService {
  void save(AppData data);
  Stream<AppData> get onChanged;
  void init();
  void dispose();
}
```

This abstract service can be declared as a dependency:

```dart
class AppController {
  final MyFirebaseService _firebase;
  AppController(this._firebase);
}
```

And each entrypoint will create the `AppController` with the platform-specific
implementation.

## Example

At AppTree, we make mobile and web solutions for enterprise problems. Our users
have beautiful apps to work with their CRM, get their daily work done for
universities like Stanford, and more. But there's one problem that can waste a
lot of time: deciding where to get lunch.

### Let's Vote

Our solution is an app called Let's Vote. It will allow anyone to create an
election and submit an idea they think should win. Once the creator closes the
polls, it will display a winner. It will to display different pages:

```dart
enum Page {
  home, // create or join
  create, // enter topic
  joining, // enter id (skipped if using create)
  username, // enter username
  ideaSubmission, // enter an candidate
  ballot, // display each candidate (idea) and pick one
  waitingForVotes, // wait for the polls to close
  result, // show the winner
}
```

### Code Organization

Our project needs three packages:

1. letsvote: All platform-independent code (controllers, models, services,
interfaces) goes here
2. letsvote_moble
3. letsvote_web: the web app, including the Dart server hosting it. The server
includes a REST API for the web and mobile app to use.

Both the web and mobile packages import `letsvote` using the *path* keyword in
`pubspec.yaml`:

```yaml
dependencies:
  letsvote:
    path: ../letsvote
```


### Basic Types

First, we need to define a few basic types:

- Election: The parent object containing all information about an election that
a group of voters are participating in.
- Voter: a user with a unique name voting in an Election
- Idea: Something voters can vote for.

Each class can use `JsonSerializable` to generate `toJson()` methods automatically:

```dart
@JsonSerializable()
class Election extends _$ElectionSerializerMixin {
  final String id;
  final String topic;
  final List<Voter> voters;
  final List<Idea> ideas;
  bool pollsOpen;

  Election(this.id, this.topic, this.voters, this.ideas, this.pollsOpen);

  factory Election.fromJson(json) => _$ElectionFromJson(json);
}

@JsonSerializable()
class Voter extends _$VoterSerializerMixin {
  final String name;

  Voter(this.name);

  factory Voter.fromJson(json) => _$VoterFromJson(json);
}

@JsonSerializable()
class Idea extends _$IdeaSerializerMixin {
  final String name;
  final String authorName;
  int votes;

  Idea(this.name, this.authorName, this.votes);
  factory Idea.fromJson(json) => _$IdeaFromJson(json);
}
```

### HTTP API

The API for our server is a REST api built using shelf:

```dart
// letsvote/lib/election_server.dart
void configureRoutes(Router router) {
  router.post("/election", handleCreate);
  router.get("/election/{id}", handleGet);
  router.post("/election/{id}/user", handleJoin);
  router.post("/election/{id}/idea", handleSubmitIdea);
  router.post("/election/{id}/vote", handleVote);
  router.put("/election/{id}/close", handleClose);
}
```

### The Service Layer

These requests are defined as `package:http` requests in the requests library:

```dart
import 'dart:convert';
import 'package:http/http.dart';
import 'package:letsvote/model.dart';

class JsonRequest extends Request {
  JsonRequest(String method, Uri uri) : super(method, uri) {
    this.headers['Content-Type'] = 'application/json';
  }
}

class CreateElection extends JsonRequest {
  CreateElection(Uri host, String topic) : super('POST', _createUri(host)) {
    body = JSON.encode(new CreateElectionRequest(topic));
  }
  
  static Uri _createUri(Uri host) {
    return host.replace(path: 'election');
  }
}
```

The Dart client has types for each request and response. Each request is sent
using a Requester ([pub package](https://pub.dartlang.org/packages/requester)):

```dart
// letsvote/lib/services.dart
  Future<Election> create(String topic) async {
    var request = new requests.CreateElection(host, topic);
    var response = await requester.send(request);
    return new Election.fromJson(JSON.decode(response.body));
  }
```

### The Controller Layer

Our app needs an `AppController` to manage the state for our current user. It
needs to store:

1. The last known state of the election (the Election class)
2. The current Page
3. The unique username of the current voter
4. The abstract AppView to update when the state changes

This layer is built using an MVP-style but could use Redux, Flux, or other
patterns to manage state and update the view.

### The View Layer

In this example, our View implemented has access to the controller and can
access it's public API to determine how it should render. To wire up this
relationship, we use `AppController.init()`:

```dart
  Future init(AppView view) async {
    // ...
    _view = view;
    _view.controller = this;
    // ...
  }
```

Each "view" in flutter accesses the controller's API to inform it the user is
interacting with the app:

```dart
class HomePage extends StatelessWidget {
  final AppController _controller;
  HomePage(this._controller);
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Let's Vote!"),
        new Text("Create a new vote or join an existing vote"),
        new MaterialButton(
          child: new Text("Create"),
          onPressed: () => _controller.startByCreating(),
        ),
        new MaterialButton(
          child: new Text("Join"),
          onPressed: () => _controller.startByJoining(),
        ),
      ],
    );
  }
}
```

`startByCreating` and `startByJoining` have different implementations that
result in updating the state of the Controller (the page) and possibly making
requests.

It's worth mentioning that this relationship could be implemented differently:

1. Each view could have an abstract interface for it's controller
2. Each view could emit events on a Stream that the controller listens to

### The App

https://letsvote-dart.herokuapp.com/

## Closing thoughts

We've found that following these three rules allows us to share the most code
between mobile and web:

1. Use a layered architecture
2. Remove logic from views.
3. Inject dependencies

But don't overdo it. Refactoring is fun (code golf at work!), but can be a time
sink.

## FAQ

### IntelliJ Setup

IntelliJ can support a Dart project with multiple packages using modules. To set up
three different modules:

1. Open project settings (cmd+;)
2. Go to Modules
3. select letsvote_mobile.iml
4. select letsvote_server.iml
5. select letsvote_web.iml

Then go to Preferences and re-select your Flutter SDK if it is not selected.

### Heroku Setup

This project can run on heroku.
 
1. Specify this buildpack https://github.com/johnpryan/heroku-buildpack-dart ,
    which supports a special flag for specifying the Dart build directory.
2. set DART_BUILD_DIR_OVERRIDE to letsvote_web
3. set DART_SDK_URL https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip
4. set PATH /app/bin:/usr/local/bin:/usr/bin:/bin:/app/dart-sdk/bin

### What about routing?

This app doesn't use Flutter or Browser-based routing. It might be possible to build
a shared abstraction for flutter's Navigator and `route_hierarchical`. But more likely
the solution will involve some custom code for each platform.

[code-reuse-tactics]: https://stackoverflow.com/questions/268258/how-do-you-make-code-reusable
[flutter]: https://flutter.io
