// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class CatalogItem {
  String id;
  String title;
  String description;
  String category;
  List<String> tags;
  bool approved;
  int qualityScore;

  CatalogItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    this.approved = false,
    this.qualityScore = 40,
  });

  void calculateScore() {
    qualityScore = 40;
    if (title.length > 12) qualityScore += 20;
    if (description.length > 60) qualityScore += 15;
    if (category.isNotEmpty) qualityScore += 10;
    if (tags.isNotEmpty) qualityScore += 10;
    if (tags.length >= 2) qualityScore += 5;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'tags': tags,
      'approved': approved,
      'qualityScore': qualityScore,
    };
  }

  static CatalogItem fromJson(Map<String, dynamic> json) {
    return CatalogItem(
      id: json['id'] ?? _uuid.v4(),
      title: json['title'],
      description: json['description'],
      category: json['category'],
      tags: List<String>.from(json['tags']),
      approved: json['approved'] ?? false,
      qualityScore: json['qualityScore'] ?? 40,
    );
  }
}
