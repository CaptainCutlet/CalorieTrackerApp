import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'recipe_model.dart';

class FiltersProvider with ChangeNotifier {
  List<Recipe> filteredRecipesList = [];

  Map<String, bool> filtersList = {
    'vegan': false,
    'vegetarian': false,
    'lowCalorie': false,
    'lowFat': false,
    'lowCarbs': false,
    'keto': false,
  };

  List<Recipe> filteredRecipes(List<Recipe> allRecipes) {
    filteredRecipesList = allRecipes.where((Recipe recipe) {
      if ((recipe.isVegan == filtersList['vegan']! &&
              filtersList['vegan']! == true) ||
          (recipe.isKeto == filtersList['keto']! &&
              filtersList['keto']! == true) ||
          (recipe.isVegetarian == filtersList['vegetarian']! &&
                  filtersList['vegetarian']!) ==
              true ||
          (recipe.isLowFat == filtersList['lowFat']! &&
              filtersList['lowFat']! == true) ||
          (recipe.isLowCarbs == filtersList['lowCarbs']! &&
              filtersList['lowCarbs']! == true) ||
          (recipe.isLowCalories == filtersList['lowCalorie']! &&
              filtersList['lowCalorie']! == true)) {
        return true;
      } else if (false == filtersList['vegan']! &&
          false == filtersList['keto']! &&
          false == filtersList['vegetarian']! &&
          false == filtersList['lowFat']! &&
          false == filtersList['lowCarbs']! &&
          false == filtersList['lowCalorie']!) {
        return true;
      } else {
        return false;
      }
    }).toList();
    return filteredRecipesList;
  }

  Future<void> setUserFilters(Map<String, bool> filters, String userId) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/filterSelection.json');
    await http.put(
      url,
      body: json.encode(filters),
    );
  }

  Future<void> getUserFilters(String userId) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/filterSelection.json');
    var response = await http.get(url);
    var filterSelection = json.decode(response.body);
    filtersList['vegan'] = filterSelection['vegan']!;
    filtersList['vegetarian'] = filterSelection['vegetarian']!;
    filtersList['keto'] = filterSelection['keto']!;
    filtersList['lowCalorie'] = filterSelection['lowCalorie']!;
    filtersList['lowCarbs'] = filterSelection['lowCarbs']!;
    filtersList['lowFat'] = filterSelection['lowFat']!;
  }
}
