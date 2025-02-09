import 'package:flutter/material.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/screens/widgets/home.dart';
import 'package:recipes_app/screens/widgets/add_recipe.dart';
import 'package:recipes_app/services/recipe_service.dart';

import '../../components/confirm_delete_dialog.dart';
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
                  minimumSize: Size(65, 30),
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
                      return ConfirmDeleteDialog(recipeId: recipeId);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Opacity(
                    opacity: 1,
                    child: ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        height: 240,
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
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Prevent nested scrolling issues
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height); // Start at the bottom-left corner

    // Create a smooth curve resembling a bowl
    var firstControlPoint = Offset(size.width / 5, size.height);
    var firstEndPoint = Offset(size.width * 0.5, size.height - 45);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 0.75, size.height - 90);
    var secondEndPoint = Offset(size.width, size.height - 65);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0); // Top-right corner
    path.close(); // Complete the path

    return path;
  }

  @override
  bool shouldReclip(covariant WaveClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
