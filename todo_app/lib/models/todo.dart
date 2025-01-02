class ToDo {
  String? id; // Identificador único da tarefa
  String? todoText; // Texto descritivo da tarefa
  bool isDone; // Indica se a tarefa foi concluída ou não

  // Construtor da classe ToDo
  ToDo({
    required this.id, // ID da tarefa
    required this.todoText, // Texto da tarefa
    this.isDone = false, // Tarefa não está concluída por padrão
  });

  // Método para converter a instância da classe ToDo em um mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Atribui o ID da tarefa
      'todoText': todoText, // Atribui o texto da tarefa
      'isDone': isDone, // Atribui o estado da tarefa (concluída ou não)
    };
  }

  // Método para criar uma instância da classe ToDo a partir de um mapa (JSON)
  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'], // Recupera o ID da tarefa
      todoText: json['todoText'], // Recupera o texto da tarefa
      isDone: json['isDone'], // Recupera o estado da tarefa
    );
  }
}
