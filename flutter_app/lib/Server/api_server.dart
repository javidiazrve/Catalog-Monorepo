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

List<CatalogItem> items = [
  CatalogItem(
    id: "aaghiofoqeiw35",
    title: "Api Test",
    description: "Mock item",
    category: "Test",
    tags: ["Api", "Test"],
    approved: true,
    qualityScore: 90,
  ),
  CatalogItem(
    id: "65tuyj4try4wr",
    title: "Api Test 2",
    description: "Mock item 2",
    category: "Test 2",
    tags: ["Api", "Test"],
    qualityScore: 55,
  ),
  CatalogItem(
    id: "6e8r5498wr4485",
    title: "Api Test 3",
    description: "Mock item 3",
    category: "Test",
    tags: ["Api", "Test"],
    qualityScore: 75,
  ),
  CatalogItem(
    id: "bhiowef4563rg456rg",
    title: "Api Test 4",
    description: "Mock item 4",
    category: "Test 2",
    tags: ["Api", "Test"],
    qualityScore: 98,
  ),
];

Future<Response> _apiHandler(Request req) async {
  final path = req.url.path;
  final method = req.method.toUpperCase();

  if (method == 'OPTIONS') {
    return Response.ok('', headers: _corsHeaders);
  }

  // GET /items (All items)
  if (method == 'GET' && path == 'items') {
    return Response.ok(
      jsonEncode(items.map((i) => i.toJson()).toList()),
      headers: {'Content-Type': 'application/json', ..._corsHeaders},
    );
  }

  // Get /items/:id (Item by id)
  if (method == 'GET' && path.startsWith('items/')) {
    final id = path.split('/')[1];

    int itemIndex = items.indexWhere((item) => item.id == id);

    if (itemIndex < 0) {
      return Response.notFound(
        jsonEncode({'error': 'Item with id($id) not found'}),
        headers: _corsHeaders,
      );
    }

    return Response.ok(
      jsonEncode(items[itemIndex].toJson()),
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
    created.calculateScore();
    items.add(created);

    return Response.ok(
      jsonEncode(created.toJson()),
      headers: {'Content-Type': 'application/json', ..._corsHeaders},
    );
  }

  // PATCH /items/:id/approve
  if (method == "PATCH" &&
      path.startsWith('items/') &&
      path.endsWith('/approve')) {
    final id = path.split('/')[1];

    final itemIndex = items.indexWhere(
      (i) => i.id == id && i.qualityScore >= 90,
    );

    if (itemIndex < 0) {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Cannot approve item. Score is under 90 or dont exists',
        }),
        headers: _corsHeaders,
      );
    }

    items[itemIndex].approved = true;

    return Response.ok(
      jsonEncode(items[itemIndex].toJson()),
      headers: {'Content-Type': 'application/json', ..._corsHeaders},
    );
  }

  // Default Response 404
  return Response.notFound(jsonEncode({'error': 'Route not found'}));
}

validateText(String text) {
  final RegExp allowed = RegExp(r'^[a-zA-Z0-9\s]*$');

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
