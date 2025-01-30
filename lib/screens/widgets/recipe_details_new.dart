import 'package:flutter/material.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/screens/widgets/home.dart';
import 'package:recipes_app/screens/widgets/add_recipe.dart';
import 'package:recipes_app/services/recipe_service.dart';

import '../../components/confirm_delete_dialog.dart';
import '../../models/recipe.dart';

class RecipeDetailsNew extends StatelessWidget {

  final String? recipeId;
  final String title;
  final String notes;
  final String servings;
  final String? imageUrl;
  final List<String> ingredients;


  RecipeDetailsNew({
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: CurvePainter(),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/tex_mex_bowl.jpg'), // Replace with your image asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            top: 250,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
                  ),
                ),

              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //   width: MediaQuery.of(context).size.width,
              //   height: 140,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       colorFilter: ColorFilter.mode(
              //         Colors.black.withOpacity(0.35),
              //         BlendMode.multiply,
              //       ),
              //       image: imageUrl != ""
              //           ? NetworkImage(imageUrl!)
              //           : AssetImage('assets/food_background.jpeg')
              //       as ImageProvider,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
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


class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..lineTo(0, size.height - 50)
      ..quadraticBezierTo(
        size.width / 2, size.height,
        size.width, size.height - 50,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
