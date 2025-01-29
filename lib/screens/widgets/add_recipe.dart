import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/screens/widgets/home.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/services/recipe_service.dart';

import '../../components/image_picker.dart';

class AddRecipe extends StatefulWidget {
  static const String id = 'add_recipe';
  const AddRecipe({Key? key}) : super(key: key);

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final RecipeService recipeService = RecipeService();
  final _ingredientControllers = <TextEditingController>[];
  final _titleController = TextEditingController();
  final _servingsController = TextEditingController();
  final _notesController = TextEditingController();
  File? _selectedImage;
  String title = '';
  String servings = '';
  String notes = '';
  String? recipeId;
  String? recipeImageUrl;
  List<String> ingredients = [];
  Recipe? recipe;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && recipeId == null) {
      setState(() {
        recipeId = args['recipeId'];
        _titleController.text = args['title'] ?? '';
        _servingsController.text = args['servings'] ?? '';
        _notesController.text = args['notes'] ?? '';
        recipeImageUrl = args['imageUrl'];

        final ingredientsList = args['ingredients'] as List<String>?;
        if (ingredientsList != null) {
          for (var ingredient in ingredientsList) {
            _ingredientControllers.add(TextEditingController(text: ingredient));
          }
        }
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredientControllers.removeAt(index);
    });
  }

  Future<void> _pickImage() async {
    final selectedImage =
        await ImagePickerHelper.showImagePickerDialog(context);

    if (selectedImage != null) {
      setState(() {
        _selectedImage = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: recipeId == null || recipeId!.isEmpty
              ? Text("Add New Recipe")
              : Text("Update Recipe"),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    title = _titleController.text;
                    notes = _notesController.text;
                    servings = _servingsController.text;
                    ingredients.clear();
                    for (var ingredientController in _ingredientControllers) {
                      ingredients.add(ingredientController.text.trim());
                    }
                  });
                  if (title.isEmpty || servings.isEmpty) {
                    Fluttertoast.showToast(
                      msg:
                          "Please provide the title and servings for the recipe!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return;
                  }
                  if (recipeId == null) {
                    recipe = Recipe(
                      title: title,
                      notes: notes,
                      servings: servings,
                      ingredients: ingredients,
                      imageFile: _selectedImage,
                    );
                    await recipeService.saveRecipe(recipe!);
                  } else {
                    recipe = Recipe(
                      title: title,
                      notes: notes,
                      servings: servings,
                      ingredients: ingredients,
                    );
                    await recipeService.updateRecipe(
                      recipe!,
                      recipeId!,
                      _selectedImage,
                      recipeImageUrl,
                    );
                  }
                  Navigator.pushNamed(context, HomePage.id);
                },
                //icon: Icon(Icons.save),
                label: recipeId == null || recipeId!.isEmpty
                    ? Text("Save")
                    : Text("Update"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: ksecondaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(10, 30),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.restaurant_menu),
                        labelText: "Recipe Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  child: TextFormField(
                    controller: _servingsController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.people),
                        labelText: "Number of servings",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _ingredientControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _ingredientControllers[index],
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.kitchen),
                                      hintText: "Ingredient",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please add an ingredient!";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (_ingredientControllers.length > 1) {
                                      _removeIngredient(index);
                                    }
                                  },
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.red))
                            ],
                          ));
                    }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _ingredientControllers.add(TextEditingController());
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.black87,
                    ),
                    label: Text("Add ingredient",
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 20,
                      color: Colors.black87,
                    ),
                    label: Text(
                      recipeId == null ? "Add Image" : "Update Image",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

// Displaying the image
                if (_selectedImage != null || recipeImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        // Display the network image if it exists, otherwise display the selected image
                        _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : (recipeImageUrl != null &&
                                    recipeImageUrl!.isNotEmpty
                                ? Image.network(
                                    recipeImageUrl!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/food_background.jpeg',
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )),
                        // Remove image button
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                              recipeImageUrl = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  child: TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.notes),
                      labelText: 'Recipe Notes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),

                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
