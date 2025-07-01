import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/utils/extensions/string_extension.dart';

class BlocStateObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (kDebugMode) {
      final logMessage = StringBuffer()
        ..writeln('Bloc: ${bloc.runtimeType}')
        ..writeln('Event: ${event.runtimeType}')
        ..write('Details: ${event?.toString().limit(200)}');
      log(logMessage.toString());
    }
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      final logMessage = StringBuffer()
        ..writeln('Bloc: ${bloc.runtimeType}')
        ..writeln(error.toString());
      log(
        logMessage.toString(),
        error: error,
        stackTrace: stackTrace,
      );
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      final logMessage = StringBuffer()
        ..writeln('Bloc: ${bloc.runtimeType}')
        ..writeln('Event: ${transition.event.runtimeType}')
        ..writeln('Transition: ${transition.currentState.runtimeType} => '
            '${transition.nextState.runtimeType}')
        ..write('New State: ${transition.nextState}');

      log(logMessage.toString());
    }
    super.onTransition(bloc, transition);
  }
}
