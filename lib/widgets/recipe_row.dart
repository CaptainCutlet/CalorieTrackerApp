// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/recipe_category_screen.dart';
import '../widgets/recipe_row_item.dart';
import '../providers/recipe_model.dart';

class RecipeRow extends StatefulWidget {
  final String categoryName;
  List<Recipe> recipes;
  bool favStatus;
  RecipeRow(this.categoryName, this.recipes, this.favStatus);

  @override
  State<RecipeRow> createState() => _RecipeRowState();
}

class _RecipeRowState extends State<RecipeRow> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataForScreen = {
      'favStatus': widget.favStatus,
      'title': widget.categoryName,
      'recipes': widget.recipes,
    };

    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
          child: TextButton.icon(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              elevation: MaterialStateProperty.all<double>(100),
              alignment: Alignment.centerLeft,
            ),
            label: Text(
              widget.categoryName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CategoryRecipeScreen.routeName,
                  arguments: dataForScreen);
            },
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 22,
              color: Colors.white,
            ),
          ),
        ),
        widget.recipes.isEmpty
            ? Center(
                child: Text(
                  'There are no recipes for this category',
                  style: Theme.of(context).textTheme.headline4,
                ),
              )
            : SizedBox(
                height: 175,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.recipes.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(3),
                  itemBuilder: (context, index) => ChangeNotifierProvider.value(
                    value: widget.recipes[index],
                    child: RecipeRowItem(),
                  ),
                ),
              ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
