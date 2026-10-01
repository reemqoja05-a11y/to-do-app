import '../../core/usecases/usecase.dart';
import '../../data/models/task_model.dart';
import '../repositories/task_repository.dart';

class UpdateTaskParams {
  final Task task;
  const UpdateTaskParams({required this.task});
}

class UpdateTaskUseCase implements UseCase<Task, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  @override
  Future<Task> call(UpdateTaskParams params) =>
      repository.updateTask(params.task);
}
