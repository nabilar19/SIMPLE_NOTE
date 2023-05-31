import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_note/models/note.dart';
import 'package:simple_note/pages/add_node_page.dart';
import 'package:simple_note/pages/home_page.dart';

class AppRoutes {
  static const home = "home";
  static const AddNote = "add-note"; 
  static const EditNote = "edit-note"; 

  static Page _homePageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(
      child: HomePage(),
    );
  }

  static Page _addNotePageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(
      child: AddNotePage(),
    );
  }

   static Page _editNotePageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return MaterialPage(
      child: AddNotePage(note: state.extra as Note,),
    );
  }

  static GoRouter goRouter = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        name: home,
        path: "/",
        pageBuilder: _homePageBuilder,
        routes: [
          GoRoute(
            name:AddNote,
            path: "add-note",
            pageBuilder:_addNotePageBuilder,
            ),
            GoRoute(
            name:EditNote,
            path: "edit-note",
            pageBuilder:_editNotePageBuilder,
            )
        ]
      ),

    ],
  );
}
