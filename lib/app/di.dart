import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

// Data sources
import '../data/datasources/local/hive_database.dart';
import '../data/datasources/local/shared_prefs_helper.dart';
import '../data/datasources/remote/firebase_auth_datasource.dart';
import '../data/datasources/remote/firebase_firestore_datasource.dart';
import '../data/datasources/remote/firebase_storage_datasource.dart';

// Repositories
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/user_repository.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/lesson_repository.dart';
import '../data/repositories/lesson_repository_impl.dart';
import '../domain/repositories/vocabulary_repository.dart';
import '../data/repositories/vocabulary_repository_impl.dart';

// Use cases
import '../domain/usecases/auth/login_with_email_usecase.dart';
import '../domain/usecases/auth/register_with_email_usecase.dart';
import '../domain/usecases/auth/logout_usecase.dart';
import '../domain/usecases/auth/get_current_user_usecase.dart';

// BLoC
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/onboarding/onboarding_bloc.dart';
import '../presentation/bloc/vocabulary/vocabulary_bloc.dart';
import '../presentation/bloc/lesson/lesson_bloc.dart';

// Services
import '../core/services/audio_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/analytics_service.dart';

// AI
import '../ai/recommendation_engine.dart';
import '../ai/error_analysis_engine.dart';

// Backend
import '../backend/api/api_client.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  
  getIt.registerLazySingleton<Dio>(() => Dio(BaseOptions(
    baseUrl: 'https://api.ungdunghoctiengcanh.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  )));

  // Local database
  await HiveDatabase.init();
  getIt.registerSingleton<HiveDatabase>(HiveDatabase());
  
  // Helpers
  getIt.registerLazySingleton<SharedPrefsHelper>(
    () => SharedPrefsHelper(getIt<SharedPreferences>()),
  );

  // Data sources
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(getIt<FirebaseAuth>()),
  );
  
  getIt.registerLazySingleton<FirebaseFirestoreDataSource>(
    () => FirebaseFirestoreDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  
  getIt.registerLazySingleton<FirebaseStorageDataSource>(
    () => FirebaseStorageDataSourceImpl(getIt<FirebaseStorage>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: getIt<FirebaseAuthDataSource>(),
      sharedPrefsHelper: getIt<SharedPrefsHelper>(),
    ),
  );
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      firestoreDataSource: getIt<FirebaseFirestoreDataSource>(),
    ),
  );
  
  getIt.registerLazySingleton<LessonRepository>(
    () => LessonRepositoryImpl(
      firestoreDataSource: getIt<FirebaseFirestoreDataSource>(),
      hiveDatabase: getIt<HiveDatabase>(),
    ),
  );
  
  getIt.registerLazySingleton<VocabularyRepository>(
    () => VocabularyRepositoryImpl(
      firestoreDataSource: getIt<FirebaseFirestoreDataSource>(),
      hiveDatabase: getIt<HiveDatabase>(),
    ),
  );

  // Use cases - Auth
  getIt.registerLazySingleton(() => LoginWithEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterWithEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt<AuthRepository>()));

  // Services
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());

  // AI Engines
  getIt.registerLazySingleton<RecommendationEngine>(() => RecommendationEngine());
  getIt.registerLazySingleton<ErrorAnalysisEngine>(() => ErrorAnalysisEngine());

  // Backend API
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  // BLoC
  getIt.registerFactory(() => AuthBloc(
    loginWithEmailUseCase: getIt<LoginWithEmailUseCase>(),
    registerWithEmailUseCase: getIt<RegisterWithEmailUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
    getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
  ));
  
  getIt.registerFactory(() => OnboardingBloc());
  getIt.registerFactory(() => VocabularyBloc(vocabularyRepository: getIt<VocabularyRepository>()));
  getIt.registerFactory(() => LessonBloc(lessonRepository: getIt<LessonRepository>()));
}

