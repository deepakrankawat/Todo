import 'package:equatable/equatable.dart';
import 'package:todo/data/todo.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final List<Todo> todo;
  final TodoStatus status;

  const TodoState({
    this.todo = const <Todo>[],
    this.status = TodoStatus.initial,
  });

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
  }) {
    return TodoState(
      todo: todos ?? this.todo,
      status: status ?? this.status,
    );
  }

  @override
  factory TodoState.fromJson(Map<String, dynamic> json) {
    try {
      var listofTodos = (json['todo'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();

      return TodoState(
          todo: listofTodos,
          status: TodoStatus.values.firstWhere(
              (element) => element.name.toString() == json['status']));
    } catch (e) {
      rethrow;
    }
  }
  Map<String, dynamic> fromJson() {
    return {'todo': todo, 'status': status.name};
  }

  @override
  List<Object?> get props => [todo, status];
}
