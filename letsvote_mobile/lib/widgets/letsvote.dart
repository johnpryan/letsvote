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
      body: new Container(
        color: Colors.grey[100],
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            new Card(
              child: new Padding(
                padding: new EdgeInsets.all(12.0),
                child: _currentPageWidget(),
              ),
            ),
          ],
        ),
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
        return new ResultsPage(_controller);
      default:
        return new HomePage(_controller);
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

  void showDialog(String message) {
    // TODO: implement showDialog
  }
}

class HomePage extends StatelessWidget {
  final AppController _controller;
  HomePage(this._controller);
  Widget build(BuildContext context) {
    return new PaddedColumn(
      children: <Widget>[
        new Text("Let's Vote!"),
        new Text("Create a new vote or join an existing vote"),
        new MaterialButton(
          color: Colors.blueGrey,
          textColor: Colors.white,
          child: new Text("Create"),
          onPressed: () => _controller.startByCreating(),
        ),
        new MaterialButton(
          color: Colors.blueGrey,
          textColor: Colors.white,
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
    return new PaddedColumn(
      children: <Widget>[
        new Text("Create a new vote:"),
        new TextField(controller: textController),
        new MaterialButton(
          color: Colors.blueGrey,
          textColor: Colors.white,
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

class _JoiningPageState extends State<JoiningPage> {
  TextEditingController textController;
  _JoiningPageState() : textController = new TextEditingController();

  Widget build(BuildContext context) {
    return new PaddedColumn(
      children: <Widget>[
        new Text("Enter the code for your vote:"),
        new TextField(
          controller: textController,
          maxLength: 4,
        ),
        new MaterialButton(
          color: Colors.blueGrey,
          textColor: Colors.white,
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

class _UsernamePageState extends State<UsernamePage> {
  TextEditingController textController;

  _UsernamePageState() : textController = new TextEditingController();

  Election get election => widget._controller.election;

  Widget build(BuildContext context) {
    return new PaddedColumn(
      children: <Widget>[
        new Text("code: ${election.id}"),
        new Text("Enter your name:"),
        new TextField(controller: textController),
        new MaterialButton(
          color: Colors.blueGrey,
          textColor: Colors.white,
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

class _IdeaSubmissionPageState extends State<IdeaSubmissionPage> {
  TextEditingController textController;
  _IdeaSubmissionPageState() : textController = new TextEditingController();

  Election get election => widget._controller.election;

  Widget build(BuildContext context) {
    return new PaddedColumn(
      padding: new EdgeInsets.all(8.0),
      children: <Widget>[
        new Text("Enter an Idea"),
        new Text("code: ${election.id}"),
        new Text("Topic: ${election.topic}"),
        new TextField(controller: textController),
        new MaterialButton(
          color: Colors.blueGrey,
          textColor: Colors.white,
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

class _BallotPage extends State<BallotPage> {
  String _selectedIdeaName;
  _BallotPage();

  Election get election => widget._controller.election;

  Widget build(BuildContext context) {
    var children = <Widget>[
      new Text("code: ${election.id}"),
      new Text("Topic: ${election.topic}"),
      new Text("You don't have to vote yet! More options may appear."),
    ];

    var radios = election.ideas.map((i) {
      return new RadioListTile(
        title: new Text(i.name),
        value: i.name,
        groupValue: _selectedIdeaName,
        onChanged: _handleRadioChanged,
      );
    }).toList();
    children.addAll(radios);

    children.add(
      new MaterialButton(
        color: Colors.blueGrey,
        textColor: Colors.white,
        child: new Text("Vote"),
        onPressed: _selectedIdeaName == null ? null : _handleVote,
      ),
    );

    return new PaddedColumn(
      children: children,
    );
  }

  void _handleRadioChanged(String name) {
    setState(() {
      _selectedIdeaName = name;
    });
  }

  void _handleVote() {
    widget._controller.submitVote(_selectedIdeaName);
  }
}

class WaitingForVotesPage extends StatefulWidget {
  final AppController _controller;
  WaitingForVotesPage(this._controller);
  State<StatefulWidget> createState() {
    return new _WaitingForVotesPageState();
  }
}

class _WaitingForVotesPageState extends State<WaitingForVotesPage> {
  _WaitingForVotesPageState();

  Election get election => widget._controller.election;

  Widget build(BuildContext context) {
    var children = <Widget>[
      new Text("code: ${election.id}"),
      new Text("Topic: ${election.topic}"),
      new Text("waiting for the polls to close..."),
    ];

    if (widget._controller.isCreator) {
      children.add(
        new MaterialButton(
          color: Colors.blueGrey,
          textColor: Colors.white,
          onPressed: () => widget._controller.submitClose(election.id),
          child: new Text("Close Polls"),
        ),
      );
    }

    return new PaddedColumn(
      children: children,
    );
  }
}

class ResultsPage extends StatefulWidget {
  final AppController _controller;
  ResultsPage(this._controller);
  State<StatefulWidget> createState() {
    return new _ResultsPageState();
  }
}

class _ResultsPageState extends State<ResultsPage> {
  _ResultsPageState();

  Election get election => widget._controller.election;

  Widget build(BuildContext context) {
    var children = <Widget>[
      new Text("code: ${election.id}"),
      new Text("Topic: ${election.topic}"),
      new Text("Winner: ${election.winner.name}"),
      new Text("Author: ${election.winner.authorName}"),
      new Text("Votes: ${election.winner.votes}"),
    ];

    return new PaddedColumn(
      children: children,
    );
  }
}

class PaddedColumn extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final List<Widget> children;
  PaddedColumn({this.padding = const EdgeInsets.all(8.0), this.children});

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: this
          .children
          .map((c) => new Padding(
                padding: this.padding,
                child: c,
              ))
          .toList(),
    );
  }
}
