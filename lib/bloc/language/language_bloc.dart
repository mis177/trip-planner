import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:tripplanner/bloc/language/language_event.dart';
import 'package:tripplanner/bloc/language/language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial(localeName: Platform.localeName.split('_').first)) {
    on<ChangeLanguage>((event, emit) {
      emit(LanguageChanged(localeName: event.localeName));
    });
  }
}
