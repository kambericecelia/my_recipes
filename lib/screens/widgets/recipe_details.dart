import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {

  final String title;
  final String notes;
  final String servings;
  final List<String> ingredients;

  const RecipeDetails({
    Key? key,
    required this.title,
    required this.notes,
    required this.servings,
    required this.ingredients,
  }) : super(key: key);
  static const String id = 'recipe_details';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ingredients Section
            Text(
              "Ingredients",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
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
            ),

            // Notes Section
            SizedBox(height: 16,),
            Text(
              "Notes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.reviews_outlined, color: Colors.green, size: 24,),
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
            SizedBox(height: 16),
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
    );
  }
}