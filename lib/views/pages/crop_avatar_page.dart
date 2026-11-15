import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

/// Halaman crop foto profil (rasio 1:1, bentuk lingkaran).
/// Mengembalikan [Uint8List] hasil crop lewat Navigator.pop, atau null jika dibatalkan.
class CropAvatarPage extends StatefulWidget {
  final Uint8List imageBytes;

  const CropAvatarPage({super.key, required this.imageBytes});

  @override
  State<CropAvatarPage> createState() => _CropAvatarPageState();
}

class _CropAvatarPageState extends State<CropAvatarPage> {
  static const Color primaryGreen = Color(0xFF166534);
  static const Color backgroundGreen = Color(0xFFF0FDF4);

  final CropController _controller = CropController();
  bool _cropping = false;

  void _onCropped(CropResult result) {
    if (!mounted) return;

    switch (result) {
      case CropSuccess(:final croppedImage):
        Navigator.pop(context, croppedImage);
      case CropFailure(:final cause):
        setState(() => _cropping = false);
        debugPrint('Crop gagal: $cause');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memotong gambar. Coba lagi.')),
        );
    }
  }

  void _startCrop() {
    setState(() => _cropping = true);
    _controller.crop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryGreen,
        elevation: 0,
        title: const Text(
          'Crop Foto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Crop(
                    image: widget.imageBytes,
                    controller: _controller,
                    onCropped: _onCropped,
                    aspectRatio: 1,
                    withCircleUi: true,
                    baseColor: Colors.black,
                    maskColor: Colors.black.withValues(alpha: 0.55),
                    radius: 20,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Geser dan cubit untuk mengatur area foto.',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _cropping ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryGreen,
                        side: const BorderSide(color: primaryGreen),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _cropping ? null : _startCrop,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _cropping
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Pakai Foto Ini',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
