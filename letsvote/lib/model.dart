library letsvote.model;

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Election extends _$ElectionSerializerMixin {
  final String id;
  final String topic;
  final List<Voter> voters;

  Election(this.id, this.topic, this.voters);

  factory Election.fromJson(json) => _$ElectionFromJson(json);
}

@JsonSerializable()
class Voter extends _$VoterSerializerMixin {
  final String name;

  Voter(this.name);

  factory Voter.fromJson(json) => _$VoterFromJson(json);
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

@JsonSerializable()
class AppConfig extends _$AppConfigSerializerMixin {
  final String host;
  AppConfig(this.host);
  factory AppConfig.fromJson(json) => _$AppConfigFromJson(json);
}
