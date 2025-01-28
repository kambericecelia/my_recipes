import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/recipe.dart';

class RecipeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference ref;

  Future<void> saveRecipe(Recipe recipe) async {
    final user = _auth.currentUser;
    if (recipe.imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      try {
        await storageRef.putFile(recipe.imageFile!);
        recipe.imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    final recipeData = {
      "title": recipe.title,
      "notes": recipe.notes,
      "servings": recipe.servings,
      "ingredients": recipe.ingredients,
      "imageUrl": recipe.imageUrl
    };

    if (user != null) {
      try {
        final docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('recipes')
            .add(recipeData);

        await docRef.update({"id": docRef.id});
        print("Recipe saved successfully with ID: ${docRef.id}");
      } catch (e) {
        print("Error saving recipe: $e");
      }
    }
  }

  Stream<List<Recipe>> fetchAllRecipes() {
    return FirebaseFirestore.instance
        .collection('recipes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deleteRecipe(String recipeId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(recipeId)
          .delete();
    }
  }

  Future<void> updateRecipe(Recipe recipe, String recipeId, File? newImageFile, String? existingImageUrl) async {
    String? imageUrl = existingImageUrl;
    // Check if a new image file is provided
    if (newImageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      try {
        await storageRef.putFile(newImageFile);
        imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print("Error uploading image: $e");
        throw Exception("Failed to upload the image. Please try again.");
      }
    }
    final user = _auth.currentUser;
    // Prepare data for update
    final recipeData = {
      "title": recipe.title,
      "notes": recipe.notes,
      "servings": recipe.servings,
      "ingredients": recipe.ingredients,
      "imageUrl": imageUrl
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('recipes')
          .doc(recipeId)
          .update(recipeData);
      print("Recipe updated successfully!");
    } catch (e) {
      print("Failed to update the recipe: $e");
      throw Exception("Could not update the recipe. Please try again");
    }
  }

  Stream<List<Recipe>> userRecipes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users') // Main collection
          .doc(user.uid) // Document for the user
          .collection('recipes') // Subcollection of recipes
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Recipe.fromMap(doc.data(), doc.id))
              .toList());
    } else {
      // Return an empty stream if the user is not logged in
      return Stream.value([]);
    }
  }
}
