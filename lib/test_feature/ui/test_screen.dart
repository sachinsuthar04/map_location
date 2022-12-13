import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
//TODO direction api work only enable billing from MAP

class _UserDataScreenWidgetState extends State<UserDataScreenWidget> {
  Completer<GoogleMapController> _controller = Completer();

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAD0-RUVVHaGsD-lf9lniWooAxZ_epjWMs";
  Map<MarkerId, Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final CameraPosition _kInitialPosition = CameraPosition(
        target:
            LatLng(MediaPermission().sourceLat, MediaPermission().sourceLong),
        zoom: 16.0,
        tilt: 0,
        bearing: 0);
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
                child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: GoogleMap(
                    initialCameraPosition: _kInitialPosition,
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    // on below line we are setting markers on the map
                    markers: Set<Marker>.of(markers.values),
                    // on below line setting user location enabled.
                    myLocationEnabled: true,
                    // on below line setting compass enabled.
                    zoomGesturesEnabled: true,
                    compassEnabled: true,
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
                ),
                buildCenter()
              ],
            )),
          );
  }

  Center buildCenter() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 8.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('CURRENT LATITUDE: ${widget.viewModel.latitude}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            Text('CURRENT LONGITUDE: ${widget.viewModel.longitude}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('ADDRESS: ${widget.viewModel.address}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          ],
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
    _addMarker(
        LatLng(MediaPermission().sourceLat, MediaPermission().sourceLong),
        "origin",
        BitmapDescriptor.defaultMarkerWithHue(40));
    _addMarker(LatLng(MediaPermission().stop1Lat, MediaPermission().stop1Long),
        "STOP1", BitmapDescriptor.defaultMarker);
    _addMarker(LatLng(MediaPermission().stop2Lat, MediaPermission().stop2Long),
        "STOP2", BitmapDescriptor.defaultMarker);
    _addMarker(LatLng(MediaPermission().stop3Lat, MediaPermission().stop3Long),
        "STOP3", BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(
        LatLng(MediaPermission().destinationLat,
            MediaPermission().destinationLong),
        "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: InfoWindow(
          title: id,
        ));
    markers[markerId] = marker;
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(MediaPermission().sourceLat, MediaPermission().sourceLong),
        PointLatLng(MediaPermission().destinationLat,
            MediaPermission().destinationLong),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "India")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
