class Loc {
  int id;
  double lat;
  double lon;
  String name;
  String note;
  String now;
  Loc({this.lat, this.lon, this.name, this.note, this.now});

  categoryLocation() {
    var mapping = Map<String, dynamic>();
    mapping["id"] = id;
    mapping["lat"] = lat;
    mapping["lon"] = lon;
    mapping["name"] = name;
    mapping["note"] = note;
    mapping["now"] = now;

    return mapping;
  }
}
