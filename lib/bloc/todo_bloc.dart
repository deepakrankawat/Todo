import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:todo/bloc/todo_event.dart';
import 'package:todo/bloc/todo_state.dart';
import 'package:todo/data/todo.dart';

class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<TodoStarted>(_onStarted);
    on<AddTodo>(_onAddTodo);
    on<RemoveTodo>(_onRemoveTodo);
    on<AlterTodo>(_onAlterTodo);
  }

  void _onStarted(
    TodoStarted event,
    Emitter<TodoState> emit,
  ) {
    if (state.status == TodoStatus.success) return;
    emit(state.copyWith(todos: state.todo, status: TodoStatus.success));
  }

  void _onAddTodo(
    AddTodo event,
    Emitter<TodoState> emit,
  ) {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      List<Todo> temp = [];
      temp.addAll(state.todo);
      temp.insert(0, event.todo);
      emit(state.copyWith(todos: temp, status: TodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  void _onRemoveTodo(
    RemoveTodo event,
    Emitter<TodoState> emit,
  ) {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      state.todo.remove(event.todo);
      emit(state.copyWith(todos: state.todo, status: TodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  void _onAlterTodo(
    AlterTodo event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(status: TodoStatus.loading),
    );
    try {
      state.todo[event.index].isDone = !state.todo[event.index].isDone;
      emit(state.copyWith(todos: state.todo, status: TodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    return TodoState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    return state.fromJson();
  }
}
