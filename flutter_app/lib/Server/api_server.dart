import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/Models/catalog_item.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

final _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PATCH, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type',
};

Future<Response> _apiHandler(Request req) async {
  final path = req.url.path;
  final method = req.method.toUpperCase();

  // GET /items (All items)
  if (method == 'GET' && path == 'items') {
    final List<CatalogItem> items = [];

    return Response.ok(
      jsonEncode(items.map((i) => i.toJson()).toList()),
      headers: {'Content-Type': 'application/json', ..._corsHeaders},
    );
  }

  // Get /items/:id (Item by id)
  if (method == 'GET' && path.startsWith('items/')) {
    final id = path.split('/')[1];

    final CatalogItem mockItem = CatalogItem(
      id: id,
      title: "Api Test",
      description: "Mock item",
      category: "Test",
      tags: ["Api", "Test"],
    );

    if (mockItem == null) {
      return Response.notFound(
        jsonEncode({'error': 'Item with id($id) not found'}),
        headers: _corsHeaders,
      );
    }

    return Response.ok(
      jsonEncode(mockItem.toJson()),
      headers: {'Content-Type': 'application/json', ..._corsHeaders},
    );
  }

  // POST /items (Creation)
  if (method == 'POST' && path == 'items') {
    final data = await req.readAsString();
    final body = jsonDecode(data);

    final invalidFields = validateTextInBody(body);
    if (invalidFields.isNotEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'invalid characters in [${invalidFields.join(', ')}]',
        }),
        headers: _corsHeaders,
      );
    }

    final created = CatalogItem.fromJson(body);

    return Response.ok(
      jsonEncode(created.toJson()),
      headers: {'Content-Type': 'application/json', ..._corsHeaders},
    );
  }

  // PATCH /items/:id/approve
  if (method == "PATCH" &&
      path.startsWith('items/') &&
      path.endsWith('/approved')) {
    final id = path.split('/')[1];

    final CatalogItem mockItem = CatalogItem(
      id: id,
      title: "Api Test",
      description: "Mock item",
      category: "Test",
      tags: ["Api", "Test"],
    );

    final approved = mockItem;

    if (approved == null) {
      return Response.badRequest(
        body: jsonEncode({'error': 'Cannot approve item. Score is under 90'}),
        headers: _corsHeaders,
      );
    }

    return Response.ok(
      jsonEncode(approved.toJson()),
      headers: {'Content-Type': 'application/json', ..._corsHeaders},
    );
  }

  // Default Response 404
  return Response.notFound(jsonEncode({'error': 'Route not found'}));
}

validateText(String text) {
  final RegExp allowed = RegExp(r'^[a-zA-Z0-9\s]+$');

  return allowed.hasMatch(text);
}

List<String> validateTextInBody(Map<String, dynamic> body) {
  final List<String> invalidTexts = [];

  body.forEach((key, value) {
    if (key != 'approved' && key != 'qualityScore') {
      if (key == 'tags') {
        final containsInvalidText = (value as List).any(
          (value) => validateText(value as String) == false,
        );
        if (containsInvalidText) {
          invalidTexts.add(key);
        }
      } else if (!validateText(value)) {
        invalidTexts.add(key);
      }
    }
  });

  return invalidTexts;
}

Future<void> main({int port = 8080}) async {
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_apiHandler);

  final server = await io.serve(handler, InternetAddress.loopbackIPv4, port);
  print('✅ API Server running at http://${server.address.host}:${server.port}');
}
