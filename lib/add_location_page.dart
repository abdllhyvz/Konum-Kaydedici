import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
import 'home_page.dart';
import 'package:intl/intl.dart';
import 'location_model.dart';
import 'location_db_service.dart';
import 'global_list.dart' as globals;

class AddLocation extends StatefulWidget {
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  GoogleMapController _controller;
  Location _location = Location();
  Loc loc = Loc();
  TextEditingController textEditingController = TextEditingController();
  var locationdbservice = LocationDBService();
  String _title = " ";

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      loc.lat = l.latitude;
      loc.lon = l.longitude;

      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 18),
        ),
      );
    });
  }

  Future<String> locationName() async {
    loc.note = textEditingController.text;
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(loc.lat, loc.lon);
    String address =
        ""; //placemarks[0].thoroughfare + " " + placemarks[0].name + " " + placemarks[0].;
    for (var i = 0; i < placemarks.length; i++) {
      address += placemarks[i].name + ", ";
    }
    address += placemarks[0].country;
    return address;
  }

  getLocations() async {
    globals.loclist = [];
    var locations = await locationdbservice.readLocations();
    locations.forEach((location) {
      setState(() {
        var locationModel = Loc();
        locationModel.lat = location['lat'];
        locationModel.lon = location['lon'];
        locationModel.name = location['name'];
        locationModel.note = location['note'];
        locationModel.now = location['now'];
        locationModel.id = location['id'];
        globals.loclist.add(locationModel);
      });
    });
  }

  Widget saveButton() {
    return Container(
        width: 250,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          clipBehavior: Clip.antiAlias,
          onPressed: () async {
            /*loc.note = textEditingController.text;
            List<geo.Placemark> placemarks =
                await geo.placemarkFromCoordinates(loc.lat, loc.lon);
            String address =
                ""; //placemarks[0].thoroughfare + " " + placemarks[0].name + " " + placemarks[0].;
            for (var i = 0; i < placemarks.length; i++) {
              address += placemarks[i].name + ", ";
            }
            address += placemarks[0].country;*/
            loc.name = await locationName();
            loc.note = textEditingController.text;
            loc.now = DateFormat.yMd('tr_TR').format(DateTime.now()) +
                " " +
                DateFormat.Hm('tr_TR').format(DateTime.now());
            await locationdbservice.saveLocation(loc);
            setState(() {
              getLocations();
            });
            Toast.show(loc.name + " Eklendi.", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
            /* globals.myLoc.name = await locationName();
            await locationdbservice.saveLocation(loc);
            globals.myLoc.now = DateTime.now().toString();*/
          },
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.orange, Colors.orange[200]])),
            child: Container(
              constraints: BoxConstraints(maxHeight: 300, minWidth: 50),
              alignment: Alignment.center,
              child: Text(
                "EKLE",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("KONUM EKLE"),
          backgroundColor: Colors.orange[500],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        body: Container(
            /*decoration: BoxDecoration(
                image: DecorationImage(
              image:
                  AssetImage("assets/sylwia-bartyzel-D2K1UZr4vxk-unsplash.jpg"),
              fit: BoxFit.cover,
            )),*/
            child: Stack(children: [
          Opacity(
            opacity: 0.4,
            child: Image(
              image:
                  AssetImage("assets/sylwia-bartyzel-D2K1UZr4vxk-unsplash.jpg"),
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .13,
                  width: MediaQuery.of(context).size.width * .8,
                  //color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                      labelText: "Not Girebilirsin",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange[700])),
                    ),
                    maxLength: 29,
                    obscureText: false,
                    controller: textEditingController,
                  ),
                ),
                Container(
                    // padding: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(
                            color: Colors.orange[300],
                            style: BorderStyle.solid)),
                    height: MediaQuery.of(context).size.height * .55,
                    child: GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: LatLng(41, 29)),
                      mapType: MapType.normal,
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                    )),
                SizedBox(
                  height: 16,
                ),
                saveButton()
              ],
            ),
          )
        ])));
  }
}
