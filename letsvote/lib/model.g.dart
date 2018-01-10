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
        ?.toList(),
    (json['ideas'] as List)
        ?.map((e) => e == null ? null : new Idea.fromJson(e))
        ?.toList(),
    json['pollsOpen'] as bool);

abstract class _$ElectionSerializerMixin {
  String get id;
  String get topic;
  List<Voter> get voters;
  List<Idea> get ideas;
  bool get pollsOpen;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'topic': topic,
        'voters': voters,
        'ideas': ideas,
        'pollsOpen': pollsOpen
      };
}

Voter _$VoterFromJson(Map<String, dynamic> json) =>
    new Voter(json['name'] as String);

abstract class _$VoterSerializerMixin {
  String get name;
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name};
}

Idea _$IdeaFromJson(Map<String, dynamic> json) => new Idea(
    json['name'] as String, json['authorName'] as String, json['votes'] as int);

abstract class _$IdeaSerializerMixin {
  String get name;
  String get authorName;
  int get votes;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name': name, 'authorName': authorName, 'votes': votes};
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

IdeaRequest _$IdeaRequestFromJson(Map<String, dynamic> json) =>
    new IdeaRequest(json['username'] as String, json['idea'] as String);

abstract class _$IdeaRequestSerializerMixin {
  String get username;
  String get idea;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'username': username, 'idea': idea};
}

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) =>
    new AppConfig(json['host'] as String);

abstract class _$AppConfigSerializerMixin {
  String get host;
  Map<String, dynamic> toJson() => <String, dynamic>{'host': host};
}
