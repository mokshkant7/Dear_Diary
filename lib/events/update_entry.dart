import 'package:diary_app/model/entry.dart';

import 'entry_event.dart';

class UpdateEntry extends EntryEvent {
  Entry newEntry;
  int entryIndex;

  UpdateEntry(int index, Entry entry) {
    newEntry = entry;
    entryIndex = index;
  }
}