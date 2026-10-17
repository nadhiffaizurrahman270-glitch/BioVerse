import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/biology_topic.dart';

class TopicService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<List<BiologyTopic>> getAllTopics() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('topics').get();

      print('Jumlah dokumen topik: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        return BiologyTopic.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error mengambil topik: $e');
      rethrow;
    }
  }
}