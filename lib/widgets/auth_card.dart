// ignore_for_file: deprecated_member_use, avoid_print, use_key_in_widget_constructors, must_be_immutable
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/sign_up_screen.dart';
import 'loading_spinner.dart';

class AuthCard extends StatefulWidget {
  Function(String email, String password, bool islogin, String username,
      String profilePictureUrl) submit;
  bool isLoading;

  AuthCard(this.submit, this.isLoading);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  bool isLogin = true;
  bool isLoading = false;
  bool isValid = true;
  bool isObscure = true;
  bool isObscure2 = true;
  bool imageExists = false;
  final _formKey = GlobalKey<FormState>();
  File image = File('');
  String initialImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Socialist_red_flag.svg/2560px-Socialist_red_flag.svg.png';
  String password = '';
  String email = '';
  String conPassword = '';
  String username = '';
  String userImageUrl = '';
  final _passwordNode = FocusNode();
  final _conPasswordNode = FocusNode();
  final _usernameNode = FocusNode();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> _pickImage() async {
    int randomIndex = 0;
    var rng = Random();
    var picker = ImagePicker();
    XFile? userImage = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 75,
      maxWidth: 50,
      maxHeight: 50,
    );
    image = File(userImage!.path);

    for (var i = 0; i < 10; i++) {
      randomIndex = rng.nextInt(10000000);
    }
    final storagePath = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child(username + '$randomIndex' + '.jpg');
    await storagePath.putFile(image);
    userImageUrl = await storagePath.getDownloadURL();
    setState(() {
      imageExists = true;
    });
    print(userImageUrl);
  }

  void _trySubmit() {
    isValid = _formKey.currentState!.validate();
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    if (isValid == false) {
      setState(() {
        isLoading = false;
      });
      return;
    } else {
      _formKey.currentState!.save();
      widget.submit(
        email.trim(),
        password.trim(),
        isLogin,
        username.trim(),
        userImageUrl,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _passwordNode.dispose();
    _conPasswordNode.dispose();
    _usernameNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return LoadingSpinner();
    } else {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(10),
          color: Theme.of(context).accentColor,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                height: isLogin == true
                    ? isValid == false
                        ? MediaQuery.of(context).size.height * 0.55
                        : MediaQuery.of(context).size.height * 0.50
                    : MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: isLogin == false
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (isLogin == false)
                      CircleAvatar(
                        foregroundImage: imageExists == true
                            ? NetworkImage(userImageUrl)
                            : null,
                        minRadius: 75,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _pickImage();
                              },
                              icon: Icon(
                                Icons.camera,
                                size: 30,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            Text(
                              'Add Profile Picture',
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: email,
                      key: const ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Email adress'),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordNode);
                      },
                      onSaved: (newValue) {
                        email = newValue!;
                      },
                    ),
                    TextFormField(
                      initialValue: password,
                      key: const ValueKey('password'),
                      focusNode: _passwordNode,
                      textInputAction: TextInputAction.next,
                      obscureText: isObscure,
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Password has to be atleast 6 characters long';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_conPasswordNode);
                        password = value;
                      },
                      onSaved: (newValue) {
                        password = newValue!;
                      },
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: const Icon(Icons.remove_red_eye),
                        ),
                      ),
                    ),
                    if (isLogin == false)
                      TextFormField(
                        initialValue: conPassword,
                        key: const ValueKey('conPassword'),
                        textInputAction: TextInputAction.next,
                        focusNode: _conPasswordNode,
                        obscureText: isObscure2,
                        validator: (value) {
                          if (value! != password) {
                            return 'Password don\'t match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Confirm password'),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure2 = !isObscure2;
                              });
                            },
                            icon: const Icon(Icons.remove_red_eye),
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_usernameNode);
                        },
                        onSaved: (newValue) {
                          conPassword = newValue!;
                        },
                      ),
                    if (isLogin == false)
                      TextFormField(
                        initialValue: username,
                        key: const ValueKey('Username'),
                        focusNode: _usernameNode,
                        textInputAction: TextInputAction.done,
                        obscureText: false,
                        decoration: const InputDecoration(
                          label: Text('Username'),
                        ),
                        onSaved: (newValue) {
                          username = newValue!;
                        },
                      ),
                    Expanded(
                      child: Container(),
                    ),
                    widget.isLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                                child:
                                    Text(isLogin == true ? 'SignUp' : 'Login'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  isLogin == false
                                      ? {
                                          isValid =
                                              _formKey.currentState!.validate(),
                                          _trySubmit(),
                                          isValid == false
                                              ? _formKey.currentState!
                                                  .build(context)
                                              : {
                                                  _trySubmit(),
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          SignUpScreen
                                                              .routeName)
                                                }
                                        }
                                      : _trySubmit();
                                },
                                child: const Text('Done'),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
