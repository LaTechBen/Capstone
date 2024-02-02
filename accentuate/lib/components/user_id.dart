var _userID = "Bowman";
var _storageLocation = "gs://accentuate-3be42.appspot.com";

updateID(String id) {
  _userID = id;
}

getID() {
  return _userID;
}

updateStorage(String location) {
  _storageLocation = location;
}

getStorage() {
  return _storageLocation;
}
