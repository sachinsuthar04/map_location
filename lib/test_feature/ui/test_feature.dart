import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/test_feature/bloc/user_data_bloc.dart';
import 'package:testing_app/test_feature/ui/test_presenter.dart';

class TestFeature extends StatelessWidget {
  const TestFeature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserDataBloc(),
      child: TestPresenter(),
    );
  }
}
