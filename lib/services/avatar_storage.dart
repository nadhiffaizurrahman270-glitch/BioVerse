import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan foto avatar custom (hasil crop) secara lokal.
class AvatarStorage {
  static const String _key = 'custom_avatar_base64';
  static const int _size = 512;

  /// Kecilkan ke maks 512x512 lalu encode JPEG supaya ringan disimpan.
  static Uint8List _compress(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return bytes;

    final resized = decoded.width > _size
        ? img.copyResize(decoded, width: _size, height: _size)
        : decoded;

    return Uint8List.fromList(img.encodeJpg(resized, quality: 88));
  }

  static Future<void> save(Uint8List croppedBytes) async {
    final compressed = await compute(_compress, croppedBytes);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, base64Encode(compressed));
  }

  static Future<Uint8List?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null || data.isEmpty) return null;

    try {
      return base64Decode(data);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
