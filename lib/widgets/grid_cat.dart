// ignore_for_file: deprecated_member_use, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../providers/recipe_model.dart';

class CategoryGrid extends StatefulWidget {
  Recipe recipe;
  CategoryGrid(this.recipe);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  bool isVegan = false;
  bool isVegetarian = false;
  bool isKeto = false;
  bool isLowFat = false;
  bool isLowCarbs = false;
  bool isLowCalories = false;

  Map<String, bool> filtersData = {
    'vegan': false,
    'vegetarian': false,
    'lowCalorie': false,
    'lowFat': false,
    'lowCarbs': false,
    'keto': false,
  };

  @override
  void initState() {
    isVegan = widget.recipe.isVegan;
    isVegetarian = widget.recipe.isVegetarian;
    isKeto = widget.recipe.isKeto;
    isLowFat = widget.recipe.isLowFat;
    isLowCarbs = widget.recipe.isLowCarbs;
    isLowCalories = widget.recipe.isLowCalories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.1,
      child: Column(
        children: [
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
              ),
              children: [
                Item('Vegan', isVegan, (value) {
                  isVegan = value;
                }),
                Item('Vegetarian', isVegetarian, (value) {
                  isVegetarian = value;
                }),
                Item('Low-fat', isLowFat, (value) {
                  isLowFat = value;
                }),
                Item('Low-carbs', isLowCarbs, (value) {
                  isLowCarbs = value;
                }),
                Item('Under 500kcal', isLowCalories, (value) {
                  isLowCalories = value;
                }),
                Item('Keto', isKeto, (value) {
                  isKeto = value;
                }),
              ],
            ),
          ),
          ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(200, 40),
                  ),
                ),
            onPressed: () {
              filtersData['vegan'] = isVegan;
              filtersData['vegetarian'] = isVegetarian;
              filtersData['lowFat'] = isLowFat;
              filtersData['lowCarbs'] = isLowCarbs;
              filtersData['lowCalorie'] = isLowCalories;
              filtersData['keto'] = isKeto;
              Navigator.of(context).pop(filtersData);
            },
            child: const Text(
              'Save filters',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class Item extends StatefulWidget {
  final String data;
  bool categoryType;
  Function changeValue;
  Item(this.data, this.categoryType, this.changeValue);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
            widget.categoryType == false
                ? Colors.white
                : Theme.of(context).primaryColor),
        backgroundColor: MaterialStateProperty.all<Color>(
            widget.categoryType == false
                ? Theme.of(context).primaryColor
                : Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Theme.of(context).primaryColor, width: 3),
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          widget.categoryType = !widget.categoryType;
        });
        widget.changeValue(widget.categoryType);
      },
      icon: Icon(
        widget.categoryType == false ? Icons.close : Icons.check,
        color: widget.categoryType == false
            ? Colors.white
            : Theme.of(context).primaryColor,
        size: widget.categoryType == false ? 20 : 20,
      ),
      label: Text(
        widget.data,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: widget.categoryType == false
                ? Colors.white
                : Theme.of(context).primaryColor),
      ),
    );
  }
}
