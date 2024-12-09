import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  final VoidCallback onBack;

  const LoginPage({required this.onBack, Key? key}) : super(key: key);
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void _onLoginButtonPressed() {
      context.read<LoginBloc>().add(LoginButtonPressed(
            username: _usernameController.text,
            password: _passwordController.text,
          ));
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        print('Login state: $state');
        if (state is LoginInitial) {
          print('Authenticated at login page');
        } else if (state is LoginFailure) {
          const snackBar = const SnackBar(
            /// need to set following properties for best effect of awesome_snackbar_content
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'On Snap!',
              message: 'Please check your username and password and try again!',

              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: widget.onBack,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeInUp(
                                duration: const Duration(milliseconds: 1200),
                                child: Text(
                                  "Login to your account",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[700]),
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1200),
                                  child: makeInput(label: "Username")),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1300),
                                  child: makeInput(
                                      label: "Password", obscureText: true)),
                            ],
                          ),
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Container(
                                padding: const EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: const Border(
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      left: BorderSide(color: Colors.black),
                                      right: BorderSide(color: Colors.black),
                                    )),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 60,
                                  onPressed: state is! LoginLoading
                                      ? _onLoginButtonPressed
                                      : null,
                                  color: Colors.greenAccent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            )),
                        if (state is LoginLoading)
                          const CircularProgressIndicator(),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1500),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Don't have an account?"),
                                Text(   // TODO TASK 1: add link to sign up view
                                  "Sign up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://github.com/afgprogrammer/Flutter-Login-Signup-page/blob/master/assets/background.png?raw=true'),
                                fit: BoxFit.cover)),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          controller: obscureText ? _passwordController : _usernameController,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
