import 'package:equatable/equatable.dart';
import 'package:expenses/auth_user/models/auth_state.dart';
import 'package:expenses/entry/entry_model/entries_state.dart';
import 'package:expenses/log/log_model/logs_state.dart';
import 'package:expenses/login_register/login_register_model/login_reg_state.dart';
import 'package:expenses/settings/settings_model/settings_state.dart';
import 'package:expenses/tags/tag_model/selected_tag_state.dart';

import 'package:meta/meta.dart';

@immutable
class AppState extends Equatable {
  final AuthState authState;
  final LoginRegState loginRegState;
  final LogsState logsState;
  final EntriesState entriesState;
  final SettingsState settingsState;
  final SelectedTagState selectedTagState;

  AppState(
      {@required this.authState,
      @required this.loginRegState,
      @required this.logsState,
      @required this.entriesState,
      @required this.settingsState,
      @required this.selectedTagState});

  AppState copyWith({
    AuthState authState,
    LoginRegState loginState,
    LogsState logsState,
    EntriesState entriesState,
    SettingsState settingsState,
    SelectedTagState selectedTagState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      loginRegState: loginState ?? this.loginRegState,
      logsState: logsState ?? this.logsState,
      entriesState: entriesState ?? this.entriesState,
      settingsState: settingsState ?? this.settingsState,
      selectedTagState: selectedTagState ?? this.selectedTagState,
    );
  }

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      loginRegState: LoginRegState.initial(),
      logsState: LogsState.initial(),
      entriesState: EntriesState.initial(),
      settingsState: SettingsState.initial(),
      selectedTagState: SelectedTagState.initial(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props =>
      [authState, loginRegState, logsState, entriesState, settingsState, selectedTagState];
}
