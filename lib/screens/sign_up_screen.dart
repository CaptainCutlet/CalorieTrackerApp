// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, await_only_futures, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/diary_provider.dart';
import 'main_screen.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/Sign-up-screen';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map<String, String> kcalData = {
      'kcal': '0',
      'p': '0',
      'c': '0',
      'f': '0',
    };

    void submit(Map<String, String> usersData) async {
      bool isValid = _formKey.currentState!.validate();
      if (isValid == false) {
        return;
      } else {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        _formKey.currentState!.save();
        Provider.of<DiaryProvider>(context, listen: false)
            .AddUserGoals(
              userId,
              usersData['kcal']!,
              usersData['p']!,
              usersData['c']!,
              usersData['f']!,
              context,
            )
            .then(
              (value) => Navigator.of(context)
                  .pushReplacementNamed(MainScreen.routeName),
            );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Recipier! Please enter the following data for the best experience',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(10),
            color: Theme.of(context).accentColor,
            elevation: 100,
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Enter Your Calorie Goal'),
                      ),
                      onSaved: (newValue) {
                        kcalData['kcal'] = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value.';
                        } else if (value == '0') {
                          return 'Please enter a valid value.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Enter Your Protein Goal'),
                      ),
                      onSaved: (newValue) {
                        kcalData['p'] = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Enter Your Carbohydrates Goal'),
                      ),
                      onSaved: (newValue) {
                        kcalData['c'] = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Enter Your Fats Goal'),
                      ),
                      onSaved: (newValue) {
                        kcalData['f'] = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value.';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: () => submit(kcalData),
                      icon: const Icon(Icons.check),
                      label: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
