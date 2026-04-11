import 'package:castly/features/home/data/model/stream_model.dart';

abstract class HomeDataSource {
  Future<StreamModel> getCurrentStreams();
}

class HomeDataSourceImpl extends HomeDataSource {
  @override
  Future<StreamModel> getCurrentStreams() {
    // TODO: implement getCurrentStreams
    throw UnimplementedError();
  }
}
