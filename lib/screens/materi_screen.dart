import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/biology_topic.dart';
import '../services/ai_tutor_service.dart'; // 1. Import Service AI Tutor
import 'package:shimmer/shimmer.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

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

  // Memuat ulang daftar materi (mis. setelah backend sempat 503).
  void _reload() {
    setState(() {
      _materiFuture = _apiService.fetchMateri();
    });
  }

  // 2. Fungsi untuk menampilkan Dialog Pop-up BioBot AI Tutor
  void _showAITutorBottomSheet(BuildContext context) {
    final TextEditingController tanyaController = TextEditingController();
    String jawabanAI = '';
    bool isLoading = false;

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
                    controller: tanyaController,
                    decoration: InputDecoration(
                      hintText: 'Misal: Apa perbedaan sel hewan dan tumbuhan?',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.teal),
                        onPressed: () async {
                          if (tanyaController.text.isEmpty) return;

                          setModalState(() {
                            isLoading = true;
                            jawabanAI = '';
                          });

                          // Panggil endpoint FastAPI Gemini
                          String hasil;
                          try {
                            hasil = await AITutorService.askBioBot(
                              tanyaController.text,
                            );
                          } catch (error) {
                            hasil = 'Gagal menghubungi BioBot: $error';
                          }

                          setModalState(() {
                            jawabanAI = hasil;
                            isLoading = false;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (jawabanAI.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        jawabanAI,
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
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          );
        }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 56, color: Colors.teal),
                    const SizedBox(height: 12),
                    const Text(
                      'Materi belum bisa dimuat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pastikan backend BioVerse sedang berjalan, lalu coba lagi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }
          final listMateri = snapshot.data ?? const <BiologyTopic>[];
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