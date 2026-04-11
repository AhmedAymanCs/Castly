import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:castly/core/constants/app_constants.dart';
import 'package:castly/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:castly/core/models/user_model.dart';
import 'package:castly/features/profile/data/models/update_model.dart';

abstract class ProfileDataSource {
  // local
  Future<XFile?> pickImage(ImageSource source);
  // remote
  Future<UserModel> getUserData();
  Future<void> updateUserData(UpdateModel data);
  Future<void> logout();
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final FirebaseFirestore firestore;
  final SecureStorageHelper secureStorageHelper;
  final FirebaseAuth auth;
  final SupabaseClient supabaseClient;
  ProfileDataSourceImpl({
    required this.firestore,
    required this.secureStorageHelper,
    required this.auth,
    required this.supabaseClient,
  });
  // local
  @override
  Future<XFile?> pickImage(ImageSource source) async {
    return await ImagePicker().pickImage(source: source);
  }

  // remote
  @override
  Future<UserModel> getUserData() async {
    final userSession = await secureStorageHelper.getData(
      key: AppConstants.userSession,
    );
    if (userSession != null) {
      final userData = jsonDecode(userSession);
      return UserModel.fromJson(userData);
    } else {
      final response = await firestore
          .collection(AppConstants.usersCollectionName)
          .doc(auth.currentUser!.uid)
          .get();
      return UserModel.fromJson(response.data()!);
    }
  }

  @override
  Future<void> updateUserData(UpdateModel data) async {
    String? urlImage;
    if (data.image != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabaseClient.storage
          .from('profile-images')
          .upload(fileName, data.image!);
      urlImage = supabaseClient.storage
          .from('profile-images')
          .getPublicUrl(fileName);
    }

    final userSessionjson = await secureStorageHelper.getData(
      key: AppConstants.userSession,
    );
    if (userSessionjson != null) {
      final userSession = jsonDecode(userSessionjson);
      if (data.name != null) {
        userSession['name'] = data.name;
      }
      if (data.image != null) {
        userSession['image'] = urlImage;
      }
      await secureStorageHelper.deleteData(key: AppConstants.userSession);
      await secureStorageHelper.saveUserData(jsonEncode(userSession));
    }
    await firestore
        .collection(AppConstants.usersCollectionName)
        .doc(auth.currentUser!.uid)
        .update(data.toJson(imageUrl: urlImage));
  }

  @override
  Future<void> logout() async {
    await auth.signOut().then((_) {
      secureStorageHelper.deleteData(key: AppConstants.userSession);
    });
  }
}
