import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/home.dart';
import 'package:recipes_app/screens/widgets/add_recipe.dart';
import 'package:recipes_app/screens/widgets/recipe_details.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          textTheme: const TextTheme(bodySmall: TextStyle(color: Colors.white))),
      home: const HomePage(),

      initialRoute: 'home_page',
      routes: {
        HomePage.id: (context) => HomePage(),
        AddRecipe.id: (context) => AddRecipe()
      },
    );
  }
}
