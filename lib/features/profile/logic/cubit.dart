import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:castly/features/profile/data/models/update_model.dart';
import 'package:castly/features/profile/data/repository/repo.dart';
import 'package:castly/features/profile/logic/state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  ProfileCubit(this._repository) : super(const ProfileState());

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await _repository.pickImage(source);
    pickedImage.fold(
      (error) =>
          emit(state.copyWith(status: ProfileStatus.error, error: error)),
      (file) => emit(state.copyWith(file: file)),
    );
  }

  Future<void> getUserData() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final response = await _repository.getUserData();
    response.fold(
      (l) => emit(state.copyWith(status: ProfileStatus.error, error: l)),
      (r) => emit(state.copyWith(user: r, status: ProfileStatus.success)),
    );
  }

  Future<void> updateUserData(UpdateModel data) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final response = await _repository.updateUserData(data);
    response.fold(
      (l) => emit(state.copyWith(status: ProfileStatus.error, error: l)),
      (r) async {
        await getUserData();
        emit(state.copyWith(status: ProfileStatus.updated));
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final response = await _repository.logout();
    response.fold(
      (l) => emit(state.copyWith(status: ProfileStatus.error, error: l)),
      (r) => emit(state.copyWith(status: ProfileStatus.logout)),
    );
  }
}
