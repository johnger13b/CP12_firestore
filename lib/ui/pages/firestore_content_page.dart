import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mintic_un_todo_core/domain/models/to_do.dart';
import 'package:misiontic_todo/data/repositories/database.dart';
import 'package:misiontic_todo/ui/controllers/database.dart';

class FirestoreContentPage extends StatefulWidget {
  const FirestoreContentPage({Key? key}) : super(key: key);

  @override
  createState() => _State();
}

class _State extends State<FirestoreContentPage> {
  late TextEditingController _textController;
  late DatabaseController controller;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    controller = Get.find();
    // TO DO: Agrega un listener al stream del controlador y actualiza la vista.
    controller.toDoStream.listen((data) {
      setState(() {
        controller.toDos = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de controller.toDos"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: "Nuevo To-Do",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final toDo = ToDo(content: _textController.text);
                        // TO DO: Guarda el todo en la base de datos usando el controlador, no actualices el estado.
                        controller.saveToDo(data: toDo).then((_) {
                          _textController.clear();
                        });
                      },
                      child: const Text("Aceptar"))
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: controller.toDos.length,
                    itemBuilder: (ontext, index) {
                      final toDo = controller.toDos[index];
                      return ListTile(
                        leading: AbsorbPointer(
                          absorbing: toDo.completed,
                          child: IconButton(
                            icon: Icon(
                              toDo.completed
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color:
                                  toDo.completed ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              toDo.completed = true;
                              // TO DO: Actualiza el todo en la base de datos usando el controlador, no actualices el estado.
                              controller.updateToDo(data: toDo);
                            },
                          ),
                        ),
                        title: Text(toDo.content),
                        trailing: IconButton(
                          onPressed: () {
                            // TO DO: Elimida el todo de la base de datos usando el controlador, no actualices el estado.
                            controller.deleteToDo(uuid: toDo.uuid);
                          },
                          icon: const Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete_sweep_rounded),
        onPressed: () {
          // TO DO: Elimida todos los ToDO de la base de datos usando el controlador, no actualices el estado.
          controller.clear(controller.toDos);
        },
      ),
    );
  }
}
