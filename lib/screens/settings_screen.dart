// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/loading_spinner.dart';
import 'account_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings-screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String email = '';
  String username = '';
  late Future<String> future;
  final formKey = GlobalKey<FormState>();
  User? currentUser;
  bool isLoading = false;

  @override
  void initState() {
    User user = FirebaseAuth.instance.currentUser!;
    email = user.email!;

    Future<String> getUserData() async {
      username = await FirebaseFirestore.instance
          .collection('users_info')
          .doc(user.uid)
          .get()
          .then((value) {
        return value['username'];
      });
      return username;
    }

    getUserData().then((value) {
      setState(() {
        username = value;
      });
    });
    currentUser = user;
    future = getUserData();

    super.initState();
  }

  Future<void> changeUserData() async {
    setState(() {
      isLoading = true;
    });
    bool isValid = formKey.currentState!.validate();
    if (isValid == false) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    formKey.currentState!.save();
    FirebaseFirestore.instance
        .collection('users_info')
        .orderBy(currentUser!.uid, descending: true);
    await FirebaseFirestore.instance
        .collection('users_info')
        .doc(currentUser!.uid)
        .delete();
    await FirebaseFirestore.instance
        .collection('users_info')
        .doc(currentUser!.uid)
        .set({
      'email': currentUser!.email,
      'username': username,
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context)
          .popAndPushNamed(AccountScreen.routeName, arguments: username);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your changes have been saved',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: isLoading == true
          ? LoadingSpinner()
          : FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? LoadingSpinner()
                    : Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  right: 5, bottom: 8, left: 5, top: 15),
                              child: TextFormField(
                                initialValue: email,
                                onSaved: (newValue) {
                                  email = newValue!;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Email adress'),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 8),
                              child: TextFormField(
                                initialValue: username,
                                validator: (value) {
                                  if (value!.length > 16) {
                                    return 'The username should not exceed 17 characters';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  username = newValue!;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Username'),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await changeUserData();
                              },
                              child: const Text('Save changes'),
                            ),
                          ],
                        ),
                      );
              }),
    );
  }
}
