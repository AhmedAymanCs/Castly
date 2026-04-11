import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:castly/core/models/user_model.dart';

enum ProfileStatus { initial, loading, success, error, updated, logout }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserModel user;
  final XFile? file;
  final String error;
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user = const UserModel(),
    this.file,
    this.error = '',
  });
  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    XFile? file,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      file: file ?? this.file,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, file, error];
}
