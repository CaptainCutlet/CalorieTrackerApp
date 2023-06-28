// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/loading_spinner.dart';
import '../providers/filters_provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool vegan = false;
  bool vegetarian = false;
  bool keto = false;
  bool lowCarb = false;
  bool lowFat = false;
  bool lowCalories = false;
  bool _isLoading = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Map<String, bool> filters = {};

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<FiltersProvider>(context, listen: false)
        .getUserFilters(userId)
        .then((_) {
      filters =
          Provider.of<FiltersProvider>(context, listen: false).filtersList;
      vegan = filters['vegan']!;
      vegetarian = filters['vegetarian']!;
      keto = filters['keto']!;
      lowCarb = filters['lowCarbs']!;
      lowFat = filters['lowFat']!;
      lowCalories = filters['lowCalorie']!;
      setState(() {
        _isLoading = false;
      });
    });

    // returnint filterius tada su map ir keys
    super.didChangeDependencies();
  }

  Widget _buildSwitchTile(bool currentValue, String title, BuildContext context,
      Function(bool value) changeValue, String subtitle) {
    return SwitchListTile(
      value: currentValue,
      onChanged: changeValue,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5!.copyWith(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.headline5!.copyWith(
            fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      inactiveThumbColor: const Color.fromARGB(255, 106, 101, 101),
      activeTrackColor: const Color.fromARGB(255, 200, 138, 45),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _isLoading == true
        ? LoadingSpinner()
        : Card(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              width: size.width * 0.75,
              height: size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Choose Filters',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 5),
                  _buildSwitchTile(vegan, 'Vegan', context, (newValue) {
                    setState(() {
                      vegan = newValue;
                    });
                  }, 'Show only vegan-friendly recipes'),
                  _buildSwitchTile(vegetarian, 'Vegetarian', context,
                      (newValue) {
                    setState(() {
                      vegetarian = newValue;
                    });
                  }, 'Show only vegetarian recipes'),
                  _buildSwitchTile(keto, 'Keto', context, (newValue) {
                    setState(() {
                      keto = newValue;
                    });
                  }, 'Show only keto-friendly recipes'),
                  _buildSwitchTile(lowCarb, 'Low-Carb', context, (newValue) {
                    setState(() {
                      lowCarb = newValue;
                    });
                  }, 'Only show recipes with less than 25g of carbs per serving'),
                  _buildSwitchTile(lowFat, 'Low-Fat', context, (newValue) {
                    setState(() {
                      lowFat = newValue;
                    });
                  }, 'Only show recipes with less than 10g of fat per serving'),
                  _buildSwitchTile(lowCalories, 'Low-Calories', context,
                      (newValue) {
                    setState(() {
                      lowCalories = newValue;
                    });
                  }, 'Only show recipes with less than 500kcal per serving'),
                  OutlinedButton(
                    onPressed: () async {
                      filters = {
                        'vegan': vegan,
                        'vegetarian': vegetarian,
                        'lowCalorie': lowCalories,
                        'lowFat': lowFat,
                        'lowCarbs': lowCarb,
                        'keto': keto,
                      };
                      await Provider.of<FiltersProvider>(context, listen: false)
                          .setUserFilters(filters, userId);
                      await Provider.of<FiltersProvider>(context, listen: false)
                          .getUserFilters(userId);
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all<Color>(Colors.grey[300]!),
                      fixedSize:
                          MaterialStateProperty.all<Size>(const Size(225, 50)),
                      splashFactory: InkSplash.splashFactory,
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    child: Text(
                      'Save filters',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(
                      Icons.restore_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      filters = {
                        'vegan': false,
                        'vegetarian': false,
                        'lowCalorie': false,
                        'lowFat': false,
                        'lowCarbs': false,
                        'keto': false,
                      };
                      await Provider.of<FiltersProvider>(context, listen: false)
                          .setUserFilters(filters, userId);
                      await Provider.of<FiltersProvider>(context, listen: false)
                          .getUserFilters(userId);
                      Navigator.of(context).pop();
                    },
                    label: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
