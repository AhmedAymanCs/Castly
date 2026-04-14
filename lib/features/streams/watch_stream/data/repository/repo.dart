import 'package:castly/core/models/stream_model.dart';
import 'package:castly/core/utils/typedef.dart';
import 'package:castly/features/streams/watch_stream/data/data_source/data_source.dart';
import 'package:dartz/dartz.dart';

abstract class WatchStreamRepository {
  Stream<StreamModel?> watchStream(String streamId);
  ServerResponse<Unit> updateViewerCount(String streamId, bool increment);
}

class WatchStreamRepositoryImpl implements WatchStreamRepository {
  final WatchStreamDataSource _dataSource;

  WatchStreamRepositoryImpl(this._dataSource);

  @override
  Stream<StreamModel?> watchStream(String streamId) {
    return _dataSource.watchStream(streamId);
  }

  @override
  ServerResponse<Unit> updateViewerCount(
    String streamId,
    bool increment,
  ) async {
    try {
      await _dataSource.updateViewerCount(streamId, increment);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
