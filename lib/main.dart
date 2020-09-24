import 'package:diary_app/UI/entry_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/entry_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EntryBloc>(
      create: (context) => EntryBloc(),
      child: MaterialApp(
        title: 'Personal Diary',
//        theme: ThemeData(
//          primarySwatch: Colors.deepPurple,
//        ),
        home: EntryList(),
      ),
    );
  }
}