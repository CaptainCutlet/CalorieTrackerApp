// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth_card.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = 'auth-screen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  var firebaseAuth = FirebaseAuth.instance;

  Future<void> authUser(String email, String password, bool isLogin,
      String username, String profilePictureUrl) async {
    setState(() {
      isLoading = true;
    });
    UserCredential userCreadencial;
    FocusScope.of(context).unfocus();

    try {
      if (isLogin == false) {
        userCreadencial = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCreadencial = await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      FirebaseFirestore.instance
          .collection('users_info')
          .orderBy(userCreadencial.user!.uid, descending: true);
      await FirebaseFirestore.instance
          .collection('users_info')
          .doc(userCreadencial.user!.uid)
          .set({
        'email': userCreadencial.user!.email,
        'username': username,
        'profile_picture': profilePictureUrl,
      });

      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (err) {
      print(err);
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
        ),
        child: AuthCard(authUser, isLoading),
      ),
    );
  }
}
