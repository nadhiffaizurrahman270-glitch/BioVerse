import '../models/biology_topic.dart';
import 'api_service.dart';

class TopicService {
  final ApiService _apiService = ApiService();

  Future<List<BiologyTopic>> getAllTopics() async {
    try {
      return await _apiService.fetchMateri();
    } catch (e) {
      print('Error mengambil topik dari backend: $e');
      rethrow;
    }
  }
}