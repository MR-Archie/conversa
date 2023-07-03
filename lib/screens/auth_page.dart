// ignore_for_file: unused_field, unused_local_variable

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversa/widgets/user_image_picker.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _firebase = FirebaseAuth.instance;

  final _form = GlobalKey<FormState>();

  bool _isLogin = true;
  String _enteredEmail = "";
  String _enteredPassword = "";
  String _enteredUserName = "";
  File? _selectedImage;
  bool isAuthenticating = false;

  final emailRegex = RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$'); //user email validation

  void _submit() async {
    var isValid = _form.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please make sure that the Credentials are valid and an image is selected",
          ),
        ),
      );
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        isAuthenticating = true;
      });

      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child("${userCredentials.user!.uid}.jpg");
        await storageRef.putFile(_selectedImage!);

        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection("user")
            .doc(userCredentials.user!.uid)
            .set({
          "user_name": _enteredUserName,
          "email": _enteredEmail,
          "image_url": imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ?? 'Authentication error',
          ),
        ),
      );
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/chat_icon.png", height: 150),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Conversa",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(9.5),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (!_isLogin)
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              _selectedImage = pickedImage;
                            },
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Enter email",
                          ),
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: (value) => (value == null ||
                                  value.trim().isEmpty ||
                                  !emailRegex.hasMatch(value))
                              ? "Invalid Email!! Please enter a valid email address "
                              : null,
                          onSaved: (newValue) => _enteredEmail = newValue!,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (!_isLogin)
                          TextFormField(
                            enableSuggestions: false,
                            decoration: const InputDecoration(
                                labelText: "Enter username"),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  (value[0].codeUnitAt(0) >= 97 &&
                                      value[0].codeUnitAt(0) <= 122) ||
                                  value.length < 4) {
                                return 'Please enter a valid username';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (newValue) => _enteredUserName = newValue!,
                          ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Enter Password",
                          ),
                          obscureText: true,
                          validator: (value) => (value == null ||
                                  value.trim().length < 8)
                              ? "Please enter a password of atleast 8 characters"
                              : null,
                          onSaved: (newValue) => _enteredPassword = newValue!,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (isAuthenticating) const CircularProgressIndicator(),
                        if (!isAuthenticating)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            child: Text(
                              _isLogin ? "Login" : "SignUp",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (!isAuthenticating)
                          TextButton(
                            onPressed: () => setState(() {
                              _isLogin = !_isLogin;
                            }),
                            child: Text(
                              _isLogin
                                  ? "Don't have an account ? Create account"
                                  : "Already have an account",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
