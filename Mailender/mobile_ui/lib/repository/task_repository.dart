import 'package:mobile_ui/database/database_helper.dart';
import 'package:mobile_ui/model/task.dart';
import 'package:mobile_ui/services/task_service.dart';


class TaskRepository {
  final DatabaseHelper _databaseHelper;
  final TaskService _eventService;


  TaskRepository(this._databaseHelper, this._eventService);

  Future<List<Task>> fetchLocalTasks() async {
    return await _databaseHelper.tasks();
  }

  Future<void> addTasks(Task event) async {
    await _databaseHelper.insertEvent(event);
  }

  Future<void> markTaskAsDeleted(String eventId) async {
    await _databaseHelper.markTaskAsDeleted(eventId);
  }
  Future<void> markTaskAsUpdated(String eventId) async {
    await _databaseHelper.markTaskAsUpdated(eventId);
  }

  Future<void> updateTask(Task event) async {
    await _databaseHelper.updateTasks(event);

  }


  Future<void> deleteTask(String eventId) async {
    await _databaseHelper.deleteTasks(eventId);
  }

  Future<void> syncTasks() async {
    final unsyncedTasks = await _databaseHelper.getUnsyncedTasks();
    final deletedTasks = await _databaseHelper.getDeletedTasks();
    final updatedTasks = await _databaseHelper.getUpdatedTasks(); // Fetch updated events

    // Sync unsynced events to the server
    for (final event in unsyncedTasks) {
      try {
        await _eventService.createTasks(event);
        await _databaseHelper.markTaskAsSynced(event.id);
      } catch (e) {
        print('Error syncing event ${event.id}: $e');
      }
    }

    // Sync updated events to the server
    for (final event in updatedTasks) {
      try {
        await _eventService.updateTasks(event.id, event); // Update the event on the server
        await _databaseHelper.markTaskAsSynced(event.id); // Mark the event as synced locally
      } catch (e) {
        print('Error updating event ${event.id}: $e');
      }
    }

    // Sync deleted events to the server
    for (final event in deletedTasks) {
      try {
        await _eventService.deleteTasks(event.id);
        await _databaseHelper.deleteTasks(event.id); // Remove the event from the local database
      } catch (e) {
        print('Error deleting event ${event.id}: $e');
      }
    }
  }

    Future<bool> isServerReachable() async {
      bool _isServerReackable = await _eventService.checkServerHealth();
      // Implement a simple request to check server connectivity
      return _isServerReackable;
    }

    Future<List<Task>> fetchRemoteTasks() async {
      return await _eventService.fetchTasks();
    }
}
