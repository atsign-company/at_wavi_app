import 'package:at_wavi_app/view_models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'error_dialog.dart';
import 'loading_widget.dart';

Future providerCallback<T extends BaseModel>(BuildContext context,
    {required final Function(T) task,
    required final String Function(T) taskName,
    required Function(T) onSuccess,
    bool showDialog = true,
    bool showLoader = true,
    String? text,
    Function? onErrorHandeling,
    Function? onError}) async {
  final provider = Provider.of<T>(context, listen: false);
  var taskName0 = taskName(provider);

  if (showLoader) LoadingDialog().show(text: text);
  await Future.microtask(() => task(provider));
  if (showLoader) LoadingDialog().hide();
  print(
      'status before=====>_provider.status[_taskName]====>${provider.status[taskName0]}');
  if (provider.status[taskName0] == Status.Error) {
    if (showDialog) {
      ErrorDialog().show(
        provider.error[taskName0].toString(),
        context: context,
        onButtonPressed: onErrorHandeling,
      );
    }

    if (onError != null) onError(provider);

    provider.reset(taskName0);
    print(
        'status before=====>_provider.status[_taskName]====>${provider.status[taskName0]}');
  } else if (provider.status[taskName0] == Status.Done) {
    onSuccess(provider);
  }
}
