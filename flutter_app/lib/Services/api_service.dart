import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/Dtos/new_catalog_item_dto.dart';
import 'package:http/http.dart' as http;
import '../models/catalog_item.dart';

class ApiService {
  // Ajusta según el entorno: localhost / emulador / iOS
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080/items';

    // Android emulador
    if (Platform.isAndroid) return 'http://10.0.2.2:8080/items';

    // IOS emulador
    if (Platform.isIOS) return 'http://127.0.0.1:8080/items';

    return 'http://localhost:8080/items';
  }

  Future<List<CatalogItem>> getItems() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => CatalogItem.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener items');
    }
  }

  Future<CatalogItem> createItem(NewCatalogItemDto item) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (res.statusCode == 200) {
      return CatalogItem.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Error al crear item');
    }
  }

  Future<CatalogItem> approveItem(String id) async {
    final res = await http.patch(Uri.parse('$baseUrl/$id/approve'));
    if (res.statusCode == 200) {
      return CatalogItem.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('No se pudo aprobar el item');
    }
  }
}
