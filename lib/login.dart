import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/allTodo.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<Login> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoading = true;
  bool isLoggedIn = false;
  var currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      isLoading = true;
    });
    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AllTodo(
      )));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    var firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;
    if (firebaseUser != null) {
     
      
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AllTodo()));
    }
    else{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body: isLoading ? Center(child: CircularProgressIndicator(),) : Stack(children: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: handleSignIn,
              child: Text(
                "Sign In With Google",
                style: TextStyle(fontSize: 16),
              ),
             
            ),
          ),
          Positioned(
            child: isLoading ? Center(child: const CircularProgressIndicator()) : Container()
          )
        ]));
  }
}