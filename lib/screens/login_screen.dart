import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/tab_widget.dart';
import '../screens/signup_screen.dart';
import '../utils/firebase_user_auth.dart';
import '../utils/form_validation.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/logIn';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(
            user: user,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  @override
  void initState() {
    _initializeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 80, bottom: 19),
                    child: SvgPicture.asset(
                      'assets/images/login.svg',
                      width: 100.0,
                      height: 150.0,
                    ),
                  ),
                  Text("The Best Mobile Diary Experience")
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 35, left: 5, right: 5, bottom: 10),
                height: 305,
                child: FutureBuilder(
                  future: _initializeFirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: _emailTextController,
                                        focusNode: _focusEmail,
                                        validator: (value) =>
                                            Validator.validateEmail(
                                          email: value.toString(),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Email",
                                          prefixIcon: const Icon(
                                            Icons.alternate_email,
                                            size: 20,
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
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
                                          prefixIcon: const Icon(
                                            Icons.vpn_key_sharp,
                                            size: 20,
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24.0),
                                      _isProcessing
                                          ? const CircularProgressIndicator()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Log In',
                                                    ),
                                                    onPressed: () async {
                                                      _focusEmail.unfocus();
                                                      _focusPassword.unfocus();

                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          _isProcessing = true;
                                                        });

                                                        User? user = await FireBaseAuth
                                                            .UserLogIn(
                                                                email:
                                                                    _emailTextController
                                                                        .text,
                                                                password:
                                                                    _passwordTextController
                                                                        .text,
                                                                context:
                                                                    context);

                                                        setState(() {
                                                          _isProcessing = false;
                                                        });

                                                        if (user != null) {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HomePage(
                                                                      user:
                                                                          user),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 24.0),
                                                Expanded(
                                                  child: TextButton(
                                                    child: Text(
                                                      'Sign up',
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              SignUpPage
                                                                  .routeName);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
