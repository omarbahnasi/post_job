import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:post_job/post_job_feature/data/data_sources/local_data_source.dart';
import 'package:post_job/post_job_feature/data/data_sources/post_job_remote_data_source.dart';
import 'package:post_job/post_job_feature/data/repositries/jobs_repository_impl.dart';
import 'package:post_job/post_job_feature/domain/repositiries/jobs_repository.dart';
import 'package:post_job/post_job_feature/domain/usecases/add_job_usecase.dart';
import 'package:post_job/post_job_feature/domain/usecases/delete_job_usecase.dart';
import 'package:post_job/post_job_feature/domain/usecases/get_all_jobs_usecase.dart';
import 'package:post_job/post_job_feature/domain/usecases/update_job_usecase.dart';
import 'package:http/http.dart'as http;

import 'package:post_job/post_job_feature/presentation/bloc/post_job/post_job_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - posts

// Bloc

  sl.registerFactory(() =>
      AddDeleteUpdateJobBloc(addJob: sl(), updateJob: sl(), deleteJob: sl()));

// Usecases
  sl.registerLazySingleton(() => GetAllJobsUseCase(sl()));
  sl.registerLazySingleton(() => AddJobUseCase(sl()));
  sl.registerLazySingleton(() => DeleteJobUseCase(sl()));
  sl.registerLazySingleton(() => UpdateJobUseCase(sl()));

// Repository

  sl.registerLazySingleton<JobsRepository>(() => JobsRepositoryImpl(
      remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()));

// Datasources
  
  sl.registerLazySingleton<PostJobRemoteDataSource>(
      () => PostJobRemoteDataSourceImpl(client: sl()));
        sl.registerLazySingleton<JobsLocalDataSource>(
      () => JobsLocalDataSourceImpl(sharedPreferences: sl()));


//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
