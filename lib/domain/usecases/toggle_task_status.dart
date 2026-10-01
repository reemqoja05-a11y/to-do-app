import '../../core/usecases/usecase.dart';
import '../../data/models/task_model.dart';
import '../repositories/task_repository.dart';

class ToggleTaskStatusParams {
  final String id;
  final bool isCompleted;
  const ToggleTaskStatusParams({required this.id, required this.isCompleted});
}

class ToggleTaskStatusUseCase implements UseCase<Task, ToggleTaskStatusParams> {
  final TaskRepository repository;

  ToggleTaskStatusUseCase(this.repository);

  @override
  Future<Task> call(ToggleTaskStatusParams params) =>
      repository.toggleTaskStatus(params.id, params.isCompleted);
}
