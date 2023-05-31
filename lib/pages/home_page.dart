import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/db/database_service.dart';
import 'package:simple_note/extentions/format_date.dart';
import 'package:simple_note/models/note.dart';
import 'package:simple_note/utils/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Note app"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).goNamed(
            AppRoutes.AddNote,
          );
        },
        child: const Icon(
          Icons.note_alt_rounded,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(DatabaseService.boxName).listenable(),
        builder: (context, box, child) {
          if (box.isEmpty) {
            return const Center(
              child: Text("Tidak ada catatan"),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(box.getAt(index).key.toString()),
                  child: NoteCard(
                    note: box.getAt(index),
                  ),
                  onDismissed: (_) async {
                    await dbService.deleteNote(box.getAt(index)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "${box.getAt(index).title} telah di hapus",
                        ),
                      ));
                    });
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 8,
              ),
              itemCount: box.length,
            );
          }
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white24),
      child: ListTile(
        onTap: () {
          GoRouter.of(context).pushNamed(AppRoutes.EditNote, extra: note);
        },
        title: Text(
          note.title,
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          note.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(note.createdat.formatDate()),
      ),
    );
  }
}
