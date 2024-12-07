import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String title;
  final String notes;
  final String servings;

  final List<String> ingredients;

  Recipe(
      {required this.title, required this.notes, required this.servings, required this.ingredients});


  factory Recipe.fromJson(dynamic json){
    return Recipe(
        title: json["title"],
        notes: json['notes'],
        servings: json["servings"],

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