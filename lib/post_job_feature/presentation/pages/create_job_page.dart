import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_job/post_job_feature/presentation/bloc/post_job/post_job_bloc.dart';

import '../../../core/util/snackbar_message.dart';
import '../../domain/entities/Post_Job_entity.dart';

import 'package:post_job/core/widgets/loading_widget.dart';

import '../widgets/add_job/form_widget.dart';

class AddJobPage extends StatelessWidget {
  final JobPost? post;
  final bool isUpdateJob;
  const AddJobPage({Key? key, this.post, required this.isUpdateJob})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(title: Text(isUpdateJob ? "Edit Job" : "Add Job"));
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: BlocConsumer<AddDeleteUpdateJobBloc, AddDeleteUpdateJobsState>(
            listener: (context, state) {
              if (state is MessageAddDeleteUpdateJobsState) {
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message, context: context);
              } else if (state is ErrorAddDeleteUpdateJobsState) {
                SnackBarMessage().showErrorSnackBar(
                    message: state.message, context: context);
              }
            },
            builder: (context, state) {
              if (state is LoadingAddDeleteUpdateJobsState) {
                return LoadingWidget();
              }

              return FormWidget(
                  isUpdateJob: isUpdateJob, post: isUpdateJob ? post : null);
            },
          )),
    );
  }
}
