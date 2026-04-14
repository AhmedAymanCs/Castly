import 'package:castly/core/constants/app_constants.dart';
import 'package:castly/core/models/stream_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class WatchStreamDataSource {
  Stream<StreamModel?> watchStream(String streamId);
  Future<void> updateViewerCount(String streamId, bool increment);
}

class WatchStreamDataSourceImpl implements WatchStreamDataSource {
  final FirebaseFirestore _firestore;

  WatchStreamDataSourceImpl(this._firestore);

  @override
  Stream<StreamModel?> watchStream(String streamId) {
    return _firestore
        .collection(AppConstants.streamsCollectionName)
        .doc(streamId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return StreamModel.fromJson({...doc.data()!, 'id': doc.id});
        });
  }

  @override
  Future<void> updateViewerCount(String streamId, bool increment) async {
    await _firestore
        .collection(AppConstants.streamsCollectionName)
        .doc(streamId)
        .update({'viewerCount': FieldValue.increment(increment ? 1 : -1)});
  }
}
