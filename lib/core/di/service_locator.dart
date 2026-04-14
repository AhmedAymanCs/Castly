import 'package:castly/features/home/data/data_source/data_source.dart';
import 'package:castly/features/home/data/repository/repositroy.dart';
import 'package:castly/features/profile/data/data_source/data_source.dart';
import 'package:castly/features/profile/data/repository/repo.dart';
import 'package:castly/features/streams/live_stream/data/data_source/data_source.dart';
import 'package:castly/features/streams/live_stream/data/repository/repo.dart';
import 'package:castly/features/streams/watch_stream/data/data_source/data_source.dart';
import 'package:castly/features/streams/watch_stream/data/repository/repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:castly/core/services/fcm_service.dart';
import 'package:castly/core/services/local_notification_service.dart';

import 'package:castly/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:castly/features/auth/data/data_source/auth_data_source.dart';
import 'package:castly/features/auth/data/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

void intitSetupLocator() {
  _setupFirestoreServiceLocator();
  _setupSecureStorageServiceLocator();
  _setupAuthRepositoryLocator();
  _setupNotificationServiceLocator();
  _setupSupabaseServiceLocator();
  _setupProfileLocator();
  _setupHomeLocator();
  _setupStreamLocator();
}

Future<void> _setupSupabaseServiceLocator() async {
  String url = dotenv.env['SUPABASE_URL'] ?? '';
  String apiKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  await Supabase.initialize(url: url, anonKey: apiKey);

  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
}

void _setupSecureStorageServiceLocator() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
  getIt.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(getIt<FlutterSecureStorage>()),
  );
}

void _setupAuthRepositoryLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      getIt<FirebaseAuth>(),
      getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
      firestore: getIt<FirebaseFirestore>(),
      secureStorageHelper: getIt<SecureStorageHelper>(),
    ),
  );
}

void _setupFirestoreServiceLocator() {
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
}

void _setupNotificationServiceLocator() {
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );
  getIt.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(getIt<FlutterLocalNotificationsPlugin>()),
  );
  getIt<LocalNotificationService>().init();

  getIt.registerLazySingleton<FCMService>(
    () => FCMService(getIt<LocalNotificationService>()),
  );
  getIt<FCMService>().init();
}

void _setupProfileLocator() {
  getIt.registerLazySingleton<ProfileDataSource>(
    () => ProfileDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      secureStorageHelper: getIt<SecureStorageHelper>(),
      auth: getIt<FirebaseAuth>(),
      supabaseClient: getIt<SupabaseClient>(),
    ),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileDataSource>()),
  );
}

void _setupHomeLocator() {
  getIt.registerLazySingleton<HomeDataSource>(
    () => HomeDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeDataSource>()),
  );
}

void _setupStreamLocator() {
  getIt.registerLazySingleton<LiveStreamDataSource>(
    () => LiveStreamDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<WatchStreamDataSource>(
    () => WatchStreamDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<LiveStreamRepository>(
    () => LiveStreamRepositoryImpl(getIt<LiveStreamDataSource>()),
  );
  getIt.registerLazySingleton<WatchStreamRepository>(
    () => WatchStreamRepositoryImpl(getIt<WatchStreamDataSource>()),
  );
}
