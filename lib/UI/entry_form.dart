import 'package:diary_app/bloc/entry_bloc.dart';
import 'package:diary_app/db/database_provider.dart';
import 'package:diary_app/events/add_entry.dart';
import 'package:diary_app/events/update_entry.dart';
import 'package:diary_app/model/entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/animation.dart';

DateTime now = DateTime.now();

class EntryForm extends StatefulWidget {
  final Entry entry;
  final int entryIndex;

  EntryForm({this.entry, this.entryIndex});

  @override
  State<StatefulWidget> createState() {
    return EntryFormState();
  }
}

class EntryFormState extends State<EntryForm> with SingleTickerProviderStateMixin{
//  String _title;
  String _message;
  String _time;
  String _size;
  Animation<double> animation;
  AnimationController controller;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//  Widget _buildTitle() {
//    return TextFormField(
//      initialValue: _title,
//      decoration: InputDecoration(labelText: 'Title'),
//      maxLength: 100,
//      style: TextStyle(fontSize: 20),
//      validator: (String value) {
//        if (value.isEmpty) {
//          return 'Title is Required';
//        }
//
//        return null;
//      },
//      onSaved: (String value) {
//        _title = value;
//      },
//    );
//  }

  Widget _buildMessage() {
    return TextFormField(
      initialValue: _message,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(hintText:'Write Your Story :',hintStyle: TextStyle(fontSize: 16) ),
      maxLength: null,
      maxLines: 11,
      style: TextStyle(fontSize: animation.value),

      validator: (String value) {
        if (value.isEmpty) {
          return 'Message is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _message = value;
      },
    );
  }

  Widget getTime(){
    return Text(DateFormat('yyyy-MM-dd – kk:mm').format(now)??0000-00-00);
  }

  Widget getSize(){
    return Text( _size=animation.value.toString()??18);
  }

  void increaseFontSize() {
    setState(() {
      controller.forward();
    });
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 12.0, end: 50.0).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });

    if (widget.entry != null) {
      _time = widget.entry.time;
      _message = widget.entry.message;
      _size=widget.entry.size;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NEW ENTRY"),centerTitle: true,backgroundColor: Colors.black87,),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//              _buildTitle(),
              getTime(),
                getSize(),
                _buildMessage(),
                SizedBox(height: 16),
                widget.entry == null
                    ? RaisedButton(
                  color: Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black)
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onLongPress:(){increaseFontSize();} ,
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();

                    Entry entry = Entry(
                      time: _time,
                      message: _message,
                      size : _size,
                    );

                    DatabaseProvider.db.insert(entry).then(
                          (storedEntry) => BlocProvider.of<EntryBloc>(context).add(
                        AddEntry(storedEntry),
                      ),
                    );

                    Navigator.pop(context);
                  },
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          print("form");
                          return;
                        }

                        _formKey.currentState.save();

                        Entry entry = Entry(
                          time: _time,
                          message: _message,
                          size : _size,
                        );

                        DatabaseProvider.db.update(widget.entry).then(
                              (storedEntry) => BlocProvider.of<EntryBloc>(context).add(
                            UpdateEntry(widget.entryIndex, entry),
                          ),
                        );

                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

