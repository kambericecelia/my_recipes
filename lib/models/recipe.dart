import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Recipe {
  final String title;
  final String notes;
  final String servings;
  final File? imageFile;
  final List<String> ingredients;
  String? imageUrl;

  Recipe(
      {required this.title,
      required this.notes,
      required this.servings,
      required this.ingredients,
      this.imageFile,
      this.imageUrl});

  factory Recipe.fromJson(dynamic json) {
    return Recipe(
      title: json['title'],
      notes: json['notes'],
      servings: json['servings'],
      imageUrl: json['imageUrl'],
      ingredients: List<String>.from(json['ingredients']),
    );
  }

  @override
  String toString() {
    return 'Recipe {title: $title,notes: $notes, servings: $servings, ingredients $ingredients}';
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "notes": notes,
      "servings": servings,
      "ingredients": ingredients,
      "imageUrl": imageUrl
    };
  }

  // Future<DocumentReference> saveRecipe() async {
  //   return FirebaseFirestore.instance.collection('recipes').add(toFirestore());
  // }

  Future<void> saveRecipe() async {
    if (imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      try {
        await storageRef.putFile(imageFile!);

        imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    final recipeData = {
      "title": title,
      "notes": notes,
      "servings": servings,
      "ingredients": ingredients,
      "imageUrl": imageUrl
    };

    try {
      await FirebaseFirestore.instance.collection('recipes').add(recipeData);
      print("Recipe saved successfully");
    } catch (e) {
      print("Error saving recipe: $e");
    }
  }

  static Stream<List<Recipe>> fetchAllRecipes() {
    Query query = FirebaseFirestore.instance.collection('recipes');

    return query.snapshots().map((querySnapshot) => querySnapshot.docs
        .map((doc) => Recipe.fromJson({
              ...doc.data() as Map<String, dynamic>,
            }))
        .toList());
  }
}
