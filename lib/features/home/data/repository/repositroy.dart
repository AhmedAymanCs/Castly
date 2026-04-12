import 'package:castly/features/home/data/data_source/data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:castly/core/utils/typedef.dart';
import 'package:castly/core/models/stream_model.dart';

abstract class HomeRepository {
  ServerResponse<Unit> createStream(StreamModel stream);
  ServerResponse<List<StreamModel>> getCurrentStreams();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _homeDataSource;

  HomeRepositoryImpl(this._homeDataSource);

  @override
  ServerResponse<Unit> createStream(StreamModel stream) async {
    try {
      await _homeDataSource.createStream(stream);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<List<StreamModel>> getCurrentStreams() async {
    try {
      final streams = await _homeDataSource.getCurrentStreams();
      return Right(streams);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
