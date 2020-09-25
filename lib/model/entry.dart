import 'package:diary_app/Db/database_provider.dart';

class Entry{
  int id;
  String time;
  String size;
  String message;

Entry({this.id,this.message,this.time,this.size});

Map<String, dynamic> toMap(){
  var map = <String,dynamic>{
    DatabaseProvider.TIME: time,
    DatabaseProvider.SIZE: size,
    DatabaseProvider.MESSAGE: message,};

  if (id != null) {
    map[DatabaseProvider.COLUMN_ID] = id;
  }

  return map;
}
  Entry.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    time = map[DatabaseProvider.TIME];
    size = map[DatabaseProvider.SIZE];
    message = map[DatabaseProvider.MESSAGE];
  }
}
