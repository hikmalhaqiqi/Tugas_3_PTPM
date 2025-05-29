import 'dart:convert';
import 'package:tugas_3/models/clothing_model.dart';
import 'package:http/http.dart' as http;

class ClothingApi {
  static const url =
      "https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes";

  // Ambil semua pakaian
  static Future<Map<String, dynamic>> getClothes() async {
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  // Tambah pakaian baru
  static Future<Map<String, dynamic>> createClothing(Clothing clothing) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clothing.toJson()),
    );
    return jsonDecode(response.body);
  }

  // Ambil pakaian berdasarkan id
  static Future<Map<String, dynamic>> getClothingById(int id) async {
    final response = await http.get(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }

  // Update pakaian
  static Future<Map<String, dynamic>> updateClothing(
      Clothing clothing, int id) async {
    final response = await http.put(
      Uri.parse("$url/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clothing.toJson()),
    );
    return jsonDecode(response.body);
  }

  // Hapus pakaian
  static Future<Map<String, dynamic>> deleteClothing(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }
}
