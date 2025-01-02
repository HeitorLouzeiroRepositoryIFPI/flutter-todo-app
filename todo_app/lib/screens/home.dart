import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para codificar e decodificar dados JSON
import '../models/todo.dart'; // Importa o modelo ToDo
import '../widgets/todo_item.dart'; // Importa o widget ToDoItem

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Lista que armazenará as tarefas filtradas ou todas as tarefas
  List<ToDo> _filteredOrAllTodos = [];
  // Controlador de texto para o campo de input
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToDoList(); // Carrega a lista de tarefas quando a tela é inicializada
  }

  // Carrega as tarefas salvas no SharedPreferences
  Future<void> _loadToDoList() async {
    try {
      final prefs = await SharedPreferences.getInstance(); // Obtém uma instância do SharedPreferences
      final String? todoListString = prefs.getString('todoList'); // Recupera a lista de tarefas como String

      if (todoListString != null) {
        // Se houver tarefas salvas, decodifica o JSON e as carrega
        final List<dynamic> todoListJson = json.decode(todoListString);
        setState(() {
          _filteredOrAllTodos = todoListJson.map((json) => ToDo.fromJson(json)).toList();
        });
      } else {
        // Se não houver tarefas salvas, inicializa com uma lista vazia
        setState(() {
          _filteredOrAllTodos = [];
        });
      }
    } catch (e) {
      // Caso ocorra um erro ao carregar os dados, exibe uma mensagem de erro
    }
  }

  // Salva a lista de tarefas no SharedPreferences
  Future<void> _saveToDoList() async {
    try {
      final prefs = await SharedPreferences.getInstance(); // Obtém a instância do SharedPreferences
      final List<Map<String, dynamic>> todoListJson = _filteredOrAllTodos.map((todo) => todo.toJson()).toList(); // Converte a lista de ToDos em JSON
      prefs.setString('todoList', json.encode(todoListJson)); // Salva a lista como uma String JSON
    } catch (e) {
      // Caso ocorra um erro ao salvar os dados, exibe uma mensagem de erro
    }
  }

  // Adiciona um novo item à lista de tarefas
  void _addToDoItem(String toDo) {
    if (toDo.trim().isEmpty) return; // Não adicionar tarefa vazia
    setState(() {
      _filteredOrAllTodos.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Gera um ID único baseado no tempo
        todoText: toDo,
      ));
    });
    _todoController.clear(); // Limpa o campo de texto
    _saveToDoList(); // Salva a lista de tarefas no SharedPreferences
  }

  // Exclui um item da lista de tarefas
  void _deleteToDoItem(String id) {
    setState(() {
      _filteredOrAllTodos.removeWhere((item) => item.id == id); // Remove o item com o ID correspondente
    });
    _saveToDoList(); // Salva a lista de tarefas no SharedPreferences
  }

  // Edita um item da lista de tarefas
  void _editToDoItem(String id) {
    final todo = _filteredOrAllTodos.firstWhere((item) => item.id == id); // Encontra o item pela ID
    final controller = TextEditingController(text: todo.todoText); // Inicializa o controlador com o texto atual

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'), // Título do dialog
          content: TextField(
            controller: controller, // Controlador de texto
            decoration: const InputDecoration(hintText: 'Edit your task'), // Placeholder
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog sem salvar
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todo.todoText = controller.text; // Atualiza o texto da tarefa
                });
                Navigator.of(context).pop(); // Fecha o dialog
                _saveToDoList(); // Salva a lista de tarefas no SharedPreferences
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List'), // Título do aplicativo
      ),
      body: Column(
        children: [
          // Campo de texto para adicionar novas tarefas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _todoController, // Controlador do campo de texto
              decoration: const InputDecoration(
                hintText: 'Add a new to-do item', // Texto que aparece quando o campo está vazio
              ),
              onSubmitted: (value) {
                _addToDoItem(value); // Adiciona o item quando o usuário pressionar "Enter"
              },
            ),
          ),
          // Exibe a lista de tarefas
          Expanded(
            child: ListView.builder(
              itemCount: _filteredOrAllTodos.length, // Número de itens na lista
              itemBuilder: (context, index) {
                final todo = _filteredOrAllTodos[index]; // Obtém o ToDo da lista
                return ToDoItem(
                  todo: todo, // Passa o ToDo para o widget ToDoItem
                  onToDoChanged: (updatedTodo) {
                    // Ação ao editar o ToDo (abre o dialog de edição)
                    if (todo.id != null) {
                      _editToDoItem(todo.id!);
                    }
                  },
                  onDeleteItem: (id) {
                    // Ação ao excluir o ToDo
                    _deleteToDoItem(id);
                  },
                  onEditItem: (id) {
                    // Ação ao editar o ToDo
                    _editToDoItem(id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
