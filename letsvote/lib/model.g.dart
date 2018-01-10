// GENERATED CODE - DO NOT MODIFY BY HAND

part of letsvote.model;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Election _$ElectionFromJson(Map<String, dynamic> json) => new Election(
    json['id'] as String,
    json['topic'] as String,
    (json['voters'] as List)
        ?.map((e) => e == null ? null : new Voter.fromJson(e))
        ?.toList());

abstract class _$ElectionSerializerMixin {
  String get id;
  String get topic;
  List<Voter> get voters;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'topic': topic, 'voters': voters};
}

Voter _$VoterFromJson(Map<String, dynamic> json) =>
    new Voter(json['name'] as String);

abstract class _$VoterSerializerMixin {
  String get name;
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name};
}

CreateElectionRequest _$CreateElectionRequestFromJson(
        Map<String, dynamic> json) =>
    new CreateElectionRequest(json['topic'] as String);

abstract class _$CreateElectionRequestSerializerMixin {
  String get topic;
  Map<String, dynamic> toJson() => <String, dynamic>{'topic': topic};
}

JoinElectionRequest _$JoinElectionRequestFromJson(Map<String, dynamic> json) =>
    new JoinElectionRequest(json['username'] as String);

abstract class _$JoinElectionRequestSerializerMixin {
  String get username;
  Map<String, dynamic> toJson() => <String, dynamic>{'username': username};
}

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) =>
    new AppConfig(json['host'] as String);

abstract class _$AppConfigSerializerMixin {
  String get host;
  Map<String, dynamic> toJson() => <String, dynamic>{'host': host};
}
