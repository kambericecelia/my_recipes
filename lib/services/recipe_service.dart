// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../models/recipe.dart';
//
// class RecipeService {
//   late FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   CollectionReference recipes = _firestore.collection('recipes');
//   //final FirebaseAuth _auth
//
//   Future<void> saveRecipe(Recipe recipe) async{
//     await _firestore.collection('recipes').add({
//       'title': recipe.title,
//       'servings': recipe.servings,
//       'notes': recipe.notes
//
//     });
//
//   }
//   Future<List<Recipe>> loadRecipes() async {
//     try {
//       // Load the JSON file from assets
//       String jsonString = await rootBundle.loadString('assets/recipes.json');
//
//       // Parse the JSON string
//       List<dynamic> jsonList = json.decode(jsonString);
//
//       // Convert to List of Recipe objects
//       List<Recipe> recipes = jsonList.map((json) => Recipe.fromJson(json)).toList();
//
//       return recipes;
//     } catch (e) {
//       print('Error loading recipes: $e');
//       return []; // Return empty list in case of error
//     }
//   }
//
// }

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recipe.dart';

extension RecipeService on Recipe {
  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "notes": notes,
      "servings": servings,
      "ingredients": ingredients,
    };
  }

  Future<DocumentReference> saveToFirestore() async {
    return FirebaseFirestore.instance.collection('recipes').add(toFirestore());
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
