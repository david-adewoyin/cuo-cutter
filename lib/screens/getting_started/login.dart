import 'dart:ffi';

import 'package:connectivity/connectivity.dart';
import 'package:cuo_cutter_app/screens/getting_started/signup.dart';
import 'package:cuo_cutter_app/screens/home.dart';
import 'package:cuo_cutter_app/storage/storage.dart';
import 'package:cuo_cutter_app/theme.dart';
import 'package:cuo_cutter_app/components/skip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      backgroundColor: loaderBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              /*   SvgPicture.asset(
                "assets/images/splashy-overlay.svg",
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
              ), */
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  skipToHomeButton,
                  SizedBox(
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome Back!',
                      style: h5,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Discover the latest coupons and store deals!',
                      style: subtitle.copyWith(
                        color: Colors.grey.shade400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _LoginForm(formKey: _formKey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({
    Key key,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  TextEditingController emailController;
  TextEditingController passwdController;
  String _error = "";
  bool snackbarOpened = false;
  double _paddingOnError = 0;
  bool _buttonSubmitted = false;
  @override
  void initState() {
    emailController = TextEditingController(text: "");
    passwdController = TextEditingController(text: "");

    super.initState();
  }

  @override
  void dispose() {
    passwdController.dispose();
    emailController.dispose();

    super.dispose();
  }

  String _passwordValidator(String value) {
    if (!isLength(value, 5)) {
      return 'Password length must be greather than 5';
    }

    return null;
  }

  String _emailValidator(String value) {
    if (!isEmail(value)) {
      return "Enter a valid email address";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              // when the form is tapped again to clear the error message
              onTap: () {
                setState(() {
                  _paddingOnError = 20;
                  _error = "";
                });
              },

              maxLength: 100,
              maxLines: 1,
              controller: emailController,
              validator: _emailValidator,

              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              autofillHints: ['email', 'Email'],

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                counterText: "",
                prefixIcon: Icon(
                  Icons.email,
                  size: 18,
                ),
                labelText: "Email",
                hintText: 'Enter your email address',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              obscuringCharacter: '*',
              obscureText: true,
              maxLength: 30,
              controller: passwdController,
              validator: _passwordValidator,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              toolbarOptions: ToolbarOptions(
                cut: false,
                paste: false,
                copy: false,
                selectAll: false,
              ),
              onTap: () {
                setState(() {
                  _paddingOnError = 20;
                  _error = "";
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  size: 18,
                ),
                labelText: "Password",
                counterText: "",
                hintText: 'Enter your password',
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                child: Text(
                  "Forgot password ?",
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpPage();
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                child: Text(
                  "Sign up for CuCutter",
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.center,
            child: ElevatedButton(
              autofocus: true,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 10),
              ),
              onPressed: () async {
                if (_buttonSubmitted) {
                  return Future.value();
                }
                _buttonSubmitted = true;
                var connectivityRes =
                    await (Connectivity().checkConnectivity());
                switch (connectivityRes) {
                  case ConnectivityResult.none:
                    if (!snackbarOpened) {
                      ScaffoldMessenger.maybeOf(context)
                          .showSnackBar(SnackBar(
                              content: Text("Check your internet connection")))
                          .closed
                          .then((value) {
                        _buttonSubmitted = true;
                      });
                    }
                    break;
                  default:
                    if (widget._formKey.currentState.validate()) {
                      var email = emailController.value.text;
                      var password = passwdController.value.text;

                      bool validLogin = false;
                      try {
                        validLogin = await Storage.instance
                            .loginUser(email: email, password: password);
                      } catch (e) {
                        setState(() {
                          _error = e;
                          _buttonSubmitted = false;
                        });
                        return Future.error("error");
                      }

                      if (validLogin) {
                        return Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) {
                              return Home();
                            },
                          ),
                          (route) {
                            return false;
                          },
                        );
                      }
                    }
                    _buttonSubmitted = false;

                    break;
                }
              },
              child: _buttonSubmitted
                  ? CircularProgressIndicator.adaptive()
                  : Text(
                      "Login",
                      style: TextStyle(color: Colors.black),
                    ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          AnimatedPadding(
            duration: Duration(milliseconds: 20),
            padding:
                EdgeInsets.symmetric(horizontal: 40, vertical: _paddingOnError),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                _error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0.25,
                  color: onErrorColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
