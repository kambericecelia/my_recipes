import 'dart:io';


class Recipe {
  final String? id;
  final String title;
  final String notes;
  final String servings;
  String? imageUrl;
  final File? imageFile;
  final List<String> ingredients;

  Recipe(
      {this.id,
      required this.title,
      required this.notes,
      required this.servings,
      required this.ingredients,
      this.imageFile,
      this.imageUrl});



  factory Recipe.fromMap(Map<String, dynamic> map, String documentId) {
    return Recipe(
      id: documentId,
      title: map['title'] ?? '',
      notes: map['notes'] ?? '',
      servings: map['servings'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? ''),
    );
  }

  @override
  String toString() {
    return 'Recipe {title: $title,notes: $notes, servings: $servings, ingredients $ingredients}';
  }


}
