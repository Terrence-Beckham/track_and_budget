import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
class AppBlocObserver extends BlocObserver {
   AppBlocObserver();
  final _logger = Logger();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.f('onChange(${bloc.runtimeType}, $change)');
  }

   @override
   void onTransition(Bloc bloc, Transition transition) {
     super.onTransition(bloc, transition);
     _logger.f(transition);
   }

   @override
   void onEvent(Bloc bloc, Object? event) {
     super.onEvent(bloc, event);
     _logger.f(event);
   }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.f('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}


