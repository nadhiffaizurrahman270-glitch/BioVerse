import 'package:flutter/material.dart';
import '../models/biology_topic.dart';
import '../services/topic_service.dart';

class TopicController extends ChangeNotifier {
  final TopicService _topicService = TopicService();

  List<BiologyTopic> topics = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchTopics() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      topics = await _topicService.getAllTopics();
      print('Topik berhasil dimuat: ${topics.length}');
    } catch (e) {
      errorMessage = e.toString();
      print("Gagal mengambil topik: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method penunjang untuk dipanggil FutureBuilder di dashboard_page.dart
  Future<List<BiologyTopic>> getTopics() async {
    await fetchTopics();
    return topics;
  }
}