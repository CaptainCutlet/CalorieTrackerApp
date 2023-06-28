// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_model.dart';
import '../screens/recipe_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeItem extends StatefulWidget {
  @override
  State<RecipeItem> createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final Recipe recipe = Provider.of<Recipe>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
        borderRadius: BorderRadius.circular(11),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                RecipeDetailScreen.routeName,
                arguments: recipe.id,
              );
            },
            child: Hero(
              tag: recipe.id,
              child: recipe.imageUrl == null
                  ? const FadeInImage(
                      fit: BoxFit.fill,
                      placeholderFit: BoxFit.fill,
                      placeholder: AssetImage('assets/placeholder.png'),
                      image: AssetImage(
                        'assets/cutlery.png',
                      ),
                    )
                  : FadeInImage(
                      fit: BoxFit.fill,
                      placeholderFit: BoxFit.fill,
                      placeholder: const AssetImage('assets/placeholder.png'),
                      image: NetworkImage(
                        recipe.imageUrl!,
                      ),
                    ),
            ),
          ),
          footer: GridTileBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    recipe.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      recipe.selectFavorite(userId);
                    });
                    if (recipe.favorite == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          elevation: 10,
                          backgroundColor: Colors.black,
                          content: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'This item has been added to your favorites',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.orange,
                                    ),
                                    foregroundColor: MaterialStateProperty.all(
                                      Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      recipe.favorite = false;
                                    });
                                  },
                                  child: const Text(
                                    'UNDO',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    recipe.favorite == false
                        ? Icons.favorite_border
                        : Icons.favorite,
                  ),
                  color: Colors.orange,
                ),
              ],
            ),
            backgroundColor: Colors.black87,
          ),
        ),
      ),
    );
  }
}
