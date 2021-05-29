import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:project/add_location_page.dart';
import 'package:project/location_page.dart';
import 'location_model.dart';
import 'location_db_service.dart';
import 'package:toast/toast.dart';
import 'home_page.dart';
import 'global_list.dart' as globals;

class MyLocations extends StatefulWidget {
  _MyLocationsState createState() => _MyLocationsState();
}

class _MyLocationsState extends State<MyLocations> {
  var locationdbservice = LocationDBService();
  bool isLoading = true;

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

  deleteLocation(int index) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          globals.loclist[index].name + " Konumunu Silmek İstiyor Musun?",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              "Vazgeç",
              style: TextStyle(color: Colors.orange),
            ),
          ),
          TextButton(
            onPressed: () async {
              var result = await locationdbservice
                  .deleteLocation(globals.loclist[index].id);
              globals.loclist.removeAt(index);

              if (result > 0) {
                Toast.show("Silindi", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                getLocations();
              }
              setState(() {});
              Navigator.of(context).pop(false);
            },
            child: Text(
              "Evet",
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  getBody() {
    return ListView.builder(
        itemCount: globals.loclist.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                child: ListTile(
                  onTap: () {
                    globals.myLoc.id = globals.loclist[index].id;
                    globals.myLoc.lat = globals.loclist[index].lat;
                    globals.myLoc.lon = globals.loclist[index].lon;
                    globals.myLoc.name = globals.loclist[index].name;
                    globals.myLoc.note = globals.loclist[index].note;
                    globals.myLoc.now = globals.loclist[index].now;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LocPage()));
                  },
                  tileColor: Colors.grey[50],
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            globals.loclist[index].name,
                            style: TextStyle(fontSize: 14.2),
                          ),
                        ),
                      ]),
                  subtitle: Text(globals.loclist[index].now),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[500],
                    ),
                    onPressed: () async {
                      deleteLocation(index);
                    },
                  ),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "KONUMLARIM",
            style: TextStyle(),
          ),
          backgroundColor: Colors.orange[400],
        ),
        body: Container(
            /*decoration: BoxDecoration(
                image: DecorationImage(
              image:
                  AssetImage("assets/sylwia-bartyzel-D2K1UZr4vxk-unsplash.jpg"),
              fit: BoxFit.cover,
            )),*/

            //color: Colors.grey[100],
            //padding: EdgeInsets.only(top: 20),
            child: Stack(children: [
          Opacity(
            opacity: 0.7,
            child: Image(
              image:
                  AssetImage("assets/sylwia-bartyzel-D2K1UZr4vxk-unsplash.jpg"),
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitHeight,
            ),
          ),
          getBody()
        ])));
  }
}
