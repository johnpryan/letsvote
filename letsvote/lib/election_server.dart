import 'dart:math' as math;
import 'package:letsvote/model.dart';

class ElectionServer {
  final Map<String, Election> _elections;

  ElectionServer() : _elections = {};

  Election createElection(String topic) {
    var id = _getNextId();
    var e = new Election(id, topic, [], [], true);
    _elections[id] = e;
    return e;
  }

  Election getElection(String id) {
    return _elections[id];
  }

  bool hasElection(String id) {
    return getElection(id) != null;
  }

  Election joinElection(String id, String username) {
    var election = getElection(id);
    for (var voter in election.voters) {
      if (voter.name == username) {
        throw new ServiceException("username already exists");
      }
    }
    election.voters.add(new Voter(username));
    return election;
  }

  Election submitIdea(String electionId, String authorName, String ideaName) {
    var election = getElection(electionId);
    var existing = election.ideas
        .firstWhere((i) => i.name == ideaName, orElse: () => null);

    if (existing != null) {
      // todo: error handling
      return election;
    }

    var idea = new Idea(ideaName, authorName, 0);
    election.ideas.add(idea);
    return election;
  }

  Election vote(String electionId, String authorName, String ideaName) {
    var election = getElection(electionId);
    var existing = election.ideas
        .firstWhere((i) => i.name == ideaName, orElse: () => null);

    if (existing == null) {
      // todo: error handling
      return election;
    }

    if (existing.authorName == authorName) {
      return election;
    }

    existing.votes += 1;

    return election;
  }

  Election close(String electionId) {
    var election = getElection(electionId);
    election.pollsOpen = false;
    return election;
  }

  String _getNextId() {
    String next;
    do {
      next = _generateFourDigitId();
    } while (_elections.containsKey(next));
    return next;
  }

  static String _generateFourDigitId() {
    const chars = "abcdefghijklmnopqrstuvwxyz123456789";
    var random = new math.Random();
    var len = 4;
    var id = "";
    while (len > 0) {
      id += chars[random.nextInt(chars.length)].toUpperCase();
      len--;
    }
    return id;
  }
}

class ServiceException implements Exception {
  final String msg;
  ServiceException(this.msg);
}
