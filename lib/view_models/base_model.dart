import 'package:flutter/material.dart';

class BaseModel with ChangeNotifier {
  Map<String, Status> status = {'main': Status.Idle};
  Map<String, String?> error = {};
  // ignore: always_declare_return_types
setStatus(String function, Status statusValue) {
  status[function] = statusValue;
  notifyListeners();
}


setError(String function, String errorValue, [Status? statusValue]) {
  error[function] = errorValue;
  if (statusValue != null) {
    status[function] = statusValue;
  } else {
    status[function] = Status.Error;
  }
  notifyListeners();
}


  // ignore: always_declare_return_types
  reset(String function) {
    error.remove(function);
    status.remove(function);
  }
}

enum Status { Loading, Done, Error, Idle }
