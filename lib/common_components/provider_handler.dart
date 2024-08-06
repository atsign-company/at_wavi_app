/// This is a custom widget to handle states from view models
/// This takes in a [functionName] as a String to render only function which is called,
/// a [successBuilder] which tells what to render is status is [Status.Done]
/// [Status.Loading] renders a CircularProgressIndicator whereas
/// [Status.Error] renders [errorBuilder]

import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_wavi_app/view_models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'error_dialog.dart';

class ProviderHandler<T extends BaseModel> extends StatelessWidget {
  final Widget Function(T) successBuilder;
  final Widget Function(T)? errorBuilder;
  final Widget? Function(T)? loaderBuilder;
  final String functionName;
  final bool showError;
  final Function(T) load;

  const ProviderHandler(
      {Key? key,
      required this.successBuilder,
      this.errorBuilder,
      required this.functionName,
      required this.showError,
      this.loaderBuilder,
      required this.load})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(builder: (context, provider, __) {
      print(
          '_provider?.status[functionName]=====>${provider.status[functionName]}========>$functionName=======>before');
      if (provider.status[functionName] == Status.Loading) {
        return loaderBuilder!(provider) ??
            Center(
              child: SizedBox(
                height: 50.toHeight,
                width: 50.toHeight,
                child: const CircularProgressIndicator(),
              ),
            );
      } else if (provider.status[functionName] == Status.Error) {
        print('_provider?.status[functionName]=====>${provider.status[functionName]}========>$functionName');
        if (showError) {
          print('IN SHOW ERROR');
          ErrorDialog().show(provider.error[functionName].toString(), context: context);
          provider.reset(functionName);
          return const SizedBox();
        } else {
          provider.reset(functionName);
          return errorBuilder!(provider);
        }
      } else if (provider.status[functionName] == Status.Done) {
        return successBuilder(provider);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await load(provider);
        });
        return Center(
          child: SizedBox(
            height: 50.toHeight,
            width: 50.toHeight,
            child: const CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
