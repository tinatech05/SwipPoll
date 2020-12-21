import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vote/Service/dbservice.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Db db = new Db();
  int credit = 10;
  String _name, _email, _password, _id;
List<String> votedfor=[ ];
  checkAuthincation() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  navigateToSignInScreen() {
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthincation();
  }

  signup() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      try {
        AuthResult user = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        final FirebaseUser users = user.user;
        _id = users.uid;

        if (user != null) {
          UserUpdateInfo userUpdateInfo = UserUpdateInfo();
          userUpdateInfo.displayName = _name;
          user.user.updateProfile(userUpdateInfo);
        }
        setState(() {
          _id = _id;
          _name = _name;
          _email = _email;
        });
        db.addUser(context,
            id: _id, username: _name, mail: _email, credit: credit,votedfor:votedfor);
      } catch (e) {
        //  showError(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text('Sign Up'),
//      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 40),
        child: Center(
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 20,
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150),
                )),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
                      child: Image(
                        image: AssetImage('asset/index.png'),
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
//                        Name box
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                // ignore: missing_return
                                validator: (input) {
                                  if (input.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Warning"),
                                          content: Text("'Provide an name'"),
                                        );
                                      },
                                    );
                                  }
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                    ),
                                    filled: true,
                                    fillColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'Name'),
                                onSaved: (input) => _name = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
//                      email
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                // ignore: missing_return
                                validator: (input) {
                                  if (input.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Warning"),
                                          content: Text("'Provide an email'"),
                                        );
                                      },
                                    );
                                  }
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    filled: true,
                                    fillColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'E-mail'),
                                onSaved: (input) => _email = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                // ignore: missing_return
                                validator: (input) {
                                  if (input.length < 6) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Warning"),
                                          content: Text(
                                              'Password must be atleast 6 char long'),
                                        );
                                      },
                                    );
                                  }
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    filled: true,
                                    fillColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'Passwod'),
                                onSaved: (input) => _password = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
//                    button
                            RaisedButton(
                                padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(30),
                                ),
                                onPressed: signup,
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
//                      redirect to signup page
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            GestureDetector(
                              onTap: navigateToSignInScreen,
                              child: Text(
                                'Already have an account? click here',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
