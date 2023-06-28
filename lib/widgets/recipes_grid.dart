// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipier/widgets/loading_spinner.dart';

import '../providers/recipe_model.dart';
import 'recipe_item.dart';

class RecipesGrid extends StatelessWidget {
  bool isFav;
  String title;
  List<Recipe> recipes;
  RecipesGrid(this.title, this.recipes, this.isFav);

  @override
  Widget build(BuildContext context) {
    // final recipeData = Provider.of<RecipeProvider>(context);
    // List<Recipe> recipes =
    //     isFav == false ? recipeData.recipes : recipeData.favoritesList;
    // recipes = Provider.of<FiltersProvider>(context).filteredRecipes(recipes);
    // Future<void> refresh() async {
    //   recipeData.fetchProducts();
    // }

    return recipes.isEmpty
        ? LoadingSpinner()
        : GridView.builder(
            itemCount: recipes.length,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 5,
              childAspectRatio: 1 / 0.75,
            ),
            itemBuilder: (context, i) => ChangeNotifierProvider.value(
              value: recipes[i],
              child: isFav == true && recipes == []
                  ? const Center(
                      child: Text(
                          'You don\'t have any favorites yet. Start adding some!'),
                    )
                  : RecipeItem(),
            ),
          );
  }
}
