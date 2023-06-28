// ignore_for_file: deprecated_member_use, non_constant_identifier_names, use_key_in_widget_constructors, must_be_immutable

import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipier/widgets/loading_spinner.dart';

import '../screens/nutrition_screen.dart';
import '../widgets/image_picker.dart';
import '../providers/recipe_model.dart';
import '../providers/recipes_provider.dart';
import '../widgets/grid_cat.dart';

class EditRecipeScreen extends StatefulWidget {
  static const routeName = '/edit-recipe-screen';
  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionNode = FocusNode();
  bool isInit = true;
  final _instructionsNode = FocusNode();
  late RecipeProvider functions;
  File pickedImage = File('');
  String imagePath = '';
  bool isLoading = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  int counter = 1;
  int instructionsCounter = 0;
  List<Widget> ingredietsFieldList = [];
  List<Widget> instructionsFieldList = [];
  final List<String> _examplesForIngredients = [
    'Ex.: 200g banana',
    'Ex.: 150g almond flour',
    'Ex.: 60g apple'
        'Ex.: 280g chicken breast',
  ];
  final List<String> _examplesForInstructions = [
    'Ex.: Mix dry ingredients in a bowl',
    'Ex.: Add wet ingredients to the dry',
    'Ex.: Slice the apples'
        'Ex.: Bake at 220 for 35 minutes',
  ];

  bool isVegan = false;
  bool isVegetarian = false;
  bool isKeto = false;
  bool isLowFat = false;
  bool isLowCarbs = false;
  bool isLowCalories = false;

  Recipe newRecipe = Recipe(
    title: '',
    description: '',
    id: '',
    ingredients: [''],
    steps: [''],
    kcal: 0,
    p: 0,
    c: 0,
    f: 0,
    servings: 0,
    imageUrl: '',
    creatorId: '',
  );

  void selectImage(File selectedImage) {
    pickedImage = selectedImage;
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  String generateRandomExample() {
    var r = Random();
    String randomExample =
        _examplesForIngredients[r.nextInt(_examplesForIngredients.length)];
    return randomExample;
  }

  String generateRandomExampleInstructions() {
    var r = Random();
    String randomExample =
        _examplesForInstructions[r.nextInt(_examplesForInstructions.length)];
    return randomExample;
  }

  @override
  void dispose() {
    _descriptionNode.dispose();
    _instructionsNode.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    bool isValid = _formKey.currentState!.validate();
    int randomIndex = 0;
    setState(() {
      isLoading = true;
    });
    var rng = Random();
    for (var i = 0; i < 10; i++) {
      randomIndex = rng.nextInt(10000000);
    }
    if (isValid == true) {
      _formKey.currentState!.save();
      newRecipe.steps.removeAt(0);
      newRecipe.ingredients.removeAt(0);
      newRecipe.isKeto = isKeto;
      newRecipe.isVegan = isVegan;
      newRecipe.isVegetarian = isVegetarian;
      newRecipe.isLowCalories = isLowCalories;
      newRecipe.isLowCarbs = isLowCarbs;
      newRecipe.isLowFat = isLowFat;
      final storagePath = FirebaseStorage.instance
          .ref()
          .child('recipe_image')
          .child(newRecipe.title + '$randomIndex' + '.jpg');
      // dar nesukurtas, t.y nera id
      if (newRecipe.id != '' || newRecipe.id.isNotEmpty) {
        storagePath.delete();
      }
      await storagePath.putFile(pickedImage);
      final imageUrl = await storagePath.getDownloadURL();
      newRecipe.imageUrl = imageUrl;
      // Map<String, dynamic> data = {
      //   'filters': filters,
      //   'data': newRecipe,
      // };
      Navigator.of(context)
          .pushNamed(NutritionScreen.routeName, arguments: newRecipe);
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _createIngredientsFormField(int counter, String? initValue) {
    String randomKey = generateRandomString(10);
    String randomExample = generateRandomExample();
    return Material(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextFormField(
          key: ValueKey(randomKey),
          // initialValue: newRecipe.ingredients
          //     .toString()
          //     .substring(1, newRecipe.ingredients.toString().length - 1),
          initialValue: initValue ?? "",
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Ingredient Nr.$counter',
            hintText: randomExample,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          keyboardType: TextInputType.text,
          maxLines: 1,
          onSaved: (value) {
            if (value!.trim() == "" || value.trim() == " " || value.isEmpty) {
              return;
            } else {
              newRecipe.ingredients.add('$counter. $value');
              newRecipe = Recipe(
                creatorId: userId,
                title: newRecipe.title,
                description: newRecipe.description,
                id: newRecipe.id,
                ingredients: newRecipe.ingredients,
                steps: newRecipe.steps,
                kcal: newRecipe.kcal,
                p: newRecipe.p,
                c: newRecipe.c,
                f: newRecipe.f,
                servings: newRecipe.servings,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _createInstructionsFormField(int counter, String? initValue) {
    String randomKey = generateRandomString(10);
    String randomExample = generateRandomExampleInstructions();
    return Material(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: TextFormField(
          key: ValueKey(randomKey),
          initialValue: initValue ?? "",
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Step Nr.$counter',
            hintText: randomExample,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          keyboardType: TextInputType.text,
          maxLines: 1,
          onSaved: (value) {
            if (value == "" || value == " ") {
              return;
            } else {
              newRecipe.steps.add('$counter. ${value!}');
              newRecipe = Recipe(
                creatorId: userId,
                title: newRecipe.title,
                description: newRecipe.description,
                id: newRecipe.id,
                ingredients: newRecipe.ingredients,
                steps: newRecipe.steps,
                kcal: newRecipe.kcal,
                p: newRecipe.p,
                c: newRecipe.c,
                f: newRecipe.f,
                servings: newRecipe.servings,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (isInit == true) {
      newRecipe = ModalRoute.of(context)!.settings.arguments as Recipe;
      functions = Provider.of<RecipeProvider>(context, listen: false);
      // create initial ingredient and instruction fieds
      for (int i = 0; i < newRecipe.ingredients.length; i++) {
        setState(() {
          ingredietsFieldList.add(
              _createIngredientsFormField(counter, newRecipe.ingredients[i]));
          instructionsFieldList
              .add(_createInstructionsFormField(counter, newRecipe.steps[i]));
          if (i != newRecipe.ingredients.length - 1) {
            counter++;
          }
        });
      }
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Edit Your Recipe',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: isLoading == true
          ? LoadingSpinner()
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: newRecipe.title,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        FocusScope.of(context).nextFocus();
                        newRecipe = Recipe(
                          title: value!,
                          description: newRecipe.description,
                          id: newRecipe.id,
                          ingredients: newRecipe.ingredients,
                          steps: newRecipe.steps,
                          kcal: newRecipe.kcal,
                          p: newRecipe.p,
                          c: newRecipe.c,
                          f: newRecipe.f,
                          servings: newRecipe.servings,
                          creatorId: userId,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      initialValue: newRecipe.description,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      focusNode: _descriptionNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (value) {
                        newRecipe = Recipe(
                          creatorId: userId,
                          title: newRecipe.title,
                          description: value!,
                          id: newRecipe.id,
                          ingredients: newRecipe.ingredients,
                          steps: newRecipe.steps,
                          kcal: newRecipe.kcal,
                          p: newRecipe.p,
                          c: newRecipe.c,
                          f: newRecipe.f,
                          servings: newRecipe.servings,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Add Ingredients',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      itemCount: ingredietsFieldList.length,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return ingredietsFieldList[index];
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AddEntryButton(
                      () {
                        counter += 1;
                        setState(
                          () {
                            ingredietsFieldList.add(
                              _createIngredientsFormField(counter, null),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Add Instructions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      itemCount: instructionsFieldList.length,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return instructionsFieldList[index];
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AddEntryButton(
                      () {
                        instructionsCounter += 1;
                        setState(
                          () {
                            instructionsFieldList.add(
                              _createInstructionsFormField(
                                  instructionsCounter, null),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FittedBox(
                      child: SelectImage(
                        selectImage,
                        newRecipe.imageUrl!,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FloatingActionButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        splashColor: Theme.of(context).accentColor,
                        foregroundColor: Theme.of(context).accentColor,
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () async {
                          await showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text(
                                'Select filters for your recipe',
                                textAlign: TextAlign.center,
                              ),
                              content: CategoryGrid(newRecipe),
                            ),
                          ).then((filtersData) {
                            isVegan = filtersData['vegan'];
                            // print(newRecipe.isVegan); true
                            isVegetarian = filtersData['vegetarian'];
                            isKeto = filtersData['keto'];
                            isLowCalories = filtersData['lowCalorie'];
                            isLowCarbs = filtersData['lowCarbs'];
                            isLowFat = filtersData['lowFat'];
                          });
                        },
                        child: Text(
                          'Choose Filters',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.all(8),
          child: SizedBox.fromSize(
            size: const Size(80, 80),
            child: ClipOval(
              child: Material(
                color: Theme.of(context).primaryColor,
                child: InkWell(
                  splashColor: Theme.of(context).primaryColorLight,
                  onTap: () => saveData(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_right_alt,
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddEntryButton extends StatefulWidget {
  Function onPressed;
  AddEntryButton(this.onPressed);

  @override
  State<AddEntryButton> createState() => _AddEntryButtonState();
}

class _AddEntryButtonState extends State<AddEntryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(1000),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        alignment: Alignment.center,
        backgroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
        foregroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
      ),
      child: const Text('Add entries'),
      onPressed: () => widget.onPressed(),
    );
  }
}
