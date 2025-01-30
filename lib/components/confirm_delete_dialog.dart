import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/widgets/home.dart';
import '../services/recipe_service.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  ConfirmDeleteDialog({
    super.key,
    required this.recipeId
  });

  final String? recipeId;
  final RecipeService recipeService = RecipeService();


  @override
  Widget build(BuildContext context) {
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
  }
}
