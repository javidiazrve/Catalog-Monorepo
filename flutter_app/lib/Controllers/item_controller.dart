import 'package:flutter_app/Dtos/new_catalog_item_dto.dart';
import 'package:flutter_app/Services/api_service.dart';
import 'package:flutter_app/models/catalog_item.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  final ApiService _service = Get.find();

  final RxList<CatalogItem> items = <CatalogItem>[].obs;

  final RxBool isLoading = false.obs;

  var currentScore = 40.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

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

  void calculateQualityScore(NewCatalogItemDto dto) {
    double score = 40;

    if (dto.title.length > 12) score += 20;
    if (dto.description.length > 60) score += 15;
    if (dto.category?.isNotEmpty ?? false) score += 10;
    if (dto.tags?.isNotEmpty ?? false) {
      score += 10;
      if (dto.tags!.length >= 2) score += 5;
    }

    currentScore.value = score.clamp(0, 100);
  }

  Future<void> createItem(NewCatalogItemDto dto) async {
    try {
      isLoading.value = true;
      final created = await _service.createItem(dto);
      items.add(created);
      Get.snackbar(
        'Success',
        'Item creaded correctly',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
