import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epocket/controllers/users.dart';
import 'package:epocket/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:epocket/constants/loading.dart';
import 'package:epocket/screens/homepage.dart';
import 'package:epocket/providers/user_provider.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool loading = false;
  bool isLoggedIn = false;

  SharedPreferences sharedPreferences;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // isSignedIn();
  }

  /**
   * Google Auth
   */
  Future<FirebaseUser> handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser firebaseUser = authResult.user;

    print("signed in " + firebaseUser.displayName);

    if (firebaseUser != null){
      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();

      assert(firebaseUser.uid == currentUser.uid);

      UserServices userServices = new UserServices(firebaseUser.uid);
      final result = await userServices.findUserData();
      if(result != null){
        Fluttertoast.showToast(msg: "Connexion réussie");
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
      else{
        UserModel userModel = new UserModel(firebaseUser.email, firebaseUser.photoUrl, firebaseUser.phoneNumber, firebaseUser.displayName, null, null, null);
        userServices.updateUserData(userModel);
        Fluttertoast.showToast(msg: "Connexion réussie");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
      Fluttertoast.showToast(msg: "Erreur de connexion", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP, backgroundColor: Colors.white, textColor: Colors.red);
    }else{
      Fluttertoast.showToast(msg: "Erreur de connexion", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP, backgroundColor: Colors.white, textColor: Colors.red);
    }
  }

  ///Check auth state
  void isSignedIn() async {
    setState(() {
      loading = true;
    });
    await _firebaseAuth.currentUser().then((user){
      if(user != null){
        setState(() {
          isLoggedIn = true;
        });
      }
    });

    //2eme option
    isLoggedIn = await _googleSignIn.isSignedIn();

    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }

    setState(() {
      loading =false;
    });
  }
  final GlobalKey _globalKey = GlobalKey<ScaffoldState>();


  ///main widget build

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
   //   backgroundColor: Colors.yellow,
//      appBar: AppBar(
//        elevation: 1.0,
//        leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back,
//          ),
//          onPressed: ()=>Navigator.pop(context),
//        ),
//
//        actions: <Widget>[
//        ],
//      ),

      key: _globalKey,
      body: user.status == Status.Authenticating ? Loading() : SafeArea(
        child: Center(
          child: Column(

            children: <Widget>[
            //Image.asset('assets/images/w3.jpeg', fit: BoxFit.fill, width: double.infinity, height: double.infinity,),
//            Container(
//              color: Colors.black12,
//              width: double.infinity,
//          //    height: double.infinity,
//            ),
//          Container(
//              alignment: Alignment.topCenter,
//            child: Padding(
//              padding: const EdgeInsets.only(bottom:30.0, top: 30),
//              child: Image.asset("assets/images/back.png", width: 200, height: 200,),
//            ),
//          ),

            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top:208.0),
                child: Text("CONNECTEZ-VOUS", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500,),),
              ),
            ),
              Padding(
               padding: const EdgeInsets.only(top:30),
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 14.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                                elevation: 1.0,
                                child: MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  onPressed: (){
                                    handleSignIn();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
                                      SizedBox(width: 10,),
                                      Text('Connexion avec Google',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300,)
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                  visible: loading??true,
                  child:Center(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.white.withOpacity(0.9),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  ),
              ),

            ],
          ),
        ),
      ),
    );
  }


}

