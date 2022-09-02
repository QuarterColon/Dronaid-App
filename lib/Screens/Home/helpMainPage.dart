import 'package:dronaidapp/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HelpPage extends StatefulWidget {
  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  static const double fabHeightClosed = 116.0;
  double fabHeight = fabHeightClosed;
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(13.35668164832287, 74.78948939733098),
    zoom: 13.5,
  );

  GoogleMapController? _googleMapController;
  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: 450.0,
        backdropEnabled: true,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        panel: _createListMenu(),
        color: const Color.fromRGBO(29, 56, 73, 1.0),
        backdropColor: Colors.blue,
        backdropTapClosesPanel: true,
        body: GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (controller) => _googleMapController,
        ),
        collapsed: Container(
          decoration: BoxDecoration(
              color: const Color.fromRGBO(29, 56, 73, 1.0),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0))),
          child: Center(
            child: Text(
              'Slide Upwards',
              style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.blue,
        onPressed: () => _googleMapController?.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition)),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Widget _createListMenu() {
    return Container(

        margin: const EdgeInsets.only(top: 36.0),
        color: const Color.fromRGBO(39, 77, 100, 1.0),
        child: Column(
          children: [
            Row(children: [
              MyCardWidget("Medical Aid", Icons.medical_services, 100, 190, 40),
              MyCardWidget("Fire", Icons.fire_truck_outlined, 100, 190, 40)
            ]),
            Row(children: [
              MyCardWidget(
                  "Ambulance", Icons.medical_services_rounded, 100, 190, 40),
              MyCardWidget("Police", Icons.local_police, 100, 190, 40)
            ]),
            MyCardWidget("", Icons.sos, 200, 300, 240)
          ],
        ));
  }
}

class MyCardWidget extends StatefulWidget {
  MyCardWidget(
      this.text, this.iconName, this.height, this.width, this.iconSize);
  String text = "Hello";
  IconData iconName = Icons.add;
  double height = 100, width = 190, iconSize;

  @override
  State<MyCardWidget> createState() => _MyCardWidgetState();
}

class _MyCardWidgetState extends State<MyCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: widget.width,
      height: widget.height,
      padding: new EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.redAccent,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: SizedBox(
                child: Icon(widget.iconName, size: widget.iconSize),
                height: 50,
                width: 50,
              ),
              title: Text(widget.text, style: TextStyle(fontSize: 20.0)),
            ),
          ],
        ),
      ),
    ));
  }
}
