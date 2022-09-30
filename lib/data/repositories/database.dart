import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mintic_un_todo_core/data/entities/to_do.dart';
import 'package:mintic_un_todo_core/domain/models/to_do.dart';

class FirestoreDatabase {
  // ToDoEntity: Entidad del modelo ToDo - .fromRecord(): convierte un Map a un ToDo;

  CollectionReference<Map<String, dynamic>>
      // TO DO:  Crea una referencia a la coleccion 'to-do_list';
      get database => FirebaseFirestore.instance.collection('to-do_list');

  Stream<List<ToDo>> get toDoStream {
    return database.snapshots().map((event) {
      // TO DO: Usando ToDoEntity y .map() convierte los documents en event a ToDos
      return event.docs
          .map((records) => ToDoEntity.fromRecord(records.data()))
          .toList();
    });
  }

  Future<void> delete({required String uuid}) async {
    // TO DO: Usando database crea una referencia a uuid y eliminala.
    await database.doc(uuid).delete();
  }

  Future<void> save({required ToDo data}) async {
    // TO DO: Usando database crea una referencia a data.uuid y guardala.
    await database.doc(data.uuid).set(data.record);
  }

  Future<ToDo> read({required String uuid}) async {
    // TO DO: 1. Usando database crea una referencia a uuid y leela.
    final snapshot = await database.doc(uuid).get();
    // TO DO: 2. Convierte los datos en el snapshot a un ToDo;
    return ToDoEntity.fromRecord(snapshot.data()!);
  }

  Future<List<ToDo>> readAll() async {
    final snapshot = await database.get();
    // TO DO: Usando ToDoEntity y .map() convierte los documents en snapshot a ToDos
    return snapshot.docs
        .map((records) => ToDoEntity.fromRecord(records.data()))
        .toList();
  }

  Future<void> clear({required List<ToDo> toDos}) async {
    // TO DO: Usando la lista de toDos, database y for_in , crea una referencia a cada documento y eliminala.
    for (var todo in toDos) {
      await database.doc(todo.uuid).delete();
    }
  }

  Future<void> update({required ToDo data}) async {
    // TO DO: Usando database crea una referencia a data.uuid y actualizala.
    await database.doc(data.uuid).update(data.record);
  }
}
