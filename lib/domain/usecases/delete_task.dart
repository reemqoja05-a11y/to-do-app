import '../../core/usecases/usecase.dart';
import '../repositories/task_repository.dart';

class DeleteTaskParams {
  final String id;
  const DeleteTaskParams({required this.id});
}

class DeleteTaskUseCase implements UseCase<void, DeleteTaskParams> {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  @override
  Future<void> call(DeleteTaskParams params) =>
      repository.deleteTask(params.id);
}
