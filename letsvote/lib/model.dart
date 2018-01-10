library letsvote.model;

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Election extends _$ElectionSerializerMixin {
  final String id;
  final String topic;
  final List<Voter> voters;
  final List<Idea> ideas;
  bool pollsOpen;

  Election(this.id, this.topic, this.voters, this.ideas, this.pollsOpen);

  factory Election.fromJson(json) => _$ElectionFromJson(json);

  Idea get winner {
    var sorted = new List<Idea>.from(ideas)..sort((a, b) => a.votes - b.votes);
    if (sorted.isEmpty) {
      return null;
    }
    return sorted.reversed.first;
  }
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

@JsonSerializable()
class CreateElectionRequest extends _$CreateElectionRequestSerializerMixin {
  final String topic;

  CreateElectionRequest(this.topic);

  factory CreateElectionRequest.fromJson(json) =>
      _$CreateElectionRequestFromJson(json);
}

@JsonSerializable()
class JoinElectionRequest extends _$JoinElectionRequestSerializerMixin {
  final String username;

  JoinElectionRequest(this.username);

  factory JoinElectionRequest.fromJson(json) =>
      _$JoinElectionRequestFromJson(json);
}

/// Used for both voting and idea submission
@JsonSerializable()
class IdeaRequest extends _$IdeaRequestSerializerMixin {
  final String username;
  final String idea;

  IdeaRequest(this.username, this.idea);

  factory IdeaRequest.fromJson(json) => _$IdeaRequestFromJson(json);
}

@JsonSerializable()
class AppConfig extends _$AppConfigSerializerMixin {
  final String host;
  AppConfig(this.host);
  factory AppConfig.fromJson(json) => _$AppConfigFromJson(json);
}
