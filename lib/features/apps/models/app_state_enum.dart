enum AppState {not_installed, installed, new_version_available}

extension AppStateExtension on AppState {
  String get displayTitle {
    switch (this) {
      case AppState.not_installed:
        return 'Descargar';
      case AppState.installed:
        return 'Abrir';
      default:
        return 'Actualizar';
    }
  }
}