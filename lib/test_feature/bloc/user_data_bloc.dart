import 'package:clean_framework/clean_framework.dart';
import 'package:testing_app/test_feature/bloc/location_usecase.dart';
import 'package:testing_app/test_feature/model/user_data_view_model.dart';

class UserDataBloc extends Bloc {
  late final LocationUseCase  locationUseCase;
  final fetchUserData = Pipe<UserDataViewModel>(canSendDuplicateData: true);

  UserDataBloc() {
    locationUseCase = LocationUseCase(fetchUserData.send);
    fetchUserData.whenListenedDo(() => locationUseCase.execute());
  }

  @override
  void dispose() {
    fetchUserData.dispose();
  }
}
