import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../utils/SharedPrefrenceConstant.dart';
import '../Model/User.dart';
class Authentication{

  final databaseReference = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    FirebaseUser user;
    final AuthResult result = await _auth.signInWithCredential(credential).then((value){
      user=value.user;
    });

    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);




    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    User userModel=new User(user.uid, user.email, user.displayName, user.photoUrl,false);
    final snapShot = await Firestore.instance
        .collection('Users')
        .document(user.uid)
        .get();

    if (snapShot == null || !snapShot.exists) {
      createRecord(userModel);
      prefs.setString(SharedPrefrenceConstant.userName,userModel.name);
      prefs.setString(SharedPrefrenceConstant.userEmail, userModel.email);
      prefs.setString(SharedPrefrenceConstant.userPhoto,userModel.userPhoto);
      prefs.setString(SharedPrefrenceConstant.userId,userModel.uid);
      prefs.setBool(SharedPrefrenceConstant.isAdmin,false);

    }
    else{
      var document = await Firestore.instance.collection("Users").document(user.uid).get();


      prefs.setString(SharedPrefrenceConstant.userName,document.data[SharedPrefrenceConstant.userName]);
      prefs.setString(SharedPrefrenceConstant.userEmail, document.data[SharedPrefrenceConstant.userEmail]);
      prefs.setString(SharedPrefrenceConstant.userPhoto, document.data[SharedPrefrenceConstant.userPhoto]);
      prefs.setString(SharedPrefrenceConstant.userId,document.data[SharedPrefrenceConstant.userId]);
      prefs.setBool(SharedPrefrenceConstant.isAdmin,document.data[SharedPrefrenceConstant.isAdmin]);


    }


    prefs.setBool(SharedPrefrenceConstant.isCureentUserLogin, true);



    return 'signInWithGoogle succeeded: $user';
  }



  void signOutGoogle() async{
    await googleSignIn.signOut();

    print("User Sign Out");
  }


  void createRecord(User currentUser) async {
    await databaseReference.collection("Users")
        .document(currentUser.uid)
        .setData({
      SharedPrefrenceConstant.userId: currentUser.uid,
      SharedPrefrenceConstant.userName: currentUser.name,
      SharedPrefrenceConstant.userPhoto: currentUser.userPhoto,
      SharedPrefrenceConstant.userEmail: currentUser.email,
      SharedPrefrenceConstant.isAdmin:false

    });
  }
}
