// ignore_for_file: unnecessary_getters_setters, prefer_initializing_formals

class BiologyTopic {
  String _title;
  String _description;
  String _category;
  String _level;

  BiologyTopic({
    required String title,
    required String description,
    required String category,
    required String level,
    
  })  : _title = title,
        _description = description,
        _category = category,
        _level = level;

  // Getter
  String get title => _title;
  String get description => _description;
  String get category => _category;
  String get level => _level;

  // Setter
  set title(String value) {
    _title = value;
  }

  set description(String value) {
    _description = value;
  }

  set category(String value) {
    _category = value;
  }

  set level(String value) {
    _level = value;
  }

  // Function
  String getTopicInfo() {
    return '$_title - $_category - Level: $_level';
  }
}