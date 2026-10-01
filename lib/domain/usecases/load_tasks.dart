import '../../core/usecases/usecase.dart';
import '../../data/models/task_model.dart';
import '../repositories/task_repository.dart';

class LoadTasksUseCase implements UseCase<List<Task>, NoParams> {
  final TaskRepository repository;

  LoadTasksUseCase(this.repository);

  @override
  Future<List<Task>> call(NoParams params) => repository.getTasks();
}
