import 'package:diary_app/model/entry.dart';

import 'entry_event.dart';

class SetEntries extends EntryEvent {
  List<Entry> entryList;

  SetEntries(List<Entry> entries) {
    entryList = entries;
  }
}