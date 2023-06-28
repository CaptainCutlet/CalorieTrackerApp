// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipier/widgets/loading_spinner.dart';

import '../providers/recipe_model.dart';
import '../widgets/recipe_row.dart';
import '../providers/recipes_provider.dart';

class AllRecipesScreen extends StatefulWidget {
  bool favStatus;
  AllRecipesScreen(this.favStatus);

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  bool _runsForFirstTime = true;
  bool _hasBeenFetched = false;

  @override
  void didChangeDependencies() {
    if (_runsForFirstTime == true) {
      Provider.of<RecipeProvider>(context, listen: false)
          .fetchProducts()
          .then((value) {
        _hasBeenFetched = true;
        _runsForFirstTime = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = widget.favStatus == false
        ? Provider.of<RecipeProvider>(context).recipes
        : Provider.of<RecipeProvider>(context).favoritesList;

    return _hasBeenFetched == false
        ? LoadingSpinner()
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RecipeRow(
                  'All Recipes',
                  recipes,
                  widget.favStatus,
                ),
                RecipeRow(
                  'Vegan',
                  recipes.where((element) => element.isVegan == true).toList(),
                  widget.favStatus,
                ),
                RecipeRow(
                  'Vegetarian',
                  recipes
                      .where((element) => element.isVegetarian == true)
                      .toList(),
                  widget.favStatus,
                ),
                RecipeRow(
                  'Keto',
                  recipes.where((element) => element.isKeto == true).toList(),
                  widget.favStatus,
                ),
                RecipeRow(
                  'Low-Fat',
                  recipes.where((element) => element.isLowFat == true).toList(),
                  widget.favStatus,
                ),
                RecipeRow(
                  'low-Carb',
                  recipes
                      .where((element) => element.isLowCarbs == true)
                      .toList(),
                  widget.favStatus,
                ),
                RecipeRow(
                  'Under 500 kcal',
                  recipes
                      .where((element) => element.isLowCalories == true)
                      .toList(),
                  widget.favStatus,
                ),
              ],
            ),
          );
  }
}
