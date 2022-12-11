import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/test_feature/model/user_data_view_model.dart';
import 'package:testing_app/test_feature/ui/media_permission.dart';

class UserDataScreen extends Screen {
  final UserDataViewModel viewModel;

  const UserDataScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserDataScreenWidget(
      viewModel: viewModel,
    );
  }
}

class UserDataScreenWidget extends StatefulWidget {
  final UserDataViewModel viewModel;

  const UserDataScreenWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  State<UserDataScreenWidget> createState() => _UserDataScreenWidgetState();
}

class _UserDataScreenWidgetState extends State<UserDataScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.viewModel.isLoading
        ? Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Color(0xFFFDF3AD),
            appBar: AppBar(title: const Text("Map Details")),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('CURRENT LATITUDE: ${widget.viewModel.latitude}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    Text('CURRENT LONGITUDE: ${widget.viewModel.longitude}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('ADDRESS: ${widget.viewModel.address}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> checkPermission() async {
    final hasPermission =
        await MediaPermission.handleLocationPermission(context);

    if (!hasPermission) return;
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
