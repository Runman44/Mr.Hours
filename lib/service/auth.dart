import 'package:eventtracker/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, name: user.displayName) : null;
  }

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      print(user);

      await DatabaseService(uid: user.uid).updateUserData(user.displayName, user.email);
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future signOutGoogle() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class User {
  final String uid;
  final String name;

  User({this.uid, this.name});
}
