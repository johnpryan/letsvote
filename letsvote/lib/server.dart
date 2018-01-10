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
    router.post("/election", handleCreate);
    router.get("/election/{id}", handleGet);
    router.post("/election/{id}/user", handleJoin);
    router.post("/election/{id}/idea", handleSubmitIdea);
    router.post("/election/{id}/vote", handleVote);
    router.put("/election/{id}/close", handleClose);
  }

  Future<Response> handleCreate(Request req) async {
    var body = await req.readAsString();
    var request = new CreateElectionRequest.fromJson(JSON.decode(body));
    var election = _service.createElection(request.topic);
    return new Response.ok(JSON.encode(election));
  }

  Response handleGet(Request req) {
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

  Future<Response> handleSubmitIdea(Request req) async {
    var body = await req.readAsString();
    var id = getPathParameter(req, 'id');

    if (!_service.hasElection(id)) {
      return new Response.notFound("");
    }

    var request = new IdeaRequest.fromJson(JSON.decode(body));

    try {
      var election = _service.submitIdea(id, request.username, request.idea);
      return new Response.ok(JSON.encode(election));
    } on ServiceException catch (e) {
      return new Response.internalServerError(body: e.msg);
    }
  }

  Future<Response> handleVote(Request req) async {
    var body = await req.readAsString();
    var id = getPathParameter(req, 'id');

    if (!_service.hasElection(id)) {
      return new Response.notFound("");
    }

    var request = new IdeaRequest.fromJson(JSON.decode(body));

    try {
      var election = _service.vote(id, request.username, request.idea);
      return new Response.ok(JSON.encode(election));
    } on ServiceException catch (e) {
      return new Response.internalServerError(body: e.msg);
    }
  }

  Future<Response> handleClose(Request req) async {
    var id = getPathParameter(req, 'id');

    if (!_service.hasElection(id)) {
      return new Response.notFound("");
    }

    try {
      var election = _service.close(id);
      return new Response.ok(JSON.encode(election));
    } on ServiceException catch (e) {
      return new Response.internalServerError(body: e.msg);
    }

  }
}
