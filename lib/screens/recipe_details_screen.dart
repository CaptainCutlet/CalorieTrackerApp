// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/front_card.dart';
import '../providers/recipes_provider.dart';
import '../providers/recipe_model.dart';
import '../widgets/bottom_bar.dart';

class RecipeDetailScreen extends StatelessWidget {
  static const routeName = '/detail-screen';

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;
    Recipe recipe =
        Provider.of<RecipeProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.title,
          textScaleFactor: 0.6,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: recipe.imageUrl == null
                      ? Image.asset('assets/cutlery.png')
                      : Image.network(
                          recipe.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                ),
                BottomBar(recipe),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Text(
              recipe.description,
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline2!.copyWith(fontSize: 16),
            ),
          ),
          FrontCard(recipe.ingredients, 'Ingredients'),
          FrontCard(recipe.steps, 'Instructions'),
        ],
      ),
    );
  }
}
