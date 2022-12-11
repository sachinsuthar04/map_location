import 'package:clean_framework/clean_framework.dart';

class UserDataViewModel extends ViewModel {
  final String address;
  final double longitude;
  final double latitude;
  final double currentLongitude;
  final double currentLatitude;
  final num distance;
  final bool isLoading;

  UserDataViewModel(
      {required this.address,
      required this.latitude,
      required this.longitude,
      required this.currentLatitude,
      required this.currentLongitude,
      required this.distance,
      required this.isLoading});

  @override
  List<Object?> get props => [
        address,
        latitude,
        longitude,
        currentLatitude,
        currentLongitude,
        distance,
        isLoading
      ];
}

class UserViewModel extends ViewModel {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String avatar;

  UserViewModel(
      {required this.id,
      required this.email,
      required this.firstname,
      required this.lastname,
      required this.avatar});

  @override
  List<Object?> get props => [id, email, firstname, lastname, email];
}

class Support extends ViewModel {
  final String url;
  final String text;

  Support({required this.url, required this.text});

  @override
  List<Object?> get props => [url, text];
}
