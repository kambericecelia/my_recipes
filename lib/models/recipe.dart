import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
      final docRef = await FirebaseFirestore.instance
          .collection('recipes')
          .add(recipeData);
      await docRef.update({"id": docRef.id});
      print("Recipe saved successfully with ID: ${docRef.id}");
    } catch (e) {
      print("Error saving recipe: $e");
    }
  }

  static Stream<List<Recipe>> fetchAllRecipes() {
    return FirebaseFirestore.instance
        .collection('recipes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  static Future<void> deleteRecipe(String recipeId) async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId)
        .delete();
  }
  Future<void> updateRecipe (String recipeId, String title, String servings, String notes, List<String> ingredients) async {
    try {
      final recipeData = {
        "title": title,
        "notes": notes,
        "servings": servings,
        "ingredients": ingredients,
        //"imageUrl": imageUrl
      };
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .update(recipeData);
      print("Recipe updated successfully!");
    }catch(e){
      print("Failed to update the recipe: $e");
      throw Exception("Could not update the recipe. Please try again");
    }
  }
}
