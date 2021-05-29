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
  bool isLoading = true;

  @override
  void initState() {
    getLocations();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  showLoading() {
    return SimpleDialog(
      children: [
        Center(
          child: Column(
            children: [
              CircularProgressIndicator.adaptive(),
            ],
          ),
        )
      ],
    );
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
    setState(() {
      isLoading = false;
    });
  }

  Widget dnmButton() {
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
            location.name = "lorem ipsum";
            location.note = "evet ipsum";
            location.now = "now";
            var result = await locationdbservice.saveLocation(location);
            setState(() {
              getLocations();
            });

            print(result);
          },
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.orange[700], Colors.orange[300]])),
            child: Container(
              constraints: BoxConstraints(maxHeight: 300, minWidth: 50),
              alignment: Alignment.center,
              child: Text(
                "DB DENEME",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
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

            //popUpScreen();
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

  void popUpScreen() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
                color: Colors.blue[600],
                height: MediaQuery.of(context).size.height * .8,
                child: ListView.builder(
                    itemCount: globals.loclist.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                          child: Card(
                            child: ListTile(
                              leading: Text("_loclist[index].name"),
                              title: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  var result =
                                      await locationdbservice.deleteLocation(
                                          globals.loclist[index].id);
                                  mystate(() {
                                    globals.loclist.removeAt(index);
                                  });
                                  if (result > 0) {
                                    Toast.show("Silindi", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                    getLocations();
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ));
                    }));
          });
        });
  }

  Widget _loading() {
    // await Future.delayed(Duration(seconds: 1));
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * .3,
      width: MediaQuery.of(context).size.width * .5,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Container(
            /* decoration: BoxDecoration(
                image: DecorationImage(
              image:
                  AssetImage("assets/sylwia-bartyzel-D2K1UZr4vxk-unsplash.jpg"),
              fit: BoxFit.cover,
            )),*/
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
