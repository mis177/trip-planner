import 'package:equatable/equatable.dart';

sealed class LanguageState extends Equatable {
  final String localeName;
  const LanguageState({required this.localeName});
  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial({required super.localeName});
  @override
  List<Object?> get props => [localeName];
}

class LanguageChanged extends LanguageState {
  const LanguageChanged({required super.localeName});
  @override
  List<Object?> get props => [localeName];
}
