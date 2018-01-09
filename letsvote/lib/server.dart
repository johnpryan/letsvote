library letsvote.server;

import 'dart:async';
import 'dart:convert';

import 'package:letsvote/election_server.dart';
import 'package:letsvote/model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_route/shelf_route.dart';

class Server {
  ElectionServer _service;

  Server() : _service = new ElectionServer();

  void configureRoutes(Router router) {
    router.post("/create", handleCreate);
    router.post("/check/{id}", handleCheck);
    router.post("/join/{id}", handleJoin);
  }

  Future<Response> handleCreate(Request req) async {
    var body = await req.readAsString();
    var request = new CreateElectionRequest.fromJson(JSON.decode(body));
    var election = _service.createElection(request.topic);
    return new Response.ok(JSON.encode(election));
  }

  Response handleCheck(Request req) {
    var id = getPathParameter(req, 'id');
    var election = _service.getElection(id);
    if (election == null) {
      return new Response.notFound("");
    }
    return new Response.ok(JSON.encode(election));
  }

  Future<Response> handleJoin(Request req) async {
    var body = await req.readAsString();
    var id = getPathParameter(req, 'id');

    if (!_service.hasElection(id)) {
      return new Response.notFound("");
    }

    var request = new JoinElectionRequest.fromJson(JSON.decode(body));

    try {
      var election = _service.joinElection(id, request.username);
      return new Response.ok(JSON.encode(election));
    } on ServiceException catch (e) {
      return new Response.internalServerError(body: e.msg);
    }
  }
}
