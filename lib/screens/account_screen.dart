// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../widgets/user_item.dart';
import '../providers/recipes_provider.dart';
import 'settings_screen.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account-screen';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  var controller = TextEditingController();
  // String userImageUrl = '';

  // Future<String> getUserImage() async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   userImageUrl = await FirebaseFirestore.instance
  //       .doc('users_info')
  //       .collection(userId)
  //       .get()
  //       .then((value) => value.docs
  //           .firstWhere((element) => element['profile_picture'] != null));

  //   return userImageUrl;
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context)!.settings.arguments as String;
    final recipes = Provider.of<RecipeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          username,
          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(SettingsScreen.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: CircleAvatar(
                minRadius: 50,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            recipes.userRecipes.isEmpty
                ? Center(
                    child: Text(
                      'You have not added any recipes. Try adding some!',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, i) {
                        return ChangeNotifierProvider.value(
                          value: recipes.userRecipes[i],
                          child: UserItem(recipes.userRecipes[i]),
                        );
                      },
                      itemCount: recipes.userRecipes.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
