// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, avoid_print, unused_local_variable

import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipier/screens/main_screen.dart';
import 'package:recipier/widgets/loading_spinner.dart';

import '../providers/recipes_provider.dart';
import '../providers/recipe_model.dart';

class NutritionScreen extends StatefulWidget {
  static const routeName = '/route-name';
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late RecipeProvider functions;
  bool _isInit = true;

  Recipe newRecipe = Recipe(
    title: '',
    description: '',
    id: '',
    ingredients: [''],
    steps: [''],
    creatorId: '',
    kcal: 0,
    p: 0,
    c: 0,
    f: 0,
    servings: 0,
  );

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Recipe recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
      newRecipe = recipe;
      newRecipe.isVegan = recipe.isVegan;
      newRecipe.isVegetarian = recipe.isVegetarian;
      newRecipe.isKeto = recipe.isKeto;
      newRecipe.isLowCalories = recipe.isLowCalories;
      newRecipe.isLowCarbs = recipe.isLowFat;
      newRecipe.isLowFat = recipe.isLowFat;
      functions = Provider.of<RecipeProvider>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> saveForm() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    bool isValid = _formKey.currentState!.validate();
    setState(() {
      isLoading = true;
    });
    if (isValid == true) {
      try {
        _formKey.currentState!.save();
        if (newRecipe.id == '') {
          await functions.addRecipe(newRecipe);
          print('Add');
        } else {
          await functions.editRecipe(newRecipe);
          print('Edit');
        }
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
      } catch (error) {
        rethrow;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Add Nutrition Data',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: isLoading == true
          ? LoadingSpinner()
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  NutritionRow(
                    'Total Calories',
                    TextFormField(
                      initialValue:
                          newRecipe.kcal == 0 ? '' : '${newRecipe.kcal}',
                      validator: (value) {
                        if (int.parse(value!) <= 0) {
                          return 'Please enter a valid number';
                        } else if (value.isEmpty) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'kcal'),
                      onSaved: (value) {
                        newRecipe = Recipe(
                          title: newRecipe.title,
                          description: newRecipe.description,
                          id: newRecipe.id,
                          ingredients: newRecipe.ingredients,
                          steps: newRecipe.steps,
                          imageUrl: newRecipe.imageUrl,
                          creatorId: newRecipe.creatorId,
                          kcal: int.parse(value!),
                          p: newRecipe.p,
                          c: newRecipe.c,
                          f: newRecipe.f,
                          servings: newRecipe.servings,
                          isVegan: newRecipe.isVegan,
                          isKeto: newRecipe.isKeto,
                          isVegetarian: newRecipe.isVegetarian,
                          isLowCalories: newRecipe.isLowCalories,
                          isLowCarbs: newRecipe.isLowCarbs,
                          isLowFat: newRecipe.isLowFat,
                        );
                      },
                    ),
                  ),
                  NutritionRow(
                    'Protein',
                    TextFormField(
                      initialValue: newRecipe.p == 0 ? '' : '${newRecipe.p}',
                      validator: (value) {
                        if (int.parse(value!) < 0) {
                          return 'Please enter a valid number';
                        } else if (value.isEmpty) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'protein'),
                      onSaved: (value) {
                        newRecipe = Recipe(
                          creatorId: newRecipe.creatorId,
                          title: newRecipe.title,
                          description: newRecipe.description,
                          id: newRecipe.id,
                          ingredients: newRecipe.ingredients,
                          steps: newRecipe.steps,
                          imageUrl: newRecipe.imageUrl,
                          kcal: newRecipe.kcal,
                          p: int.parse(value!),
                          c: newRecipe.c,
                          f: newRecipe.f,
                          servings: newRecipe.servings,
                          isVegan: newRecipe.isVegan,
                          isKeto: newRecipe.isKeto,
                          isVegetarian: newRecipe.isVegetarian,
                          isLowCalories: newRecipe.isLowCalories,
                          isLowCarbs: newRecipe.isLowCarbs,
                          isLowFat: newRecipe.isLowFat,
                        );
                      },
                    ),
                  ),
                  NutritionRow(
                    'Carbohydrates',
                    TextFormField(
                      initialValue: newRecipe.c == 0 ? '' : '${newRecipe.c}',
                      validator: (value) {
                        if (int.parse(value!) < 0) {
                          return 'Please enter a valid number';
                        } else if (value.isEmpty) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Carbohydrates'),
                      onSaved: (value) {
                        newRecipe = Recipe(
                          creatorId: newRecipe.creatorId,
                          title: newRecipe.title,
                          description: newRecipe.description,
                          id: newRecipe.id,
                          ingredients: newRecipe.ingredients,
                          steps: newRecipe.steps,
                          imageUrl: newRecipe.imageUrl,
                          kcal: newRecipe.kcal,
                          p: newRecipe.p,
                          c: int.parse(value!),
                          f: newRecipe.f,
                          servings: newRecipe.servings,
                          isVegan: newRecipe.isVegan,
                          isKeto: newRecipe.isKeto,
                          isVegetarian: newRecipe.isVegetarian,
                          isLowCalories: newRecipe.isLowCalories,
                          isLowCarbs: newRecipe.isLowCarbs,
                          isLowFat: newRecipe.isLowFat,
                        );
                      },
                    ),
                  ),
                  NutritionRow(
                    'Fats',
                    TextFormField(
                      initialValue: newRecipe.f == 0 ? '' : '${newRecipe.f}',
                      validator: (value) {
                        if (int.parse(value!) < 0) {
                          return 'Please enter a valid number';
                        } else if (value.isEmpty) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Fats'),
                      onSaved: (value) {
                        newRecipe = Recipe(
                          creatorId: newRecipe.creatorId,
                          title: newRecipe.title,
                          description: newRecipe.description,
                          id: newRecipe.id,
                          ingredients: newRecipe.ingredients,
                          steps: newRecipe.steps,
                          imageUrl: newRecipe.imageUrl,
                          kcal: newRecipe.kcal,
                          p: newRecipe.p,
                          c: newRecipe.c,
                          f: int.parse(value!),
                          servings: newRecipe.servings,
                          isVegan: newRecipe.isVegan,
                          isKeto: newRecipe.isKeto,
                          isVegetarian: newRecipe.isVegetarian,
                          isLowCalories: newRecipe.isLowCalories,
                          isLowCarbs: newRecipe.isLowCarbs,
                          isLowFat: newRecipe.isLowFat,
                        );
                      },
                    ),
                  ),
                  NutritionRow(
                    'Servings',
                    TextFormField(
                      initialValue: newRecipe.servings == 0
                          ? ''
                          : '${newRecipe.servings}',
                      validator: (value) {
                        if (int.parse(value!) < 0) {
                          return 'Please enter a valid number';
                        } else if (value.isEmpty) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Servings'),
                      onSaved: (value) {
                        newRecipe = Recipe(
                          title: newRecipe.title,
                          description: newRecipe.description,
                          id: newRecipe.id,
                          ingredients: newRecipe.ingredients,
                          imageUrl: newRecipe.imageUrl,
                          steps: newRecipe.steps,
                          creatorId: newRecipe.creatorId,
                          kcal: (newRecipe.kcal / int.parse(value!)).round(),
                          p: (newRecipe.p / int.parse(value)).round(),
                          c: (newRecipe.c / int.parse(value)).round(),
                          f: (newRecipe.f / int.parse(value)).round(),
                          servings: int.parse(value),
                          isVegan: newRecipe.isVegan,
                          isKeto: newRecipe.isKeto,
                          isVegetarian: newRecipe.isVegetarian,
                          isLowCalories: newRecipe.isLowCalories,
                          isLowCarbs: newRecipe.isLowCarbs,
                          isLowFat: newRecipe.isLowFat,
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: Theme.of(context)
                        .elevatedButtonTheme
                        .style!
                        .copyWith(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(
                              deviceSize.width * 0.6,
                              deviceSize.height * 0.07,
                            ),
                          ),
                        ),
                    onPressed: saveForm,
                    child: Text(
                      'DONE',
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }
}

class NutritionRow extends StatelessWidget {
  final String value;
  Widget child;
  NutritionRow(this.value, this.child);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 20,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.headline6),
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  child: child,
                  width: 100,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
