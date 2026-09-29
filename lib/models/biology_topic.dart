class BiologyTopic {
  String _title;
  String _description;
  String _category;
  String _level;
  String _content;

  BiologyTopic({
    required String title,
    required String description,
    required String category,
    required String level,
    required String content,
  })  : _title = title,
        _description = description,
        _category = category,
        _level = level,
        _content = content;

  // Getter
  String get title => _title;
  String get description => _description;
  String get category => _category;
  String get level => _level;
  String get content => _content;

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

  set content(String value) {
    _content = value;
  }

  // Function
  String getTopicInfo() {
    return '$_title - $_category - Level: $_level';
  }
}