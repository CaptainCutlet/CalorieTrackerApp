// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipier/screens/edit_recipe_screen.dart';
import 'package:recipier/screens/recipe_category_screen.dart';

import '../widgets/loading_spinner.dart';
import '../providers/filters_provider.dart';
import '../screens/diary_screen.dart';
import '../screens/main_screen.dart';
import '../screens/nutrition_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/recipe_details_screen.dart';
import './providers/recipes_provider.dart';
import './screens/add_recipe_screen.dart';
import './providers/diary_provider.dart';
import './screens/account_screen.dart';
import './screens/sign_up_screen.dart';
import './screens/settings_screen.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        color: Colors.orange,
        child: Column(
          children: [
            Text(
              'An Error Occured',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              details.exceptionAsString(),
              style: TextStyle(fontSize: 30, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // int _blackPrimaryValue = 0xFF000000;
    // MaterialColor primaryBlack = MaterialColor(
    //   _blackPrimaryValue,
    //   <int, Color>{
    //     50: Color(0xFF000000),
    //     100: Color(0xFF000000),
    //     200: Color(0xFF000000),
    //     300: Color(0xFF000000),
    //     400: Color(0xFF000000),
    //     500: Color(_blackPrimaryValue),
    //     600: Color(0xFF000000),
    //     700: Color(0xFF000000),
    //     800: Color(0xFF000000),
    //     900: Color(0xFF000000),
    //   },
    // );

    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder<Object>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (ctx) => RecipeProvider(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => DiaryProvider(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => FiltersProvider(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.black.withOpacity(0.5),
                primarySwatch: Colors.purple,
                accentColor: Colors.white,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(130, 30),
                    ),
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.purple,
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.purple),
                      ),
                    ),
                  ),
                ),
                textTheme: GoogleFonts.latoTextTheme(
                  TextTheme(
                    headline1: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                    headline2: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    headline3: TextStyle(
                      fontSize: 15,
                      color: Colors.orange,
                      fontWeight: FontWeight.w400,
                    ),
                    headline4: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    headline5: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    headline6: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                cardTheme: CardTheme(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.purple,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                ),
              ),
              home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, AsyncSnapshot<User?> userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return LoadingSpinner();
                    }
                    if (userSnapshot.hasData || userSnapshot.data != null) {
                      print(userSnapshot.data!.uid);
                      return MainScreen();
                    }
                    return AuthScreen();
                  }),
              routes: {
                RecipeDetailScreen.routeName: (ctx) => RecipeDetailScreen(),
                AddRecipeScreen.routeName: (ctx) => AddRecipeScreen(),
                AuthScreen.routeName: (ctx) => AuthScreen(),
                DiaryScreen.routeName: (ctx) => DiaryScreen(),
                MainScreen.routeName: (ctx) => MainScreen(),
                NutritionScreen.routeName: (ctx) => NutritionScreen(),
                AccountScreen.routeName: (ctx) => AccountScreen(),
                SignUpScreen.routeName: (ctx) => SignUpScreen(),
                SettingsScreen.routeName: (ctx) => SettingsScreen(),
                CategoryRecipeScreen.routeName: (ctx) => CategoryRecipeScreen(),
                EditRecipeScreen.routeName: (ctx) => EditRecipeScreen(),
              },
            ),
          );
        });
  }
}
