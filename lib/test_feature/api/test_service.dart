import 'dart:convert';

import 'package:clean_framework/clean_framework.dart';
import 'package:http/http.dart' as http;
import 'package:testing_app/test_feature/model/user_response_model.dart';

class TestService extends Service {
  @override
  Future<UserResponseResultList> request(
      {ServiceRequestModel? requestModel}) async {
    http.Response response = await http.get(
        Uri.parse("https://reqres.in/api/users?page=1"));
    Map<String, dynamic> responseMap = json.decode(response.body);
    return UserResponseResultList.fromJson(responseMap);
  }


}

