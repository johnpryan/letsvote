library revolution.generate_models;

import 'dart:async';
import 'package:build_runner/build_runner.dart';
import 'package:source_gen/source_gen.dart';
import 'package:json_serializable/generators.dart';

Future<Null> main() async {
  await build([
    new BuildAction(
      new PartBuilder([new JsonSerializableGenerator()]),
      'letsvote',
      inputs: [
        'lib/model.dart',
      ],
    ),
  ]);
}
