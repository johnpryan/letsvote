import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:letsvote/controllers.dart';
import 'package:letsvote/model.dart';
import 'package:letsvote/services.dart';
import 'package:letsvote_mobile/services.dart';

class LetsVote extends StatefulWidget {
  _LetsVoteState createState() => new _LetsVoteState();
}

class _LetsVoteState extends State<LetsVote> implements AppView {
  AppController _controller;
  Page _page;

  void initState() {
    super.initState();
    var client = new Client();
    var services = new AppServices(new FlutterConfigService(client));
    var appContext = new AppContext(client, services);
    var controller = new AppController(appContext);
    controller.init(this);
  }

  Widget build(BuildContext context) {
    if (_page == null) {
      return new CircularProgressIndicator();
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Let's Vote!"),
      ),
      body: new Center(
        child: _currentPageWidget(),
      ),
    );
  }

  Widget _currentPageWidget() {
    switch (_page) {
      case Page.home:
        return new HomePage(_controller);
      case Page.create:
        return new CreatePage(_controller);
      case Page.joining:
        return new JoiningPage(_controller);
      case Page.username:
        return new UsernamePage(_controller);
      case Page.ideaSubmission:
        return new IdeaSubmissionPage(_controller);
      case Page.ballot:
        return new BallotPage(_controller);
      case Page.waitingForVotes:
        return new WaitingForVotesPage(_controller);
      case Page.result:
    }
  }

  set controller(AppController controller) {
    _controller = controller;
  }

  void renderPage(Page page) {
    setState(() {
      _page = page;
    });
  }
}

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

class CreatePage extends StatefulWidget {
  final AppController _controller;
  CreatePage(this._controller);
  State<StatefulWidget> createState() {
    return new _CreatePageState();
  }
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController textController;
  _CreatePageState() : textController = new TextEditingController();

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Create a new vote:"),
        new TextField(controller: textController),
        new MaterialButton(
          child: new Text("Submit"),
          onPressed: () => widget._controller.create(textController.text),
        ),
      ],
    );
  }
}

class JoiningPage extends StatefulWidget {
  final AppController _controller;
  JoiningPage(this._controller);
  State<StatefulWidget> createState() {
    return new _JoiningPageState();
  }
}

class _JoiningPageState extends State<CreatePage> {
  TextEditingController textController;
  _JoiningPageState() : textController = new TextEditingController();

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Enter the code for your vote:"),
        new TextField(
          controller: textController,
          maxLength: 4,
        ),
        new MaterialButton(
          child: new Text("Submit"),
          onPressed: () => widget._controller.goTo(Page.username),
        ),
      ],
    );
  }
}

class UsernamePage extends StatefulWidget {
  final AppController _controller;
  UsernamePage(this._controller);
  State<StatefulWidget> createState() {
    return new _UsernamePageState();
  }
}

class _UsernamePageState extends State<CreatePage> {
  TextEditingController textController;

  _UsernamePageState() : textController = new TextEditingController();

  Election get election => widget._controller.election;

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("code: ${election.id}"),
        new Text("Enter your name:"),
        new TextField(controller: textController),
        new MaterialButton(
          child: new Text("Submit"),
          onPressed: () => widget._controller.setName(textController.text),
        ),
      ],
    );
  }
}

class IdeaSubmissionPage extends StatefulWidget {
  final AppController _controller;
  IdeaSubmissionPage(this._controller);
  State<StatefulWidget> createState() {
    return new _IdeaSubmissionPageState();
  }
}

class _IdeaSubmissionPageState extends State<CreatePage> {
  TextEditingController textController;
  _IdeaSubmissionPageState() : textController = new TextEditingController();

  Election get election => widget._controller.election;

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("code: ${election.id}"),
        new Text("Topic: ${election.topic}"),
        new TextField(controller: textController),
        new MaterialButton(
          child: new Text("Submit"),
          onPressed: () => widget._controller.setIdea(textController.text),
        ),
      ],
    );
  }
}

class BallotPage extends StatefulWidget {
  final AppController _controller;
  BallotPage(this._controller);
  State<StatefulWidget> createState() {
    return new _BallotPage();
  }
}

class _BallotPage extends State<CreatePage> {
  TextEditingController textController;
  _BallotPage() : textController = new TextEditingController();

  Election get election => widget._controller.election;

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("code: ${election.id}"),
        new Text("Topic: ${election.topic}"),
        new TextField(controller: textController),
        new MaterialButton(
          child: new Text("Submit"),
          onPressed: () => widget._controller.submitVote(textController.text),
        ),
        new Text("You don't have to vote yet! More options may appear."),
      ],
    );
  }
}

class WaitingForVotesPage extends StatefulWidget {
  final AppController _controller;
  WaitingForVotesPage(this._controller);
  State<StatefulWidget> createState() {
    return new _WaitingForVotesPageState();
  }
}

class _WaitingForVotesPageState extends State<CreatePage> {
  TextEditingController textController;
  _WaitingForVotesPageState() : textController = new TextEditingController();

  Election get election => widget._controller.election;

  Widget build(BuildContext context) {
    var children = <Widget>[
        new Text("code: ${election.id}"),
        new Text("Topic: ${election.topic}"),
      ];

    if (widget._controller.isCreator) {
      children.add(new MaterialButton(onPressed: null))
    }

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}