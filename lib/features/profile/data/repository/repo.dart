import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:castly/core/models/user_model.dart';
import 'package:castly/core/utils/typedef.dart';
import 'package:castly/features/profile/data/data_source/data_source.dart';
import 'package:castly/features/profile/data/models/update_model.dart';

abstract class ProfileRepository {
  //local
  ServerResponse<XFile?> pickImage(ImageSource source);
  //remote
  ServerResponse<UserModel> getUserData();
  ServerResponse<Unit> updateUserData(UpdateModel data);
  ServerResponse<Unit> logout();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;
  ProfileRepositoryImpl(this._dataSource);

  //local
  @override
  ServerResponse<XFile?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _dataSource.pickImage(source);
      return Right(pickedImage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // remote
  @override
  ServerResponse<UserModel> getUserData() async {
    try {
      final response = await _dataSource.getUserData();
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<Unit> updateUserData(UpdateModel data) async {
    try {
      await _dataSource.updateUserData(data);
      return Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<Unit> logout() async {
    try {
      await _dataSource.logout();
      return Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
