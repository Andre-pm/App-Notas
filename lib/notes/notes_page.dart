import 'package:app_notes_notifier/notes/notes_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'note_model.dart';

final notesProvider =
    StateNotifierProvider<NotesNotifier, List<NoteModel>>((ref) {
  return NotesNotifier();
});

class NotesPage extends HookConsumerWidget {
  NotesPage({Key? key}) : super(key: key);
  final noteTitleController = TextEditingController();
  final noteDescController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Note title',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        controller: noteTitleController,
                      ),
                      TextFormField(
                        maxLines: 3,
                        minLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Note description',
                        ),
                        controller: noteDescController,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: notes.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(notes[index].title),
                          subtitle: Text(notes[index].description ?? ''),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              ref
                                  .read(notesProvider.notifier)
                                  .removeNote(notes[index]);
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(notesProvider.notifier).addNote(NoteModel(
                title: noteTitleController.text,
                description: noteDescController.text,
              ));
          noteTitleController.clear();
          noteDescController.clear();
        },
        child: const Icon(Icons.save_as_rounded, size: 35),
      ),
    );
  }
}
