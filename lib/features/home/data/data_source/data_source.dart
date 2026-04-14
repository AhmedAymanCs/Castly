import 'package:castly/core/constants/app_constants.dart';
import 'package:castly/core/models/stream_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeDataSource {
  Future<void> createStream(StreamModel stream);
  Future<List<StreamModel>> getCurrentStreams();
}

class HomeDataSourceImpl implements HomeDataSource {
  final FirebaseFirestore _firestore;

  HomeDataSourceImpl(this._firestore);

  @override
  Future<void> createStream(StreamModel stream) async {
    await _firestore
        .collection(AppConstants.streamsCollectionName)
        .doc(stream.id)
        .set(stream.toJson());
  }

  @override
  Future<List<StreamModel>> getCurrentStreams() async {
    final snapshot = await _firestore
        .collection(AppConstants.streamsCollectionName)
        .where('isLive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => StreamModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
}
