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

class GetElection extends JsonRequest {
  GetElection(Uri host, String id) : super('GET', _createUri(host, id));

  static Uri _createUri(Uri host, String id) {
    return host.replace(path: 'election/$id');
  }
}

class JoinElection extends JsonRequest {
  JoinElection(Uri host, String username, String id)
      : super('POST', _createUri(host, id)) {
    body = JSON.encode(new JoinElectionRequest(username));
  }

  static Uri _createUri(Uri host, String id) {
    return host.replace(path: 'election/$id/user');
  }
}

class SubmitIdea extends JsonRequest {
  SubmitIdea(Uri host, String username, String idea, String id)
      : super('POST', _createUri(host, id)) {
    body = JSON.encode(new IdeaRequest(username, idea));
  }

  static Uri _createUri(Uri host, String id) {
    return host.replace(path: 'election/$id/idea');
  }
}

class Vote extends JsonRequest {
  Vote(Uri host, String username, String idea, String id)
      : super('POST', _createUri(host, id)) {
    body = JSON.encode(new IdeaRequest(username, idea));
  }

  static Uri _createUri(Uri host, String id) {
    return host.replace(path: 'election/$id/vote');
  }
}

class Close extends JsonRequest {
  Close(Uri host, String id)
      : super('PUT', _createUri(host, id));

  static Uri _createUri(Uri host, String id) {
    return host.replace(path: 'election/$id/close');
  }
}
