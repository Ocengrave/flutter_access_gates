enum AppFeature {
  darkMode,
  betaScreen,
  enableChat,
}

extension AppFeatureLabel on AppFeature {
  String get label {
    switch (this) {
      case AppFeature.darkMode:
        return 'Dark Mode';
      case AppFeature.betaScreen:
        return 'Show Beta screen tile';
      case AppFeature.enableChat:
        return 'Chat is available';
    }
  }
}
