import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_auth/MainPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String info = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  void doLogout() {
    signOut().then((value) {
      setState(() {
        info = "Log outed";
      });
    }).catchError((e) => print(e.toString()));
  }

  void doLogin() {
    _signIn().then((User user) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      });
    }).catchError((e) => print(e.toString()));
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<User> _signIn() async {
    GoogleSignInAccount gsia = await GoogleSignIn().signIn();
    GoogleSignInAuthentication gSA = await gsia.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );

    User user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Login With Google"),
              onPressed: doLogin,
            ),
            Text(info),
            RaisedButton(
              child: Text("Logout"),
              onPressed: doLogout,
            )
          ],
        ),
      ),
    );
  }
}
