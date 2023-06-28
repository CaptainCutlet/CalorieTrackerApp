// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/diary_provider.dart';
import '../providers/recipe_model.dart';
import '../providers/diary_item_model.dart';

class BottomBar extends StatefulWidget {
  final Recipe recipe;
  BottomBar(this.recipe);
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool isExpanded = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController servingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var diaryItem2;
    final functions = Provider.of<DiaryProvider>(context, listen: false);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
      height: isExpanded == false ? 50 : 145,
      color: Theme.of(context).primaryColor,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                label: Text(
                  'Nutrition',
                  style: Theme.of(context).textTheme.headline2,
                ),
                icon: Icon(
                  isExpanded == false
                      ? Icons.arrow_drop_down_rounded
                      : Icons.arrow_drop_up_rounded,
                  color: Theme.of(context).accentColor,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(32.0),
                        ),
                      ),
                      elevation: 24,
                      alignment: Alignment.center,
                      title: Text(
                        'How many servings would you like to add?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: servingController,
                            decoration: const InputDecoration(
                              labelText: 'Number of Servings',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              diaryItem2 = DiaryItemModel(
                                title: widget.recipe.title,
                                p: widget.recipe.p * int.parse(value),
                                c: widget.recipe.c * int.parse(value),
                                f: widget.recipe.f * int.parse(value),
                                id: widget.recipe.id,
                                kcal: widget.recipe.kcal * int.parse(value),
                                servings: widget.recipe.servings,
                                recipeId: widget.recipe.id,
                                date: DateTime.now().day,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              functions
                                  .addToDiary(
                                    diaryItem2,
                                    userId,
                                    widget.recipe.id,
                                    DateTime.now().day,
                                  )
                                  .then(
                                    (value) => Navigator.of(context).pop(),
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  elevation: 10,
                                  backgroundColor:
                                      const Color.fromARGB(255, 155, 146, 146),
                                  content: FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'This item has been added to your diary',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all<Size>(
                                              const Size(75, 30),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.black,
                                            ),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                          ),
                                          onPressed: () {
                                            var diaryItem = DiaryItemModel(
                                              title: widget.recipe.title,
                                              p: widget.recipe.p,
                                              c: widget.recipe.c,
                                              f: widget.recipe.f,
                                              id: widget.recipe.id,
                                              kcal: widget.recipe.kcal,
                                              servings: widget.recipe.servings,
                                              recipeId: widget.recipe.id,
                                              date: DateTime.now().day,
                                            );
                                            functions.removeFromDiary(
                                                diaryItem, userId);
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
                            },
                            child: const Text('Add To Diary'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                label: Text(
                  'Add to diary',
                  style: Theme.of(context).textTheme.headline2,
                ),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
          if (isExpanded == true)
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.linear,
              child: Column(
                children: [
                  NutritionRow('Calories / Serving', widget.recipe.kcal),
                  NutritionRow('Protein', widget.recipe.p),
                  NutritionRow('Carbohydrates', widget.recipe.c),
                  NutritionRow('Fat', widget.recipe.f),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class NutritionRow extends StatelessWidget {
  final String name;
  final num number;
  NutritionRow(this.name, this.number);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            number.toString(),
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
