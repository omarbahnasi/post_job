import 'package:post_job/post_job_feature/domain/entities/Post_Job_entity.dart';

import 'package:post_job/core/error/failure.dart';

import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../domain/repositiries/jobs_repository.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/post_job_remote_data_source.dart';
import '../models/job_post_model.dart';
typedef Future<Unit> DeleteOrUpdateOrAddJob();
class JobsRepositoryImpl extends JobsRepository {
  final PostJobRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final JobsLocalDataSource localDataSource;
  JobsRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, Unit>> addJob(JobPost post) async {
    
        final JobPostModel postModel = JobPostModel( image: post.image, jobDescription: post.jobDescription, jobId: post.jobId, jobName: post.jobName, jobType: post.jobType, salary: post.salary);

    return await _getMessage(() {
      return remoteDataSource.addJob(postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteJob(String jobId) async {
    return await _getMessage(() {
      return remoteDataSource.deleteJob(jobId);
    });
  }

  @override
  Future<Either<Failure, Unit>> updateJob(JobPost post) async {
    
        final JobPostModel postModel = JobPostModel( image: post.image, jobDescription: post.jobDescription, jobId: post.jobId, jobName: post.jobName, jobType: post.jobType, salary: post.salary);

    return await _getMessage(() {
      return remoteDataSource.updateJob(postModel);
    });
  }
  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddJob deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
  
  @override
    Future<Either<Failure, List<JobPost>>> getAllJobs() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteJobs = await remoteDataSource.getAllJobs();
        localDataSource.cacheJobs(remoteJobs);
        return Right(remoteJobs);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localJobs = await localDataSource.getCachedJobs();
        return Right(localJobs);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }
}
