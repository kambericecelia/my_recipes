import 'package:flutter/material.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Ingredients list management
  List<TextEditingController> _ingredientControllers = [];

  @override
  void initState() {
    super.initState();
    // Start with one ingredient field
    _addIngredientField();
  }

  // Add a new ingredient text field
  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  // Remove an ingredient text field
  void _removeIngredientField(int index) {
    setState(() {
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
    });
  }

  // Save recipe method
  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      // Collect ingredients
      List<String> ingredients = _ingredientControllers
          .map((controller) => controller.text.trim())
          .where((ingredient) => ingredient.isNotEmpty)
          .toList();

      // Here you would typically save the recipe
      // (e.g., to a database or state management solution)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe Saved Successfully!')),
      );

      // Optional: Clear form or navigate back
      Navigator.pop(context, {
        'title': _titleController.text,
        'servings': _servingsController.text,
        'notes': _notesController.text,
        'ingredients': ingredients,
      });
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _titleController.dispose();
    _servingsController.dispose();
    _notesController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Recipe'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveRecipe,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Recipe Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a recipe title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Servings Field
            TextFormField(
              controller: _servingsController,
              decoration: InputDecoration(
                labelText: 'Number of Servings',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of servings';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Ingredients Section
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ...List.generate(
              _ingredientControllers.length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ingredientControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Ingredient ${index + 1}',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.kitchen),
                        ),
                      ),
                    ),
                    if (_ingredientControllers.length > 1)
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeIngredientField(index),
                      ),
                  ],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addIngredientField,
              icon: Icon(Icons.add),
              label: Text('Add Ingredient'),
            ),
            SizedBox(height: 16),

            // Notes Field
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Recipe Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}