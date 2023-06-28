// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_model.dart';
import '../screens/recipe_details_screen.dart';

class RecipeRowItem extends StatefulWidget {
  @override
  State<RecipeRowItem> createState() => _RecipeRowItemState();
}

class _RecipeRowItemState extends State<RecipeRowItem> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // String generateRandomString(int len) {
  //   var r = Random();
  //   return String.fromCharCodes(
  //       List.generate(len, (index) => r.nextInt(33) + 89));
  // }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = Provider.of<Recipe>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      height: 135,
      width: 175,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor, width: 2),
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
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: SizedBox(
              width: 120,
              child: Text(
                recipe.title,
                textAlign: TextAlign.left,
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 15),
              ),
            ),
            subtitle: IconButton(
              padding: const EdgeInsets.only(left: 2, right: 1),
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
                size: 20,
              ),
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}
