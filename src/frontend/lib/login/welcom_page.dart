import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/user_repository.dart';
import '../bloc/authentication_bloc.dart';
import '../login/bloc/login_bloc.dart';
import './login.dart';
import './signup.dart';
import './onboarding_page.dart';

class WelcomePage extends StatefulWidget {
  final UserRepository userRepository;

  const WelcomePage({required this.userRepository, super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Keep track of the current view: welcome, login, or signup
  String currentView = "onboarding";

  void toWelcome() {
    setState(() {
      currentView = "welcome";
    });
  }

  @override
  Widget build(BuildContext context) { // TODO TASK 2: Change colors to theme colors for consistency
    return Scaffold(
      body: currentView == 'onboarding'
          ? OnboardingPagePresenter(
              pages: [
                OnboardingPageModel(
                  title: 'Fast, Fluid and Secure',
                  description:
                      'Enjoy the best of the world in the palm of your hands.',
                  imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
                  bgColor: Colors.indigo,
                ),
                OnboardingPageModel(
                  title: 'Connect with your friends.',
                  description: 'Connect with your friends, anytime, anywhere.',
                  imageUrl:
                      'https://i.ibb.co/LvmZypG/storefront-illustration-2.png',
                  bgColor: const Color(0xff1eb090),
                ),
                OnboardingPageModel(
                  title: 'Bookmark your favourites',
                  description:
                      'Bookmark your favourite activity to travel smoothly.',
                  imageUrl: 'https://i.ibb.co/420D7VP/building.png',
                  bgColor: const Color(0xfffeae4f),
                ),
                OnboardingPageModel(
                  title: 'Follow your Plan',
                  description: 'Follow our calendar and enjoy the journey.',
                  imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
                  bgColor: Colors.purple,
                ),
              ],
              onSkip: toWelcome,
              onFinish: toWelcome,
            )
          : currentView == "welcome"
              ? _buildWelcomeView()
              : currentView == "login"
                  ? _buildLoginView()
                  : _buildSignupView(),
    );
  }

  // Welcome view
  Widget _buildWelcomeView() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: const Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
              const SizedBox(height: 20),
              FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: Text(
                    "No more procrastination in planning your activities!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  )),
            ],
          ),
          FadeInUp( // TODO TASK 4: change image to logo
              duration: const Duration(milliseconds: 1400),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://github.com/afgprogrammer/Flutter-Login-Signup-page/blob/master/assets/Illustration.png?raw=trueg'),
                  ),
                ),
              )),
          Column(
            children: <Widget>[
              FadeInUp(
                  duration: const Duration(milliseconds: 1500),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      setState(() {
                        currentView = "login"; // Switch to login view
                      });
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  )),
              const SizedBox(height: 20),
              FadeInUp(
                  duration: const Duration(milliseconds: 1600),
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
                      onPressed: () {
                        setState(() {
                          currentView = "signup"; // Switch to signup view
                        });
                      },
                      color: Colors.yellow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  // Login view
  Widget _buildLoginView() {    // TODO TASK 1: switch to sign up view
    return BlocProvider(
      create: (context) => LoginBloc(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        userRepository: widget.userRepository,
      ),
      child: LoginPage(
        onBack: () {
          setState(() {
            currentView = "welcome"; // Go back to welcome view
          });
        },
      ),
    );
  }

  // Signup view
  Widget _buildSignupView() {   // TODO TASK 1: switch to log in view
    return SignUpPage(onBack: () {
      setState(() {
        currentView = "welcome"; // Go back to welcome view
      });
    }, navigateToLogin: () {
      setState(() {
        currentView = "login"; // Switch to login view
      });
    });
  }
}
