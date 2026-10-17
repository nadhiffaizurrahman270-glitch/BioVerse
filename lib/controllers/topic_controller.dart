import 'package:flutter/material.dart'; // Wajib ada ini
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
    }
    finally {
    isLoading = false;
    notifyListeners();
    }
  }
}