import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Organizador Pessoal',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class Tarefa {
  String titulo;
  bool concluida;

  Tarefa(this.titulo, {this.concluida = false});
}

class MyAppState extends ChangeNotifier {
  List<Tarefa> tarefas = [
    Tarefa('Estudar Flutter'),
    Tarefa('Beber água'),
    Tarefa('Organizar o quarto'),
  ];

  void alternarTarefa(int index) {
    tarefas[index].concluida = !tarefas[index].concluida;
    notifyListeners();
  }

  void adicionarTarefa(String titulo) {
    tarefas.add(Tarefa(titulo));
    notifyListeners();
  }

  void removerTarefa(int index) {
    tarefas.removeAt(index);
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas de Hoje'),
        centerTitle: true,
      ),

      // BOTÃO +
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Nova tarefa'),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Digite a tarefa',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      controller.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        context
                            .read<MyAppState>()
                            .adicionarTarefa(controller.text);
                        controller.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Adicionar'),
                  ),
                ],
              );
            },
          );
        },
      ),

      body: ListView.builder(
        itemCount: appState.tarefas.length,
        itemBuilder: (context, index) {
          var tarefa = appState.tarefas[index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: CheckboxListTile(
              value: tarefa.concluida,
              onChanged: (value) {
                context.read<MyAppState>().alternarTarefa(index);
              },
              title: Text(
                tarefa.titulo,
                style: TextStyle(
                  fontSize: 18,
                  decoration: tarefa.concluida
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),

              secondary: IconButton(
                icon: Icon(Icons.delete, color: Colors.pink),
                onPressed: () {
                  context.read<MyAppState>().removerTarefa(index);
                },
              ),

              activeColor: Colors.pink,
            ),
          );
        },
      ),
    );
  }
}