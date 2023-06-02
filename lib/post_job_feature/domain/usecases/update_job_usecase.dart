import 'package:dartz/dartz.dart';
import 'package:post_job/post_job_feature/domain/entities/Post_Job_entity.dart';

import '../../../core/error/failure.dart';
import '../repositiries/jobs_repository.dart';

class UpdateJobUseCase {
  final JobsRepository repository;

  UpdateJobUseCase(this.repository);

  Future<Either<Failure, Unit>> call(JobPost post) async {
    return await repository.updateJob(post);
  }
}
