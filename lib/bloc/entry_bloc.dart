import 'package:diary_app/events/add_entry.dart';
import 'package:diary_app/events/delete_entry.dart';
import 'package:diary_app/events/entry_event.dart';
import 'package:diary_app/events/set_entries.dart';
import 'package:diary_app/events/update_entry.dart';
import 'package:diary_app/model/entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntryBloc extends Bloc<EntryEvent, List<Entry>> {
  @override
  List<Entry> get initialState => List<Entry>();

  @override
  Stream<List<Entry>> mapEventToState(EntryEvent event) async* {
    if (event is SetEntries) {
      yield event.entryList;
    } else if (event is AddEntry) {
      List<Entry> newState = List.from(state);
      if (event.newEntry != null) {
        newState.add(event.newEntry);
      }
      yield newState;
    } else if (event is DeleteEntry) {
      List<Entry> newState = List.from(state);
      newState.removeAt(event.entryIndex);
      yield newState;
    } else if (event is UpdateEntry) {
      List<Entry> newState = List.from(state);
      newState[event.entryIndex] = event.newEntry;
      yield newState;
    }
  }
}