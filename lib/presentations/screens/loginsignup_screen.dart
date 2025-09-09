//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/providers/todo_provider.dart';
import 'package:provider/provider.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade800, Colors.tealAccent.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Form(
                  key: todoProvider.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isLogin
                          ? Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: "Helvetica",
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              "Signup",
                              style: TextStyle(
                                fontFamily: "Helvetica",
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      SizedBox(height: 20),
                      !isLogin
                          ? TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please Enter Username";
                                } else if (value.toString().length < 5) {
                                  return "Username is too small";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                todoProvider.userName = newValue!;
                              },
                              decoration: InputDecoration(
                                labelText: "Username",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: todoProvider.emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please Enter Email";
                          } else if (!(value.toString().contains('@'))) {
                            return "Invalid Email";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          todoProvider.email = newValue!;
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: todoProvider.passwordController,
                        obscureText: todoProvider.obscureText,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please Enter Password";
                          } else if (value.toString().length < 8) {
                            return "Password is too small";
                          }

                          return null;
                        },
                        onSaved: (newValue) {
                          todoProvider.password = newValue!;
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              todoProvider.visubility();
                            },
                            icon: todoProvider.obscureText
                                ? Icon(Icons.visibility_outlined)
                                : Icon(Icons.visibility_off_outlined),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      isLogin
                          ? InkWell(
                              onTap: () {
                                todoProvider.forgotPassword(context);
                              },
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: Text("Forgot Password"),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: todoProvider.isLoading
                              ? null // disable button when loading
                              : () {
                                  if (todoProvider.formValidator()) {
                                    todoProvider.savevalue();
                                    isLogin
                                        ? todoProvider.login(
                                            context,
                                            todoProvider.email,
                                            todoProvider.password,
                                          )
                                        : todoProvider.signup(
                                            context,
                                            todoProvider.email,
                                            todoProvider.password,
                                          );
                                  }
                                },
                          child: todoProvider.isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      isLogin
                                          ? "Logging in..."
                                          : "Signing up...",
                                    ),
                                  ],
                                )
                              : Text(isLogin ? "Login" : "Signup"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLogin
                              ? Text("Don't have account?")
                              : Text("Already signedup!"),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: isLogin ? Text("signup") : Text("Login"),
                          ),
                        ],
                      ),
                    ],
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
