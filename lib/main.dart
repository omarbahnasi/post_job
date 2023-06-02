import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_job/core/widgets/app_theme.dart';
import 'package:post_job/post_job_feature/presentation/bloc/get_all_jobs/bloc/get_all_jobs_bloc.dart';
import 'package:post_job/post_job_feature/presentation/bloc/post_job/post_job_bloc.dart';
import 'package:post_job/post_job_feature/presentation/pages/jobs_page.dart';
import 'injection.dart'as di;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => di.sl<AllJobsBloc>()..add(GetAllJobsEvent())),
          BlocProvider(create: (_) => di.sl<AddDeleteUpdateJobBloc>()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            title: 'Posts Job',
            home: JobsPage()));
  }
}
