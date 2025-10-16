import 'package:flutter/material.dart';
import 'package:flutter_app/Controllers/item_controller.dart';
import 'package:flutter_app/Dtos/new_catalog_item_dto.dart';
import 'package:get/get.dart';

class CreateItemScreen extends StatelessWidget {
  final ItemController controller = Get.find<ItemController>();

  // Controladores de texto
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  // Form key para validación
  final _formKey = GlobalKey<FormState>();

  CreateItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Item')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title (required)
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Description (required)
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Category (optional)
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Tags (optional, separados por coma)
              TextFormField(
                controller: tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),

              // Botón de crear
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              final dto = NewCatalogItemDto(
                                title: titleController.text.trim(),
                                description: descriptionController.text.trim(),
                                category: categoryController.text.trim(),
                                tags:
                                    tagsController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .where((e) => e.isNotEmpty)
                                        .toList(),
                              );
                              controller.createItem(dto).then((_) {
                                // Limpiar campos después de crear
                                titleController.clear();
                                descriptionController.clear();
                                categoryController.clear();
                                tagsController.clear();
                              });
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      controller.isLoading.value
                          ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : Text('Create Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
