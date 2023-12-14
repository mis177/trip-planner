import 'package:equatable/equatable.dart';

sealed class LanguageEvent extends Equatable {
  const LanguageEvent();
  @override
  List<Object?> get props => [];
}

class ChangeLanguage extends LanguageEvent {
  final String localeName;

  const ChangeLanguage({required this.localeName});
  @override
  List<Object?> get props => [localeName];
}
