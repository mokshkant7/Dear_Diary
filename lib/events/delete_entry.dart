import 'entry_event.dart';

class DeleteEntry extends EntryEvent {
  int entryIndex;

  DeleteEntry(int index) {
    entryIndex = index;
  }
}