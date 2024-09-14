import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ui/database/database_helper.dart';
import 'package:mobile_ui/model/task.dart';
import 'package:mobile_ui/repository/task_repository.dart';

class TaskProvider extends ChangeNotifier{
  final TaskRepository _eventRepository;

  final List<Task> _events = [];
  bool _isSyncing=false;

  TaskProvider(this._eventRepository){
    _loadEvents();
  }

  List<Task> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Task> get eventsOfSelectedDate => _events;

  Future<void> _loadEvents() async {
    _events.clear();
    final eventList = await _eventRepository.fetchLocalTasks();
    if(eventList.isEmpty){
      final eventsServer = await _eventRepository.fetchRemoteTasks();
      _events.addAll(eventsServer);
      notifyListeners();
    }else{// Load from DB
      _events.addAll(eventList);
      notifyListeners();
    }
  }
  Future<void> fetchTasksAfterLogin() async {
    await _loadEvents();
  }

  Future<void> addEvenet(Task event)async{
    await _eventRepository.addTasks(event);
    _events.add(event);
    notifyListeners();
    _syncWithServer();
  }

  Future<void> deleteEvent(Task event) async {
    await _eventRepository.markTaskAsDeleted(event.id); // Delete from DB
    _events.removeWhere((element) => element.id == event.id);
    notifyListeners();
    _syncWithServer();
  }

  Future<void> editEvent(Task newEvent, Task oldEvent) async {
    await _eventRepository.markTaskAsUpdated(newEvent.id);
    await _eventRepository.updateTask(newEvent); // Update in DB
    final index = _events.indexWhere((event) => event.id == oldEvent.id);
    if (index != -1) {
      _events[index] = newEvent;
      notifyListeners();
      _syncWithServer();
    }
  }

  Future<void> _syncWithServer() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection. Sync deferred.');
      return;
    }

    _isSyncing = true;
    notifyListeners();

    try {
      if (await _eventRepository.isServerReachable()) {
        await _eventRepository.syncTasks();
        await _loadEvents();
      } else {
        print('Server is not reachable. Sync deferred.');
      }
    } catch (e) {
      print('Error during sync: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }


}