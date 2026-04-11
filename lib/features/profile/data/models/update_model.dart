import 'dart:io';

class UpdateModel {
  final String? name;
  final File? image;
  const UpdateModel({this.name, this.image});

  Map<String, dynamic> toJson({String? imageUrl}) {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (imageUrl != null) data['image'] = imageUrl;
    return data;
  }
}
