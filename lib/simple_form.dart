import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'helper_util.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  double distance = 0.0;
  double? latitude, longitude;
  String? address, collegeAddress;

  @override
  void initState() {
    getAddress();
    super.initState();
  }

  getAddress() async {
    LocationPermission permission = await HelperUtil().getPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Stream<Coordinate> coordinateStream = HelperUtil().getCoordinateStream();
      coordinateStream.listen((event) {
        setState(() {
          latitude = event.latitude;
          longitude = event.longitude;
          address = event.address;
        });
        getAddressOfCollege("Nist");
        // ApiService() .sendValueToFirebase(longitude!, latitude!, address!, "Ugrachandi");
      });
    }
  }

  //
  getAddressOfCollege(String college) async {
    var response = await FirebaseFirestore.instance
        .collection('station')
        .where('station', isEqualTo: college)
        .get();
    var abc = response.docs.first;
    distance = await HelperUtil().calculateDistance(
        latitude!, longitude!, abc.data()['latitude'], abc.data()['longitude']);
    collegeAddress = abc.data()['address'];
    setState(() {
      collegeAddress;
      distance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("College Info"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: collegeAddress != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    // Text(
                    //   "Longitude: ${longitude}",
                    //   style: TextStyle(fontSize: 25),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Text(
                    //   "Latitude:${latitude}",
                    //   style: TextStyle(fontSize: 25),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Text(
                    //   "Address:${address}",
                    //   style: TextStyle(fontSize: 25),
                    // ),

                    Card(
                      child: Column(
                        children: [
                          Text(
                            "College: Nist",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Address:${collegeAddress ?? ""}",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Distance:${distance!}",
                            style: TextStyle(fontSize: 25),
                          ),
                          IconButton(
                              onPressed: () async {
                                await HelperUtil().launchMaps(collegeAddress!);
                              },
                              icon: Icon(Icons.location_on))
                        ],
                      ),
                    ),
                    //second card
                    // Card(
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         "College: ${longitude}",
                    //         style: TextStyle(fontSize: 25),
                    //       ),
                    //       SizedBox(
                    //         height: 20,
                    //       ),
                    //       Text(
                    //         "Address:${latitude}",
                    //         style: TextStyle(fontSize: 25),
                    //       ),
                    //       SizedBox(
                    //         height: 20,
                    //       ),
                    //       Text(
                    //         "Distance:${address}",
                    //         style: TextStyle(fontSize: 25),
                    //       ),
                    //       IconButton(onPressed: () {}, icon: Icon(Icons.location_on))
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
