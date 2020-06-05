class Language {
  String code;
  String englishName;
  String localName;
  String flag;
  bool selected;

  Language(this.code, this.englishName, this.localName, this.flag, {this.selected = false});
}

class LanguagesList {
  List<Language> _languages;

  LanguagesList() {
    this._languages = [
      new Language("en", "English", "English", "assets/img/united-states-of-america.png"),
      new Language("ar", "Arabic", "العربية", "assets/img/united-arab-emirates.png"),
      new Language("es", "Spanish", "Spana", "assets/img/spain.png"),
      new Language("fr", "French (France)", "Français - France", "assets/img/france.png"),
      new Language("fr", "French (Canada)", "Français - Canadien", "assets/img/canada.png"),
      new Language("pr", "Brazilian", "Brazilian", "assets/img/brazil.png"),
      new Language("ko", "Korean", "Korean", "assets/img/united-states-of-america.png"),
    ];
  }

  List<Language> get languages => _languages;
}
