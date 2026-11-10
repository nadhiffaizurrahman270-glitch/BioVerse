class BiologyTopic {
  final dynamic id; 
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

  // Factory untuk membaca JSON dari FastAPI Backend
  factory BiologyTopic.fromJson(Map<String, dynamic> json) {
  return BiologyTopic(
    id: json['id'],
    title: json['title'] ?? json['judul'] ?? 'Judul Tidak Ada',
    description: json['description'] ?? json['deskripsi'] ?? 'Deskripsi tidak tersedia',
    category: json['category'] ?? json['kategori'] ?? 'General',
    level: json['level'] ?? 'Beginner',
    content: json['content'] ?? json['konten'] ?? 'Materi belum tersedia',
    videoId: json['video_id'] ?? json['videoId'],
  );
}

  String getTopicInfo() {
    return '$title\n$category Level: $level';
  }
}