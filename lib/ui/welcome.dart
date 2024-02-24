import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:temansehat_app/styles/button.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/styles/textfield.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/utils/preferences.dart';
import 'package:temansehat_app/utils/uri.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/text_logo2.png", height: 123, width: 246),
            Image.asset("assets/logo.png", width: 278, height: 278),
            const SizedBox(height: 10),
            const Text(
              'Bersama-sama menghadapi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'tantangan yang sama',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            OutlinedButton(
              style: buttonPrimary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text('Login', style: TextStyle(color: bluePrimary)),
            ),
            const SizedBox(height: 2),
            ElevatedButton(
              style: buttonSecondary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: Text(
                'Don’t have an account? Sign up',
                style: TextStyle(color: bgColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  String _errorMessage = '';

  Future<void> loginUser() async {
    final String apiUrl = '$backendUri/api/users/login';

    final Map<String, dynamic> payload = {
      'username': _usernameController.text,
      'password': _passwordController.text,
      'remember': _rememberMe,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        handleSuccessResponse(response);
      } else {
        handleErrorResponse(response);
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        _errorMessage = 'Failed to login';
      });
    }
  }

  void handleSuccessResponse(http.Response response) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
    Map<String, dynamic> responseMap = jsonDecode(response.body);
    String userId = responseMap['user_id'];
    String accessToken = responseMap['access_token'];
    print(accessToken);
    await saveUserIdLocally(userId);
    await saveTokenLocally(accessToken);
  }

  void handleErrorResponse(http.Response response) {
    setState(() {
      if (response.statusCode == HttpStatus.unauthorized) {
        _errorMessage =
            'Sorry, the username or password you’ve entered was incorrect. Please check and try again.';
      } else if (response.statusCode == HttpStatus.notFound) {
        _errorMessage = 'Invalid username';
      } else {
        _errorMessage = 'Failed to login: ${response.statusCode}';
           }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bluePrimary,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Login',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: bluePrimary,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.all(35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome back!',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'To continue enjoying TemanSehat services, please login with your personal info.',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: usernameForm,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: passwordForm,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: bluePrimary,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(color: bluePrimary),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Add forgot password logic here
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(fontSize: 12, color: bluePrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: OutlinedButton(
                        style: buttonPrimary,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await loginUser();
                          } else {
                            setState(() {
                              _errorMessage = '';
                            });
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: bluePrimary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage.isNotEmpty)
                      Center(
                        child: Text(_errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 13.0)),
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final String _errorMessage = '';

  Future<void> createUser() async {
    final String apiUrl = backendUri + '/api/users';

    final Map<String, dynamic> payload = {
      'username': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      print('User created successfully');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ),
      );
    } else {
      print('Error creating user: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bluePrimary,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Register',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: bluePrimary,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.all(35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome!',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Join TemanSehat to get freedom for your mental health',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: usernameForm,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: emailForm,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: passwordForm,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: confirmPassForm,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: OutlinedButton(
                        style: buttonPrimary,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (createUser() == true) {}
                            ;
                          }
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(color: bluePrimary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage.isNotEmpty)
                      Center(
                        child: Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 13.0),
                        ),
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
