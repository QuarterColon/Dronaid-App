import 'package:dronaidapp/Screens/Shopping/provider/cart.dart';
import 'package:dronaidapp/Screens/Shopping/provider/order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key, this.order});
  static const routeName = 'Tracking';
  final Order? order;


  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  GoogleMapController? _controller;
  BitmapDescriptor droneIcon = BitmapDescriptor.defaultMarker;
  LocationData? currentLocation;
  Map? droneLiveLocation;
  DatabaseReference db = FirebaseDatabase.instance.ref();
  String? status;
  int? statusCode;

  double? droneLatitude;
  double? droneLongitude;
  double? destinationLatitude;
  double? destinationLongitude;


  Set<Marker> markers = {};
  List<LatLng> route = [];

  Future getCurrentLocation() async {
    Location location = Location();
    LatLng destination;
    await location.getLocation().then((location) => currentLocation = location);

    markers.add(
      Marker(
        markerId: const MarkerId("Destination"),
        position:
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      ),
    );

    setState(() {});
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), "assets/images/drone_small.png")
        .then((icon) => droneIcon = icon);
  }

  Future getDroneData() async {
    db.child("DRONE/Drone1/").onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        droneLiveLocation = event.snapshot.value as Map;
        droneLatitude = droneLiveLocation!['live']!['latitude'];
        droneLongitude = droneLiveLocation!['live']!['longitude'];
        statusCode = droneLiveLocation!['destination']!['status'];

        // _controller!.animateCamera(
        //   CameraUpdate.newLatLng(
        //     LatLng(latitude, longitude),
        //   ),
        // );

        setState(() {
          if (statusCode == 0) {
            status = "In Transit";
          } else if (statusCode == 1) {
            status = "On the way";
          } else if (statusCode == 2) {
            status = "Delivered";
          }
          markers.clear();
          markers.add(Marker(
            markerId: const MarkerId("Drone 1"),
            position: LatLng(droneLatitude!, droneLongitude!),
            icon: droneIcon,
          ));
          markers.add(
            Marker(
              markerId: const MarkerId("Destination"),
              position: LatLng(destinationLatitude!, destinationLongitude!),
            ),
          );
          route = [
            LatLng(droneLatitude!, droneLongitude!),
            LatLng(destinationLatitude!, destinationLongitude!),
          ];
        });
      } else if (event.snapshot.value == null) {
        print("no data");
      }
    });
  }

  void updateDestination() async {
    try {
      await db.child("DRONE/Drone1/destination").update({
        "latitude": destinationLatitude!,
        "longitude": destinationLongitude!,
        "take-off": 1,
      });
    } catch (e) {
      print("error");
    }
  }

  void confirmRoute() async {
    await getDroneData();
    // await getCurrentLocation();
    route = [
      LatLng(droneLatitude!, droneLongitude!),
      LatLng(destinationLatitude!, destinationLongitude!),
    ];
  }

//   Future deliveryStatus() async {
//     db.child("DRONE/Drone1/destination/").onValue.listen((DatabaseEvent event) {
//       if (event.snapshot.value != null) {
//         destinationData = event.snapshot.value as Map;
//         int code = destinationData!['status'];
//         if (code == 0) {
//           status = "order placed";
//         }
//         else if (code == 1) {
//           status = "on the way";
//         }
//       }
//     });
//
// }

  @override
  void initState() {

    // destinationLatitude =
    //     double.tryParse((widget.order!.location.split(","))[0]);
    // destinationLongitude =
    //     double.tryParse((widget.order!.location.split(","))[1]);

    destinationLatitude = widget.order!.location.latitude;
    destinationLongitude = widget.order!.location.longitude;
    route = [];
    confirmRoute();
    updateDestination();
    addCustomIcon();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Delivery Status",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: (destinationLatitude == null || destinationLongitude == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        // currentLocation!.latitude!,
                        // currentLocation!.longitude!,
                        destinationLatitude!,
                        destinationLongitude!,
                      ),
                      zoom: 16,
                    ),
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      setState(() {
                        _controller = controller;
                      });
                    },
                    markers: markers,
                    polylines: {
                      Polyline(
                          polylineId: const PolylineId("Live route"),
                          points: route,
                          zIndex: 5),
                    }),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 250,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.order!.id,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.redAccent,
                                onTap: () => {},
                                child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: Colors.red,
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                              ),

                              // Text('Delivery Status: $status'),
                              // SizedBox(height: 8.0),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    // width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
                                      "ORDER TYPE:",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                  Container(
                                    // width: double.infinity,
                                    // padding: const EdgeInsets.all(4),
                                    child: const Text(
                                      "Medicines",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Container(
                                    // width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
                                      "DESTINATION ADDRESS:",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                  Container(
                                    width: 220,
                                    child: Text(
                                      widget.order!.address,
                                      // overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.phone_in_talk_sharp,
                                size: 20.0,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(330, 60),
                                  elevation: 4,
                                  backgroundColor: const Color(0xFF8689C6),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(60.0))),
                              onPressed: () {
                                debugPrint('pushed');
                              },
                              label: const Text(
                                'Call Support',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                        // SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
