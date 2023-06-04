//  Reason for using "fbAuth" is to avoid conflicts when
//  using "User" object provided by Firebase Auth package
//  & one I created previously.
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
//  Reason for below import is I want to also store additional
//  information against User id object.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_login_state/constants/db_constant.dart';
import 'package:user_login_state/models/custom_error.dart';

class AuthRepository {
  //  AuthRepository class required an instance of both
  //  Firebase Auth and Cloud Firestore to store user info.
  final FirebaseFirestore firebaseFirestore;
  final fb_auth.FirebaseAuth firebaseAuth;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });
  //  "firebaseAuth" instance has an "userChanges()" function method
  //  which can help to inform us about user status information as
  //  Streeam. So, below I'm creating a getter to access it much more
  //  easily. As Firebase notify us whenever user state's changes.
  Stream<fb_auth.User?> get user => firebaseAuth.userChanges();

  Future<void> signup(
      {required String name,
      required String email,
      required String password}) async {
    //  Fireabse authentication only required user email & password
    //  reason for making user name required as well is bcz it helps
    //  in storing user seperate information in Firebase Firestore
    //  which cannot be stored inside Firebase Authentication system.
    try {
      //  If following function succeed then it returns user credentials
      final fb_auth.UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      //  Only if above function succeeds then it means user is logged in
      //  & user getter I define which listen to user status changes itself.
      final signedInUser = userCredential.user!;
      //  Since, I've got the logged in user credentail
      //  Now, I will use that user object ID to create
      //  a new User object which will be stored in Firestore.
      await usersRef.doc(signedInUser.uid).set({
        'name': name,
        'email': email,
        'profileImage': 'https://picsum.photos/300',
        'point': 0,
        'rank': 'bronze',
      });
      //  With above function whenever user sign up new document
      //  is created in the user collection.
    } on fb_auth.FirebaseAuthException catch (e) {
      //  Here, I'm handling Firebase provided exception seperately as
      //  compare to the other error.
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      //  For general errors an error object still gets throw.
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  //  Below is my sign-in function.
  Future<void> signin({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on fb_auth.FirebaseAuthException catch (e) {
      //  Here, I'm handling Firebase provided exception seperately as
      //  compare to the other error.
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      //  For general errors an error object still gets throw.
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  //  In case of sign-in and sign-out the state changes is handled by Firebase
  //  automatically.
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
