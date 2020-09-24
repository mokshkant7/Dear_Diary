import 'package:diary_app/model/entry.dart';

import 'entry_event.dart';

class AddEntry extends EntryEvent {
  Entry newEntry;

  AddEntry(Entry entry) {
    newEntry = entry;
  }
}