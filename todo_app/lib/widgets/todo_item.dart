import 'package:flutter/material.dart';

import '../models/todo.dart'; // Importa o modelo ToDo
import '../constants/colors.dart'; // Importa as constantes de cores

class ToDoItem extends StatelessWidget {
  final ToDo todo; // Instância do objeto ToDo
  final Function(ToDo) onToDoChanged; // Função chamada ao marcar/desmarcar o ToDo
  final Function(String) onDeleteItem; // Função chamada ao excluir o ToDo
  final Function(String) onEditItem; // Função chamada ao editar o ToDo

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20), // Margem inferior para espaçar os itens
      child: ListTile(
        onTap: () {
          onToDoChanged(todo); // Chama a função de mudança de estado quando o item é clicado
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bordas arredondadas para o item
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Padding interno para espaçar o conteúdo
        tileColor: Colors.white, // Cor de fundo do item
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank, // Ícone de checkbox com base no status
          color: tdBlue, // Cor do ícone de checkbox
        ),
        title: Text(
          todo.todoText!, // Exibe o texto da tarefa
          style: TextStyle(
            fontSize: 16, // Tamanho da fonte
            color: tdBlack, // Cor do texto
            decoration: todo.isDone ? TextDecoration.lineThrough : null, // Risca o texto se a tarefa estiver concluída
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Faz com que os botões fiquem na extremidade direita
          children: [
            // Botão de edição
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.green, // Cor de fundo do botão de edição
                borderRadius: BorderRadius.circular(5), // Bordas arredondadas
              ),
              child: IconButton(
                color: Colors.white, // Cor do ícone
                iconSize: 18, // Tamanho do ícone
                icon: Icon(Icons.edit), // Ícone de edição
                onPressed: () {
                  if (todo.id != null) {
                    onEditItem(todo.id!); // Chama a função de edição passando o ID da tarefa
                  }
                },
              ),
            ),
            // Botão de exclusão
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: tdRed, // Cor de fundo do botão de exclusão
                borderRadius: BorderRadius.circular(5), // Bordas arredondadas
              ),
              child: IconButton(
                color: Colors.white, // Cor do ícone
                iconSize: 18, // Tamanho do ícone
                icon: Icon(Icons.delete), // Ícone de exclusão
                onPressed: () {
                  if (todo.id != null) {
                    onDeleteItem(todo.id!); // Chama a função de exclusão passando o ID da tarefa
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
