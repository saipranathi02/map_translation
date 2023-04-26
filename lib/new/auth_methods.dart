import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authmethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //signup
  Future<String> signup({
    required String uname,
    required String email,
    required String password,
  }) async {
    String x = "";
    try {
      if (uname.isNotEmpty || password.isNotEmpty || email.isNotEmpty) {
        //register user with email and password
        UserCredential res = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //store user data in firebase database
        await _firestore.collection('users').doc(res.user!.uid).set({
          'uid': res.user!.uid,
          'username': uname,
          'email': email,
          'password': password,
        });
        x = "success";
      }
    } catch (e) {
      x = e.toString();
    }
    return x;
  }

  //login
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String x = "";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        x = "success";
      } else {
        x = "please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        x = "user does not exist";
      } else if (e.code == 'wrong-password') {
        x = "wrong password";
      }
    } catch (e) {
      x = e.toString();
    }
    return x;
  }

  Future<String> signout() async {
    String x = "";
    try {
      await _auth.signOut();
      x = "success";
    } catch (e) {
      x = e.toString();
    }
    return x;
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> getUsername() async {
    String res = "";
    // Getting current user
    User? currentUser = _auth.currentUser;
    // Getting the username
    try {
      var value =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      var username = await value.data()!["username"];
      // print(username);
      return username;
    } catch (e) {}
    return res;
  }
}