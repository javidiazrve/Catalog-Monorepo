import 'package:flutter/material.dart';
import 'package:flutter_app/Controllers/item_controller.dart';
import 'package:flutter_app/Dtos/new_catalog_item_dto.dart';
import 'package:get/get.dart';

class CreateItemScreen extends StatelessWidget {
  final ItemController controller = Get.find<ItemController>();

  // Text Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  CreateItemScreen({super.key}) {
    // Escuchamos cambios de texto para actualizar el score en tiempo real
    titleController.addListener(_recalculateScore);
    descriptionController.addListener(_recalculateScore);
    categoryController.addListener(_recalculateScore);
    tagsController.addListener(_recalculateScore);
  }

  void _recalculateScore() {
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

    controller.calculateQualityScore(dto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title (required) + Quality progress
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
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
                  ),
                  const SizedBox(width: 12),
                  // Quality Score Progress Bar
                  Column(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Quality Score"),
                      SizedBox(
                        height: 20,
                        width: 70,
                        child: Obx(() {
                          final score = controller.currentScore.value.clamp(
                            0,
                            100,
                          );
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              LinearProgressIndicator(
                                value: score / 100,
                                backgroundColor: Colors.red,
                              ),
                              Center(
                                child: Text(
                                  score.toStringAsFixed(0),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description (required)
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
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

              const SizedBox(height: 16),

              // Category (optional)
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Tags (optional)
              TextFormField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Create button
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
                                titleController.clear();
                                descriptionController.clear();
                                categoryController.clear();
                                tagsController.clear();
                                controller.currentScore.value = 40; // reset
                              });
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : const Text('Create Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
