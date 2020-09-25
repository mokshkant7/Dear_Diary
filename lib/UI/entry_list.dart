import 'package:diary_app/Db/database_provider.dart';
import 'package:diary_app/events/delete_entry.dart';
import 'package:diary_app/events/set_entries.dart';
import 'package:diary_app/UI/entry_form.dart';
import 'package:diary_app/model/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/entry_bloc.dart';

//DateTime now = DateTime.now();
//String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

class EntryList extends StatefulWidget {
  const EntryList({Key key}) : super(key: key);

  @override
  _EntryListState createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getEntries().then(
          (entryList) {
        BlocProvider.of<EntryBloc>(context).add(SetEntries(entryList));
      },
    );
  }

  showEntryDialog(BuildContext context, Entry entry, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
       // title: Text(entry.title),
        content: Text("Entry ${entry.id}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EntryForm(entry: entry, entryIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(entry.id).then((_) {
              BlocProvider.of<EntryBloc>(context).add(
                DeleteEntry(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DEAR DIARY"),backgroundColor: Colors.black87,centerTitle: true,),
      body: Container(
        child: BlocConsumer<EntryBloc, List<Entry>>(
          builder: (context, entryList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Entry entry = entryList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15,0,0,0),
                      child: Text(entry.time??"Today",style: TextStyle(color: Colors.blueAccent),),
                    ),
                    SizedBox(height: 15,),
                    ListTile(
                      //  title: Text(entry.title, style: TextStyle(fontSize: 30)),
                        subtitle: Text(entry.message, style: TextStyle(fontSize: double.parse(entry.size),fontWeight: FontWeight.bold)),
                        onTap: () => showEntryDialog(context, entry, index)),
                    SizedBox(height: 15,),
                  ],
                );
              },
              itemCount: entryList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, entryList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black87,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => EntryForm()),
        ),
      ),
    );
  }
}
