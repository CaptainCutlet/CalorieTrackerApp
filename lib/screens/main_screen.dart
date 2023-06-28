// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, constant_identifier_names, unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/filters_provider.dart';
import '../providers/recipe_model.dart';
import '../screens/all_recipes_screen.dart';
import '../providers/recipes_provider.dart';
import '../screens/add_recipe_screen.dart';
import '../widgets/loading_spinner.dart';
import 'diary_screen.dart';
import 'auth_screen.dart';
import '../widgets/action_button.dart';
import '../widgets/expandable_fab.dart';
import 'account_screen.dart';
import '../providers/diary_provider.dart';
import '../widgets/drawer.dart';

enum FilterOptions {
  Favorites,
  All,
}

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _runsForFirstTime = true;
  bool showOnlyFavorites = false;
  int _selectedIndex = 0;
  bool _isLoading = false;
  User user = FirebaseAuth.instance.currentUser!;
  String username = '';
  Map<String, bool> initialFilters = {
    'vegan': false,
    'vegetarian': false,
    'lowCalorie': false,
    'lowFat': false,
    'lowCarbs': false,
    'keto': false,
  };
  List<Recipe> recipes = [];

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
  }

  Future<void> getUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users_info')
        .doc(user.uid)
        .get();
    username = userData['username'];
  }

  @override
  void didChangeDependencies() {
    if (_runsForFirstTime == true) {
      setState(() {
        _isLoading = true;
      });
      User user = FirebaseAuth.instance.currentUser!;
      Provider.of<FiltersProvider>(context)
          .setUserFilters(initialFilters, user.uid);
      Provider.of<FiltersProvider>(context).getUserFilters(user.uid);
      Provider.of<RecipeProvider>(context).fetchProducts();
      Provider.of<DiaryProvider>(context).fetchUserDiary(user.uid);
      getUserData();
      // Map<String, dynamic> initialData =
      //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      // if (initialData != null) {
      //   Provider.of<DiaryProvider>(context, listen: false)
      //       .AddUserGoals(user.uid, initialData['kcal'], initialData['p'],
      //           initialData['c'], initialData['f'], context)
      //       .then((_) {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   });
      // }
      _isLoading = false;
    }

    _runsForFirstTime = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screenOptions = [
      // RecipesGrid(_showOnlyFavorites),
      AllRecipesScreen(showOnlyFavorites),
      DiaryScreen(),
    ];
    return _isLoading == true
        ? Scaffold(
            body: LoadingSpinner(),
          )
        : Scaffold(
            drawer: AppDrawer(),
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              }),
              actions: [
                if (_selectedIndex == 0)
                  PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.Favorites,
                      ),
                      const PopupMenuItem(
                        child: Text('Show All'),
                        value: FilterOptions.All,
                      ),
                    ],
                    onSelected: (FilterOptions selectedValue) {
                      if (selectedValue == FilterOptions.Favorites) {
                        setState(() {
                          showOnlyFavorites = true;
                        });
                      } else {
                        setState(() {
                          showOnlyFavorites = false;
                        });
                      }
                    },
                  ),
              ],
              title: Text(
                _selectedIndex.isEven ? 'Recipes' : 'Your Diary',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              backgroundColor: Theme.of(context).primaryColor,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.white,
              selectedFontSize: 20,
              unselectedFontSize: 16,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.border_all_rounded),
                  label: 'All',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: 'Diary',
                ),
              ],
            ),
            body: _screenOptions.elementAt(_selectedIndex),
            floatingActionButton: ExpandableFab(
              distance: 112.0,
              children: [
                ActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddRecipeScreen.routeName);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                ActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AccountScreen.routeName,
                        arguments: username);
                  },
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                ActionButton(
                  onPressed: _signOut,
                  icon: Icon(
                    Icons.logout_outlined,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          );
  }
}
