import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/biology_topic.dart';
import '../services/ai_tutor_service.dart'; // 1. Import Service AI Tutor

class MateriScreen extends StatefulWidget {
  const MateriScreen({Key? key}) : super(key: key);

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<BiologyTopic>> _materiFuture;

  @override
  void initState() {
    super.initState();
    _materiFuture = _apiService.fetchMateri();
  }

  // 2. Fungsi untuk menampilkan Dialog Pop-up BioBot AI Tutor
  void _showAITutorBottomSheet(BuildContext context) {
    final TextEditingController _tanyaController = TextEditingController();
    String _jawabanAI = '';
    bool _isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.smart_toy, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Tanya BioBot (AI Tutor)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tanyaController,
                    decoration: InputDecoration(
                      hintText: 'Misal: Apa perbedaan sel hewan dan tumbuhan?',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.teal),
                        onPressed: () async {
                          if (_tanyaController.text.isEmpty) return;

                          setModalState(() {
                            _isLoading = true;
                            _jawabanAI = '';
                          });

                          // Panggil endpoint FastAPI Gemini
                          String hasil = await AITutorService.askBioBot(_tanyaController.text);

                          setModalState(() {
                            _jawabanAI = hasil;
                            _isLoading = false;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_jawabanAI.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _jawabanAI,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi BioVerse'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<BiologyTopic>>(
        future: _materiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada materi.'));
          }

          final listMateri = snapshot.data!;
          return ListView.builder(
            itemCount: listMateri.length,
            itemBuilder: (context, index) {
              final item = listMateri[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.category),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Logika saat materi diklik
                  },
                ),
              );
            },
          );
        },
      ),
      // 3. Tambahkan Tombol Floating di Pojok Kanan Bawah
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAITutorBottomSheet(context),
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.smart_toy),
        label: const Text('Tanya AI'),
      ),
    );
  }
}