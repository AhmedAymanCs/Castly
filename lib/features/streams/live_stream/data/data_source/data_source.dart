import 'dart:developer';
import 'dart:io';

import 'package:castly/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LiveStreamDataSource {
  Future<void> endStream(String streamId);
  Future<void> updateThumbnail(String streamId, String filePath);
}

class LiveStreamDataSourceImpl implements LiveStreamDataSource {
  final FirebaseFirestore _firestore;
  final SupabaseClient _supabase;

  LiveStreamDataSourceImpl(this._firestore, this._supabase);

  @override
  Future<void> endStream(String streamId) async {
    await _firestore
        .collection(AppConstants.streamsCollectionName)
        .doc(streamId)
        .update({'isLive': false});
  }

  @override
  Future<void> updateThumbnail(String streamId, String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    await _supabase.storage
        .from('thumbnails')
        .uploadBinary(
          'streams/$streamId/thumbnail.jpg',
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    final url = _supabase.storage
        .from('thumbnails')
        .getPublicUrl('streams/$streamId/thumbnail.jpg');

    await _firestore
        .collection(AppConstants.streamsCollectionName)
        .doc(streamId)
        .update({'thumbnailUrl': url});
  }
}
