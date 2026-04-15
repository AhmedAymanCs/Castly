import 'package:castly/core/utils/typedef.dart';
import 'package:castly/features/streams/live_stream/data/data_source/data_source.dart';
import 'package:dartz/dartz.dart';

abstract class LiveStreamRepository {
  ServerResponse<Unit> endStream(String streamId);
  ServerResponse<Unit> updateThumbnail(String streamId, String filePath);
}

class LiveStreamRepositoryImpl implements LiveStreamRepository {
  final LiveStreamDataSource _dataSource;

  LiveStreamRepositoryImpl(this._dataSource);

  @override
  ServerResponse<Unit> endStream(String streamId) async {
    try {
      await _dataSource.endStream(streamId);
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  ServerResponse<Unit> updateThumbnail(String streamId, String filePath) async {
    try {
      await _dataSource.updateThumbnail(streamId, filePath);
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }
}
