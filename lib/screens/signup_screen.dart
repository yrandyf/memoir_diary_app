import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/login_screen.dart';
import '../widgets/tab_widget.dart';
import '../services/firebase_user_auth.dart';
import '../utils/form_validation.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signUp';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 80, bottom: 19),
                  child: SvgPicture.asset(
                    'assets/images/signup.svg',
                    width: 100.0,
                    height: 150.0,
                  ),
                ),
                const Text(
                  "'A moment lasts all of a second, memories lives on forever.'",
                  style: TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Card(
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Form(
                            key: _registerFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Sign Up',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  controller: _nameTextController,
                                  focusNode: _focusName,
                                  validator: (value) => Validator.validateName(
                                    name: value.toString(),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: _emailTextController,
                                  focusNode: _focusEmail,
                                  validator: (value) => Validator.validateEmail(
                                    email: value.toString(),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: _passwordTextController,
                                  focusNode: _focusPassword,
                                  obscureText: true,
                                  validator: (value) =>
                                      Validator.validatePassword(
                                    password: value.toString(),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32.0),
                                _isProcessing
                                    ? CircularProgressIndicator()
                                    : Row(
                                        children: [
                                          OutlinedButton(
                                            child: Text(
                                              'Sign up',
                                            ),
                                            onPressed: () async {
                                              // setState(
                                              //   () {
                                              //     _isProcessing = true;
                                              //   },
                                              // );

                                              if (_registerFormKey.currentState!
                                                  .validate()) {
                                                User? user = await FireBaseAuth
                                                    .signUpUser(
                                                  name:
                                                      _nameTextController.text,
                                                  email:
                                                      _emailTextController.text,
                                                  password:
                                                      _passwordTextController
                                                          .text,
                                                );

                                                setState(() {
                                                  _isProcessing = false;
                                                });

                                                if (user != null) {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(user: user),
                                                    ),
                                                    ModalRoute.withName('/'),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Already Have an Account?",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      LoginPage.routeName);
                                            },
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
