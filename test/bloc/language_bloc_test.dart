import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tripplanner/bloc/language/language_bloc.dart';
import 'package:tripplanner/bloc/language/language_event.dart';
import 'package:tripplanner/bloc/language/language_state.dart';

void main() {
  group('language_bloc', () {
    late LanguageBloc languageBloc;

    setUp(() {
      languageBloc = LanguageBloc();
    });

    blocTest<LanguageBloc, LanguageState>(
      'setting language to english',
      build: () => languageBloc,
      act: (bloc) async {
        bloc.add(const ChangeLanguage(localeName: 'en'));
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const LanguageChanged(localeName: 'en'),
      ],
    );
  });
}
