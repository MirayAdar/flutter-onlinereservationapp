import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senior_project/main.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
  ],
);

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key, this.account}) : super(key: key);
  GoogleSignInAccount account;

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GoogleSignInAccount _currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("sign in init");
    checkFromPayment();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    MyHomePage(account: _currentUser)));
      }
      print("account null");
    });

    _googleSignIn.signInSilently();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  checkFromPayment() {
    print("account");
    if (widget.account != null) {
      print("account Not Null");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  MyHomePage(account: widget.account)));
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final firestoreInstance = FirebaseFirestore.instance;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      var a =
          firestoreInstance.collection("users").doc(currentUser.uid.toString());

      a.get().then((docSnapshot) => {
            if (docSnapshot.exists)
              {}
            else
              {
                a.set({
                  "name": currentUser.displayName,
                  "email": currentUser.email,
                  "phoneNo": currentUser.phoneNumber,
                  "photoUrl": currentUser.photoURL,
                  "uid": currentUser.uid,
                })
              }
          });

      return '$user';
    }

    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text.rich(
          TextSpan(
            style: TextStyle(
              fontFamily: 'Calibri',
              fontSize: 35,
              color: const Color(0xfff5f5f5),
            ),
            children: [
              TextSpan(
                text: 'F',
              ),
              TextSpan(
                text: 'E',
                style: TextStyle(
                  color: const Color(0xffa11f1f),
                ),
              ),
              TextSpan(
                text: 'ASTER',
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg-Feaster.png"), fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SignInButton(Buttons.Google, onPressed: () {
                signInWithGoogle().then((value) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyHomePage()));
                });
              }),
              /*
              RaisedButton(
                onPressed: () async {
                  QuerySnapshot a =
                      await firestoreInstance.collection("users").get();
                  QueryDocumentSnapshot b = a.docs[0];
                  print(b.data()["age"]);
                },
                child: Text("Test Button"),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
