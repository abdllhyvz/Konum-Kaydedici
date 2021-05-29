import 'package:flutter/material.dart';
import 'package:project/add_location_page.dart';
import 'package:project/my_locations_page.dart';
import 'location_model.dart';
import 'location_db_service.dart';
import 'package:toast/toast.dart';
import 'global_list.dart' as globals;

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List<Loc> _loclist = [];
  var locationdbservice = LocationDBService();
  var location = Loc();

  @override
  void initState() {
    getLocations();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              shadowColor: Colors.orange),
          clipBehavior: Clip.antiAlias,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddLocation()));
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
                "KONUMU KAYDET",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  locationsButton(BuildContext context) {
    return Container(
        width: 250,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              shadowColor: Colors.orange),
          clipBehavior: Clip.antiAlias,
          onPressed: () async {
            await getLocations();

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyLocations()));
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
                "KONUMLARIM",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Container(
            child: Stack(alignment: Alignment.center, children: [
          Opacity(
            opacity: 0.85,
            child: Image(
              image:
                  AssetImage("assets/sylwia-bartyzel-D2K1UZr4vxk-unsplash.jpg"),
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * .4),
            child: Text(
              "KONUM KAYDEDİCİ",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * .1,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.orange[700],
                  shadows: [
                    Shadow(
                      color: Colors.orange[200],
                      blurRadius: 25,
                    )
                  ]),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 400),
              child: Column(
                children: [
                  // dnmButton(),
                  SizedBox(
                    height: 30,
                  ),
                  saveButton(),
                  SizedBox(
                    height: 30,
                  ),
                  locationsButton(context)
                ],
              ),
            ),
          )
        ])));
  }
}
