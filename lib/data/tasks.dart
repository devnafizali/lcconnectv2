import 'package:connectivity/connectivity.dart';

class TaskQueue {
  List<Function> _tasks = [];
  bool _isConnected = true;

  TaskQueue() {
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void addTask(Function task) {
    if (_isConnected) {
      task();
    } else {
      _tasks.add(task);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _isConnected = false;
    } else {
      _isConnected = true;
      _executeTasks();
    }
  }

  void _executeTasks() {
    _tasks.forEach((task) => task());
    _tasks.clear();
  }
}
