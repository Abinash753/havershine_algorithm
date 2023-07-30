import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'helper_util.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  double? latitude, longitude;
  String? address;
  @override
  void initState() {
    super.initState();
    getAddress();
  }

  getAddress() async {
    LocationPermission permission = await HelperUtil().getPermission();
    if (permission != LocationPermission.denied) {
      Stream<Coordinate> coordinateStream = HelperUtil().getCoordinateStream();
      coordinateStream.listen((event) {
        setState(() {
          latitude = event.latitude;
          longitude = event.longitude;
          address = event.address;
        });
        // ApiService() .sendValueToFirebase(longitude!, latitude!, address!, "Ugrachandi");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("User Info"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Longitude: ${longitude}",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Latitude:${latitude}",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Address:${address}",
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
