import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../models/recipe.dart';

class RecipeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference ref;

  Future<Object> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf('.');
    final outPath = "${filePath.substring(0, lastIndex)}_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, outPath,
      quality: 70, // Reduce image quality to 70%
    );

    return result ?? file; // Return compressed file or original if compression fails
  }

  Future<void> saveRecipe(BuildContext context, Recipe recipe) async {
    final user = _auth.currentUser;
    if (user == null) return;

    showDialog( // Show loading indicator
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Save recipe to Firestore first without image URL
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .add({
        "title": recipe.title,
        "notes": recipe.notes,
        "servings": recipe.servings,
        "ingredients": recipe.ingredients,
        "imageUrl": "", // Placeholder for now
      });

      if (recipe.imageFile != null) {
        File? compressedFile = (await compressImage(recipe.imageFile!)) as File?;
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(compressedFile!);
        String downloadURL = await storageRef.getDownloadURL();

        // Update Firestore with the image URL
        await docRef.update({"imageUrl": downloadURL});
      }

      print("Recipe saved successfully with ID: ${docRef.id}");
    } catch (e) {
      print("Error saving recipe: $e");
    } finally {
      Navigator.of(context).pop(); // Close loading indicator
    }
  }



// Future<void> saveRecipe(Recipe recipe) async {
  //   final user = _auth.currentUser;
  //   if (recipe.imageFile != null) {
  //     final storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     try {
  //       await storageRef.putFile(recipe.imageFile!);
  //       recipe.imageUrl = await storageRef.getDownloadURL();
  //     } catch (e) {
  //       print('Error uploading image: $e');
  //     }
  //   }
  //   final recipeData = {
  //     "title": recipe.title,
  //     "notes": recipe.notes,
  //     "servings": recipe.servings,
  //     "ingredients": recipe.ingredients,
  //     "imageUrl": recipe.imageUrl
  //   };
  //
  //   if (user != null) {
  //     try {
  //       final docRef = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.uid)
  //           .collection('recipes')
  //           .add(recipeData);
  //
  //       await docRef.update({"id": docRef.id});
  //       print("Recipe saved successfully with ID: ${docRef.id}");
  //     } catch (e) {
  //       print("Error saving recipe: $e");
  //     }
  //   }
  // }

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
