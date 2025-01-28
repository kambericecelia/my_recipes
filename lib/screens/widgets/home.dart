import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/widgets/add_recipe.dart';
import 'package:recipes_app/screens/widgets/login_page.dart';
import 'package:recipes_app/screens/widgets/recipe_card.dart';

import '../../services/recipe_service.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RecipeService recipeService = RecipeService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print("SignOut Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomAppBar(
          color: Color.fromRGBO(136, 194, 115, 1),
          elevation: 5,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRecipe(),
              ),
            );
            // Add your action here
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.white,
        ),
      ),
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant_menu),
              SizedBox(
                width: 10,
              ),
              Text('My recipes'),
            ],
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              signOut();
              Navigator.pop(context);
              Navigator.pushNamed(context, LoginPage.id);
            },
          ),
        ],
      )),
      body: StreamBuilder<List<Recipe>>(
          stream: recipeService.userRecipes(),
          builder: (context, snapshot) {
            print("LOGGED IN USER $user");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error loading recipes!"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text("You do not have any recipes yet! Try to add one!"),
              );
            }
            if (snapshot.hasData) {
              List<Recipe> recipes = snapshot.data!;
              return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecipeCard(
                        recipeId: recipe.id,
                        title: recipe.title,
                        notes: recipe.notes,
                        ingredients: recipe.ingredients,
                        servings: recipe.servings,
                        imageUrl: recipe.imageUrl);
                  });
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
