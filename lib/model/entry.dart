import 'package:diary_app/Db/database_provider.dart';

class Entry{
  int id;
  //String title;
  String message;

Entry({this.id,this.message});

Map<String, dynamic> toMap(){
  var map = <String,dynamic>{
    DatabaseProvider.MESSAGE: message,};

  if (id != null) {
    map[DatabaseProvider.COLUMN_ID] = id;
  }

  return map;
}
  Entry.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
   // title = map[DatabaseProvider.TITLE];
    message = map[DatabaseProvider.MESSAGE];
  }
}
