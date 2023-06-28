// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

import '../providers/recipe_model.dart';
import '../widgets/recipes_grid.dart';

class CategoryRecipeScreen extends StatelessWidget {
  static const routeName = '/category-recipe-screen';
  String title = '';
  List<Recipe> recipes = [];
  bool favStatus = false;

  void getData(BuildContext ctx) {
    var data = ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>;
    title = data['title'];
    recipes = data['recipes'];
    favStatus = data['favStatus'];
  }

  @override
  Widget build(BuildContext context) {
    getData(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: recipes.isEmpty
          ? Center(
              child: Text(
                'There are no favorite recipes for this category',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontSize: 23),
              ),
            )
          : RecipesGrid(title, recipes, favStatus),
    );
  }
}
