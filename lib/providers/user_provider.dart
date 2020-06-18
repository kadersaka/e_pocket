import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:epocket/controllers/dbusersservices.dart';
enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  FirebaseUser _user;
  FsUsersServices _fsUsersServices = FsUsersServices();

  Status _status = Status.Uninitialized;
  Status get status =>_status;
  FirebaseUser get user => _user;

  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password) async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }
    catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e);
      return false;
    }
  }


  Future<bool> signUp(String name, String email, String password) async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((authuser){
      //  FirebaseUser firebaseUser = authuser.user;
        Map<String, dynamic> values ={
          'name': name,
          "email": email,
          "userId": authuser.user.uid,
        };
        _fsUsersServices.createUser(values);
      });
      return true;
    }
    catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e);
      return false;
    }
  }

  Future signOut()  async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

    Future<void> _onStateChanged(FirebaseUser user)async{
    if(user == null){
      _status = Status.Unauthenticated;
    }else{
      _user = user;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}