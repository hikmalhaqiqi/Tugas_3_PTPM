import 'package:flutter/material.dart';
import 'package:tugas_3/models/clothing_model.dart';
import 'package:tugas_3/services/clothing_api.dart';

class DetailClothingPage extends StatelessWidget {
  final int id;

  const DetailClothingPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pakaian")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _clothingDetail(),
      ),
    );
  }

  // Widget untuk menampilkan detail pakaian dari API
  Widget _clothingDetail() {
    return FutureBuilder(
      future: ClothingApi.getClothingById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final clothing = Clothing.fromJson(snapshot.data!["data"]);
          return _clothing(clothing);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Widget untuk menampilkan isi detail pakaian
  Widget _clothing(Clothing clothing) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clothing.name ?? "-",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _infoText("Brand", clothing.brand),
          _infoText("Kategori", clothing.category),
          _infoText("Harga", "Rp${clothing.price ?? 0}"),
          _infoText("Bahan", clothing.material),
          _infoText("Tahun Rilis", clothing.yearReleased?.toString()),
          _infoText("Stok", clothing.stock?.toString()),
          _infoText("Terjual", clothing.sold?.toString()),
          _infoText("Rating", clothing.rating?.toString()),
        ],
      ),
    );
  }

  // Widget untuk menampilkan informasi berlabel
  Widget _infoText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // lebar tetap untuk label
            child: Text(
              "$label",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const Text(": "),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
