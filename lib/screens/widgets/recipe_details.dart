import 'package:flutter/material.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/screens/widgets/home.dart';
import 'package:recipes_app/screens/widgets/add_recipe.dart';
import 'package:recipes_app/services/recipe_service.dart';

import '../../models/recipe.dart';

class RecipeDetails extends StatelessWidget {

  final String? recipeId;
  final String title;
  final String notes;
  final String servings;
  final String? imageUrl;
  final List<String> ingredients;


  RecipeDetails({
    Key? key,
    this.recipeId,
    this.imageUrl,
    required this.title,
    required this.notes,
    required this.servings,
    required this.ingredients,
  }) : super(key: key);
  static const String id = 'recipe_details';
  final RecipeService recipeService = RecipeService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AddRecipe.id, arguments: {
                  'recipeId': recipeId,
                  'title': title,
                  'servings': servings,
                  'notes': notes,
                  'ingredients': ingredients,
                  'imageUrl': imageUrl,
                });
              },
              label: Text("Update"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: ksecondaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(10, 30),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            )),
        Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Are you sure you want to delete the recipe?",
                          style: TextStyle(fontSize: 15),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ksecondaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (recipeId != null) {
                                await recipeService.deleteRecipe(recipeId!);
                              }
                              Navigator.pushNamed(context, HomePage.id);
                            },
                            child: const Text("Delete"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          )
                        ],
                      );
                    });
              },
              label: Text("Delete"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(10, 30),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            )),

      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ingredients Section
          Text(
            "Ingredients",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Prevent nested scrolling issues
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                leading: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 20,
                ),
                title: Text(
                  ingredients[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),

          // Notes Section
          SizedBox(
            height: 16,
          ),
          Text(
            "Notes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.reviews_outlined,
              color: Colors.green,
              size: 24,
            ),
            title: Text(
              notes.isEmpty ? 'No notes available' : notes,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: notes.isEmpty ? Colors.grey : Colors.black87,
              ),
            ),
          ),

          // Servings Section
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: MediaQuery.of(context).size.width,
            height: 140,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.35),
                  BlendMode.multiply,
                ),
                image: imageUrl != ""
                    ? NetworkImage(imageUrl!)
                    : AssetImage('assets/food_background.jpeg')
                as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "Servings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.restaurant,
              color: Colors.green,
              size: 24,
            ),
            title: Text(
              servings,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),

    ),
    );
  }
}
