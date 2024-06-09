import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_movie/extensions/extension_date.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  Future<UserCredential> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> register(String email, password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'email': email,
        'avatar':
            'https://img.redbull.com/images/c_crop,x_545,y_0,h_2194,w_1755/c_fill,w_450,h_600/q_auto:low,f_auto/redbullcom/2017/08/15/65b3282e-0c0d-4a39-b077-84820e75ab39/cristiano-ronaldo-gol-sevinci',
        'date_join': ExtensionDate.formatDateTime(DateTime.now()),
        'name': email.split('@')[0],
        'password': password
      });
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
