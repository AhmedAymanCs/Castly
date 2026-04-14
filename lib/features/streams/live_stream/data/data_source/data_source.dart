import 'package:castly/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LiveStreamDataSource {
  Future<void> endStream(String streamId);
}

class LiveStreamDataSourceImpl implements LiveStreamDataSource {
  final FirebaseFirestore _firestore;

  LiveStreamDataSourceImpl(this._firestore);

  @override
  Future<void> endStream(String streamId) async {
    await _firestore
        .collection(AppConstants.streamsCollectionName)
        .doc(streamId)
        .update({'isLive': false});
  }
}
