import 'package:flutter/material.dart';
import 'package:flutter_app/Controllers/item_controller.dart';
import 'package:flutter_app/Screens/create_item_screen.dart';
import 'package:flutter_app/models/catalog_item.dart';
import 'package:get/get.dart';

class ItemsScreen extends GetView<ItemController> {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Catalog")),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchItems(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final CatalogItem item = controller.items[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: Text(
                              item.title,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Row(
                            spacing: 20,
                            children: [
                              Text("Quality Score:"),
                              SizedBox(
                                height: 20,
                                width: 70,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    LinearProgressIndicator(
                                      value: item.qualityScore.toDouble() / 100,
                                      backgroundColor: Colors.red,
                                    ),
                                    Center(
                                      child: Text(
                                        "${item.qualityScore}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              SizedBox(height: 4),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 250),
                                child: Text('Description: ${item.description}'),
                              ),
                              Text(
                                'Category: ${item.category.isNotEmpty ? item.category : "Empty"}',
                              ),
                              Text(
                                'Tags: ${item.tags.isNotEmpty ? item.tags.join(', ') : "Empty"}',
                              ),
                            ],
                          ),
                          Column(
                            spacing: 5,
                            children: [
                              item.approved
                                  ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                  : Icon(
                                    Icons.remove_circle_rounded,
                                    color: Colors.red,
                                  ),
                              Text(item.approved ? "Approved" : "Unapproved"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CreateItemScreen());
        },
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
