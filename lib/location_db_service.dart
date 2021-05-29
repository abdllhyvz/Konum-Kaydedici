import 'location_model.dart';
import 'DB/repo.dart';

class LocationDBService {
  Repository _repository;

  LocationDBService() {
    _repository = Repository();
  }

  saveLocation(Loc location) async {
    return await _repository.insertData(
        'locations', location.categoryLocation());
  }

  readLocations() async {
    return await _repository.readData('locations');
  }

  deleteLocation(locId) async {
    return await _repository.deleteData('locations', locId);
  }
}
