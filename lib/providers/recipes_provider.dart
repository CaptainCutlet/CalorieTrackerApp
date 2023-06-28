import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'recipe_model.dart';

class RecipeProvider with ChangeNotifier {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  List<Recipe> _recipes = [];

  List<Recipe> get recipes {
    return [..._recipes];
  }

  List<Recipe> get favoritesList {
    return _recipes.where((element) => element.favorite == true).toList();
  }

  // Lists of different meal categories

  // List<Recipe> get veganRecipes {
  //   return recipes.where((recipe) => recipe.isVegan == true).toList();
  // }

  // List<Recipe> get vegetarianRecipes {
  //   return recipes.where((recipe) => recipe.isVegetarian == true).toList();
  // }

  // List<Recipe> get ketoRecipes {
  //   return recipes.where((recipe) => recipe.isKeto == true).toList();
  // }

  // List<Recipe> get lowCarbRecipes {
  //   return recipes.where((recipe) => recipe.isLowCarbs == true).toList();
  // }

  // List<Recipe> get lowCalorieRecipes {
  //   return recipes.where((recipe) => recipe.isLowCalories == true).toList();
  // }

  // List<Recipe> get lowFatRecipes {
  //   return recipes.where((recipe) => recipe.isLowFat == true).toList();
  // }

  // End of category lists

  // Start of all favorites lists

  // List<Recipe> get favVeganRecipes {
  //   return favoritesList.where((recipe) => recipe.isVegan == true).toList();
  // }

  // List<Recipe> get favVegetarianRecipes {
  //   return favoritesList.where((recipe) => recipe.isVegetarian == true).toList();
  // }

  // List<Recipe> get favKetoRecipes {
  //   return favoritesList.where((recipe) => recipe.isKeto == true).toList();
  // }

  // List<Recipe> get favLowCarbRecipes {
  //   return favoritesList.where((recipe) => recipe.isLowCarbs == true).toList();
  // }

  // List<Recipe> get favLowCalorieRecipes {
  //   return favoritesList.where((recipe) => recipe.isLowCalories == true).toList();
  // }

  // List<Recipe> get favLowFatRecipes {
  //   return favoritesList.where((recipe) => recipe.isLowFat == true).toList();
  // }

  // End of all favorites lists

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/recipes.json');
    final favUrl = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersFavorites.json');
    try {
      final favResponse = await http.get(favUrl);
      final favStatus = json.decode(favResponse.body);
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty || extractedData['error'] != null) {
        return;
      }
      List<Recipe> loadedRecipes = [];
      extractedData.forEach(
        (id, data) {
          loadedRecipes.add(
            Recipe(
              title: data['title'],
              description: data['description'],
              id: id,
              ingredients: data['ingredients'].cast<String>(),
              // categories: data['categories'].cast<String>(),
              steps: data['steps'].cast<String>(),
              kcal: double.parse(data['kcal'].toString()).toInt(),
              p: double.parse(data['p'].toString()).toInt(),
              c: double.parse(data['c'].toString()).toInt(),
              f: double.parse(data['f'].toString()).toInt(),
              servings: double.parse(data['servings'].toString()).toInt(),
              favorite: favStatus == null
                  ? false
                  : favStatus[id] == null
                      ? false
                      : favStatus[id]['favoriteStatus'],
              imageUrl: data['imageUrl'],
              creatorId: data['creatorId'],
              isKeto: data['isKeto'],
              isLowCalories: data['isLowCalories'],
              isLowCarbs: data['isLowCarbs'],
              isLowFat: data['isLowFat'],
              isVegan: data['isVegan'],
              isVegetarian: data['isVegetarian'],
            ),
          );
        },
      );
      _recipes = loadedRecipes;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addRecipe(Recipe newRecipe) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/recipes.json');
    try {
      var response = await http.post(
        url,
        body: json.encode(
          {
            'title': newRecipe.title,
            'description': newRecipe.description,
            'ingredients': newRecipe.ingredients,
            'steps': newRecipe.steps,
            'kcal': newRecipe.kcal,
            'p': newRecipe.p,
            'c': newRecipe.c,
            'f': newRecipe.f,
            'servings': newRecipe.servings,
            'imageUrl': newRecipe.imageUrl,
            'creatorId': userId,
            'isKeto': newRecipe.isKeto,
            'isLowCalories': newRecipe.isLowCalories,
            'isLowCarbs': newRecipe.isLowCarbs,
            'isLowFat': newRecipe.isLowFat,
            'isVegan': newRecipe.isVegan,
            'isVegetarian': newRecipe.isVegetarian,
          },
        ),
      );
      final finalRecipe = Recipe(
        title: newRecipe.title,
        description: newRecipe.description,
        id: json.decode(response.body)['name'],
        ingredients: newRecipe.ingredients,
        steps: newRecipe.steps,
        kcal: newRecipe.kcal,
        p: newRecipe.p,
        c: newRecipe.c,
        f: newRecipe.f,
        servings: newRecipe.servings,
        imageUrl: newRecipe.imageUrl,
        creatorId: newRecipe.creatorId,
        isKeto: newRecipe.isKeto,
        isLowCalories: newRecipe.isLowCalories,
        isLowCarbs: newRecipe.isLowCarbs,
        isLowFat: newRecipe.isLowFat,
        isVegan: newRecipe.isVegan,
        isVegetarian: newRecipe.isVegetarian,
      );
      _recipes.insert(0, finalRecipe);
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> editRecipe(Recipe newRecipe) async {
    final recipeIndex =
        _recipes.indexWhere((element) => element.id == newRecipe.id);
    if (recipeIndex >= 0) {
      final url = Uri.parse(
          'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/recipes/${newRecipe.id}.json');
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              'title': newRecipe.title,
              'description': newRecipe.description,
              'ingredients': newRecipe.ingredients,
              'steps': newRecipe.steps,
              'kcal': newRecipe.kcal,
              'p': newRecipe.p,
              'c': newRecipe.c,
              'f': newRecipe.f,
              'servings': newRecipe.servings,
              'imageUrl': newRecipe.imageUrl,
              'creatorId': userId,
              'isKeto': newRecipe.isKeto,
              'isLowCalories': newRecipe.isLowCalories,
              'isLowCarbs': newRecipe.isLowCarbs,
              'isLowFat': newRecipe.isLowFat,
              'isVegan': newRecipe.isVegan,
              'isVegetarian': newRecipe.isVegetarian,
            },
          ),
        );
        _recipes[recipeIndex] = newRecipe;
      } catch (error) {
        rethrow;
      }
    }

    notifyListeners();
  }

  Future<void> deleteRecipe(Recipe recipe, BuildContext context) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/recipes/${recipe.id}.json');
    if (recipe.creatorId == userId) {
      http.delete(url);
      _recipes.removeWhere((element) => element.id == recipe.id);
      userRecipes.removeWhere((element) => element.id == recipe.id);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error accured'),
          content: const Text('You do not have permission to delete this item'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.check),
            )
          ],
        ),
      );
    }
    notifyListeners();
  }

  List<Recipe> get userRecipes {
    return _recipes.where((element) => userId == element.creatorId).toList();
  }

  Recipe findById(String id) {
    return recipes.firstWhere((element) => element.id == id);
  }
}
