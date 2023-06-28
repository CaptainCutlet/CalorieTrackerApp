// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipes_provider.dart';
import '../providers/recipe_model.dart';
import '../screens/edit_recipe_screen.dart';
import '../screens/recipe_details_screen.dart';

class UserItem extends StatelessWidget {
  final Recipe recipe;
  UserItem(this.recipe);
  @override
  Widget build(BuildContext context) {
    final functions = Provider.of<RecipeProvider>(context);
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      color: Theme.of(context).accentColor,
      elevation: 50,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.95,
        child: ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed(RecipeDetailScreen.routeName, arguments: recipe.id);
          },
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(recipe.imageUrl!),
          ),
          title: Text(
            recipe.title,
            style:
                Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                padding: const EdgeInsets.all(1),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditRecipeScreen.routeName, arguments: recipe);
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.green[900],
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              IconButton(
                padding: const EdgeInsets.all(1),
                onPressed: () {
                  functions.deleteRecipe(recipe, context);
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
