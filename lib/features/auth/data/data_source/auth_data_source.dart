import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:castly/core/constants/app_constants.dart';
import 'package:castly/features/auth/data/models/register_prams_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> login({
    required String email,
    required String password,
  });
  Future<UserCredential> register(RegisterParamsModel params);
  Future<void> sendPasswordResetEmail({required String email});
  Future<UserCredential> signInWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);
  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> register(RegisterParamsModel params) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(credential.user!.uid)
        .set(params.toMap());
    return credential;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    final doc = await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userCredential.user!.uid)
        .get();

    if (!doc.exists) {
      await _firestore
          .collection(AppConstants.usersCollectionName)
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'email': userCredential.user!.email,
            'name': userCredential.user!.displayName,
            'avatar': userCredential.user!.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          });
    }

    return userCredential;
  }
}
