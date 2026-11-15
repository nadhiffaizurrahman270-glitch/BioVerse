import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import '../../services/avatar_storage.dart';
import 'crop_avatar_page.dart';

class ChooseAvatarPage extends StatefulWidget {
  final int initialAvatarIndex;

  const ChooseAvatarPage({
    super.key,
    this.initialAvatarIndex = 0,
  });

  @override
  State<ChooseAvatarPage> createState() => _ChooseAvatarPageState();
}

class _ChooseAvatarPageState extends State<ChooseAvatarPage> {
  static const Color primaryGreen = Color(0xFF166534);
  static const Color darkGreen = Color(0xFF14532D);
  static const Color backgroundGreen = Color(0xFFF0FDF4);

  late int selectedAvatarIndex;

  // Foto custom hasil crop (null = pakai avatar bawaan).
  Uint8List? _customPhoto;
  bool _saving = false;
  final ImagePicker _picker = ImagePicker();

  final List<String> avatarPaths = List.generate(
    7,
    (index) => 'assets/image/avatars/avatar_${index + 1}.png',
  );

  @override
  void initState() {
    super.initState();

    selectedAvatarIndex = widget.initialAvatarIndex
        .clamp(0, avatarPaths.length - 1);

    _loadCustomPhoto();
  }

  Future<void> _loadCustomPhoto() async {
    final bytes = await AvatarStorage.load();
    if (!mounted || bytes == null) return;
    setState(() => _customPhoto = bytes);
  }

  // Pilih foto dari galeri/kamera -> crop 1:1 -> jadikan avatar.
  Future<void> _pickAndCropPhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;

      final cropped = await Navigator.push<Uint8List>(
        context,
        MaterialPageRoute(
          builder: (_) => CropAvatarPage(imageBytes: bytes),
        ),
      );

      if (!mounted || cropped == null) return;
      setState(() => _customPhoto = cropped);
    } catch (e) {
      debugPrint('Gagal memilih foto: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka foto.')),
      );
    }
  }

  void _showPhotoSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari galeri'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickAndCropPhoto(ImageSource.gallery);
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Ambil foto'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickAndCropPhoto(ImageSource.camera);
                },
              ),
            if (_customPhoto != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Hapus foto'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  setState(() => _customPhoto = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirm() async {
    setState(() => _saving = true);
    try {
      if (_customPhoto != null) {
        await AvatarStorage.save(_customPhoto!);
      } else {
        await AvatarStorage.clear();
      }
      if (!mounted) return;
      Navigator.pop(context, selectedAvatarIndex);
    } catch (e) {
      debugPrint('Gagal menyimpan avatar: $e');
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan avatar.')),
      );
    }
  }

  Widget buildAvatarImage(int index) {
    return Image.asset(
      avatarPaths[index],
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 38,
            color: Colors.redAccent,
          ),
        );
      },
    );
  }

  Widget buildPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryGreen,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withValues(alpha: 0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: _customPhoto != null
                ? Image.memory(
                    _customPhoto!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : buildAvatarImage(selectedAvatarIndex),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Selected Avatar',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _customPhoto != null
              ? 'Foto kamu'
              : 'Avatar ${selectedAvatarIndex + 1}',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Choose the character that represents you in BioVerse.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget buildAvatarSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Character',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select one of the avatars below.',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
        
        const SizedBox(height: 14),

        OutlinedButton.icon(
          onPressed: _saving ? null : _showPhotoSourceSheet,
          icon: const Icon(Icons.add_a_photo_outlined),
          label: Text(
            _customPhoto != null ? 'Ganti Foto' : 'Upload Foto Sendiri',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryGreen,
            side: const BorderSide(color: primaryGreen),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(
              right: 6,
              bottom: 8,
            ),
            itemCount: avatarPaths.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final isSelected =
                  _customPhoto == null && selectedAvatarIndex == index;

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    selectedAvatarIndex = index;
                    _customPhoto = null; // pilih bawaan = lepas foto custom
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? primaryGreen
                          : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: buildAvatarImage(index),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Avatar ${index + 1}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: primaryGreen,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.check_circle,
                              size: 15,
                              color: primaryGreen,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildContent(bool isWide) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(
                  flex: 5,
                  child: buildPreview(),
                ),
                const SizedBox(width: 32),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: const Color(0xFFE5E7EB),
                ),
                const SizedBox(width: 28),
                Expanded(
                  flex: 6,
                  child: buildAvatarSelector(),
                ),
              ],
            )
          : Column(
              children: [
                buildPreview(),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),
                Expanded(
                  child: buildAvatarSelector(),
                ),
              ],
            ),
    );
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
          'Choose Your Avatar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 750;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: buildContent(isWide),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _confirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Confirm Avatar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}