import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moody/UI/auth/signup_screen.dart';
import 'package:moody/Widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  bool _obscureText = true;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _obscureText = true;
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController
        .dispose(); // means jab ye screen nai rhegi aap inko memory se dispose krdo
  }

  // bool _obscureText = true;
  void _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              false, // remove the back going arrow, since it is the starting screen
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          helperText: "Enter email e.g. shaurya45@gmail.com",
                          prefixIcon: Icon(Icons.mail),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Email";
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          helperText: "Enter valid password",
                          prefixIcon: Icon(Icons.lock),
                          // suffixIcon: Icon(   Icons.visibility : Icons.visibility_off )
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          }
                          return null;
                        },
                      )
                    ],
                  )),
              const SizedBox(height: 50),
              RoundButton(
                title: "Login",
                onTap: () {
                  if (_formKey.currentState!.validate()) {}
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account yet ?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text("Sign Up"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// suffixIcon: InkWell(
// onTap: _togglePass,
// child: Icon(
// Icons.visibility,
// ),
// ),
