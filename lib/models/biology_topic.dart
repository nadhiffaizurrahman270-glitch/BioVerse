class BiologyTopic {
  
  final String id; 
  final String title;
  final String description;
  final String category;
  final String level;
  final String content;
  final String? videoId;

  BiologyTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.content,
    this.videoId,
  });

  factory BiologyTopic.fromMap(Map<String, dynamic> map, String documentId) {
    return BiologyTopic(
      id: documentId,
      title: map['title'] ?? 'Judul Tidak Ada',
      description: map['description'] ?? 'Deskripsi tidak tersedia',

      category: map['category'] ?? map['tag'] ?? 'General', 
      level: map['level'] ?? 'Beginner',
      content: map['content'] ?? 'Materi belum tersedia',
      videoId: map['videoId'],
    );
  }

  String getTopicInfo() {
    return '$title\n$category Level: $level';
  }
}