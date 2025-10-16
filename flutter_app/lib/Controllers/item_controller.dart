import 'package:flutter_app/Dtos/new_catalog_item_dto.dart';
import 'package:flutter_app/Services/api_service.dart';
import 'package:flutter_app/models/catalog_item.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  final ApiService _service = Get.find();

  // Lista observable de items
  final RxList<CatalogItem> items = <CatalogItem>[].obs;

  // Estado de carga
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  // Obtener todos los items del servidor
  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      final fetched = await _service.getItems();
      items.assignAll(fetched);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Crear un nuevo item usando DTO
  Future<void> createItem(NewCatalogItemDto dto) async {
    try {
      isLoading.value = true;
      final created = await _service.createItem(dto);
      items.add(created);
      Get.snackbar('Éxito', 'Item creado correctamente');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Aprobar un item
  Future<void> approveItem(String id) async {
    try {
      isLoading.value = true;
      final updated = await _service.approveItem(id);
      final index = items.indexWhere((i) => i.id == id);
      if (index != -1) items[index] = updated;
      Get.snackbar('Éxito', 'Item aprobado');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
