import 'package:trailya/services/visits_store.dart';
import 'package:workmanager/workmanager.dart';

const visitsCleanupTask = 'visitsCleanupTask';

Future<void> scheduleBackgroundJob() async {
  final manager = Workmanager();
  await manager.initialize(callbackDispatcher);
  return await manager.registerPeriodicTask(
    '1',
    visitsCleanupTask,
    frequency: Duration(days: 1),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case visitsCleanupTask:
        return await _cleanupPastVisits();
      default:
        return Future.error('Unknown background task submitted: $task');
    }
  });
}

Future<bool> _cleanupPastVisits() async {
  final store = await VisitsStore.create();

  final threshold = DateTime.now().subtract(Duration(days: 15));
  final deleted = await store.deleteBefore(threshold);
  print('No. of visits deleted: $deleted');

  return Future.value(true);
}
