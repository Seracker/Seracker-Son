import 'package:get_it/get_it.dart';
import 'package:seracker/repository/user_repository.dart';
import 'package:seracker/services/fake_auth_service.dart';
import 'package:seracker/services/firebase_auth_service.dart';
import 'package:seracker/services/firestore_db_service.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationServise());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
}