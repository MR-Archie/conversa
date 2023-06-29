// ignore_for_file: unused_field

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

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

  final emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');

  void _submit() async {
    var isValid = _form.currentState!.validate();

    if (!isValid) return;

    _form.currentState!.save();

    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
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
