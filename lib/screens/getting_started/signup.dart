import 'package:connectivity/connectivity.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: loaderBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: BackButton(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Create an Account',
                      textAlign: TextAlign.center,
                      style: h5,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Discover exciting deals and many more',
                      textAlign: TextAlign.center,
                      style: subtitle.copyWith(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SignUpForm(formKey: _formKey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key key,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController emailController;
  TextEditingController passwdController;

  String _error = "";
  double _paddingOnError = 0;
  bool snackbarOpened = false;

  FocusNode emailFocus;
  FocusNode passwdFocus;
  FocusNode submitFocus;

  @override
  void initState() {
    emailController = TextEditingController(text: "");
    passwdController = TextEditingController(text: "");

    submitFocus = FocusNode();
    emailFocus = FocusNode();
    passwdFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    passwdController.dispose();
    emailController.dispose();

    emailFocus.dispose();
    passwdFocus.dispose();
    submitFocus.dispose();
    super.dispose();
  }

  String _passwordValidator(String value) {
    if (!isLength(value, 5)) {
      return 'Password length must be greather than 5\nPrefer choosing phrases over a single word';
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
              maxLength: 100,
              maxLines: 1,
              controller: emailController,
              validator: _emailValidator,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              focusNode: emailFocus,
              onFieldSubmitted: (value) {
                Focus.of(context).requestFocus(passwdFocus);
              },
              autofillHints: ["email", "Email"],
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
              autofillHints: ['pasword', "Password"],
              focusNode: passwdFocus,
              onFieldSubmitted: (value) {
                Focus.of(context).requestFocus(submitFocus);
              },
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
                hintText: 'enter a password',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          AnimatedPadding(
            duration: Duration(milliseconds: 20),
            padding:
                EdgeInsets.symmetric(horizontal: 40, vertical: _paddingOnError),
            child: Text(
              _error,
              textAlign: TextAlign.center,
              style: onErrorTextStyle,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.center,
            child: ElevatedButton(
              focusNode: submitFocus,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 10),
              ),
              onPressed: () async {
                var connectivityRes =
                    await (Connectivity().checkConnectivity());

                switch (connectivityRes) {
                  case ConnectivityResult.none:
                    showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.only(top: 100),
                          backgroundColor: Colors.grey.shade500,
                          title: Text(
                            "check your internet connection",
                            style: subtitle,
                          ),
                        );
                      },
                    );
                    break;
                  default:
                    if (widget._formKey.currentState.validate()) {
                      var email = emailController.value.text;
                      var passwd = passwdController.value.text;

                      setState(() {
                        _paddingOnError = 20;

                        _error = "Email already exists";
                      });
                    }
                    break;
                }
              },
              child: Text(
                "Signup",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
