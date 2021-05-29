import 'package:flutter/material.dart';
import 'global_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:project/global_list.dart' as globals;

class LocPage extends StatefulWidget {
  _LocPageState createState() => _LocPageState();
}

class _LocPageState extends State<LocPage> {
  GoogleMapController _controller;
  List<Marker> _marker = [];
  TextEditingController textEditingController =
      TextEditingController(text: globals.myLoc.note);

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(globals.myLoc.lat, globals.myLoc.lon), zoom: 18),
    ));
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId("myMarker"),
          position: LatLng(globals.myLoc.lat, globals.myLoc.lon)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.myLoc.name),
        backgroundColor: Colors.orange[500],
      ),
      body: Container(
        //padding: EdgeInsets.only(top: 5),
        child: Stack(children: [
          Opacity(
            opacity: 0.3,
            child: Image(
              image: AssetImage(
                "assets/sylwia-bartyzel-D2K1UZr4vxk-unsplash.jpg",
              ),
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitHeight,
            ),
          ),
          Column(
            children: [
              Container(
                  // padding: EdgeInsets.only(bottom: 20),
                  height: MediaQuery.of(context).size.height * .58,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(globals.myLoc.lat, globals.myLoc.lon)),
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    markers: Set.from(_marker),
                    myLocationEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomControlsEnabled: true,
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * .07,
                  padding: EdgeInsets.only(right: 20, left: 20),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          globals.myLoc.name,
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        globals.myLoc.now,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Text(
                "Notun",
                style: TextStyle(fontSize: 20, color: Colors.orange[700]),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * .13,
                width: MediaQuery.of(context).size.width * .8,
                //color: Colors.white,
                child: TextField(
                  enabled: false,
                  controller: textEditingController,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
