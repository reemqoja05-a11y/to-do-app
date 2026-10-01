import '../../core/usecases/usecase.dart';
import '../../data/models/task_model.dart';
import '../repositories/task_repository.dart';

class AddTaskParams {
  final Task task;
  const AddTaskParams({required this.task});
}

class AddTaskUseCase implements UseCase<Task, AddTaskParams> {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  @override
  Future<Task> call(AddTaskParams params) => repository.addTask(params.task);
}
