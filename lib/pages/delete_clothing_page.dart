import 'package:flutter/material.dart';
import 'package:tugas_3/models/clothing_model.dart';
import 'package:tugas_3/services/clothing_api.dart';
import 'package:tugas_3/pages/home_page.dart';

class DeleteClothingPage extends StatefulWidget {
  final int id;

  const DeleteClothingPage({super.key, required this.id});

  @override
  State<DeleteClothingPage> createState() => _DeleteClothingPageState();
}

class _DeleteClothingPageState extends State<DeleteClothingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hapus Pakaian")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _clothingDetail(context),
      ),
    );
  }

  Widget _clothingDetail(BuildContext context) {
    return FutureBuilder(
      future: ClothingApi.getClothingById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!["data"] == null) {
          return const Center(child: Text("Data pakaian tidak ditemukan."));
        }

        final clothing = Clothing.fromJson(snapshot.data!['data']);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clothing.name ?? "-",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Kategori: ${clothing.category ?? '-'}"),
              Text("Brand: ${clothing.brand ?? '-'}"),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.black),
                label: const Text(
                  "Hapus Pakaian",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 212, 212, 212), // abu-abu
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // sudut membulat
                  ),
                ),
                onPressed: () => _confirmDelete(context, clothing),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Clothing clothing) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text(
            "Apakah Anda yakin ingin menghapus pakaian \"${clothing.name}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 212, 212, 212)),
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (clothing.id != null) {
                await _delete(context, clothing.id!);
              }
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, int id) async {
    try {
      final response = await ClothingApi.deleteClothing(id);

      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pakaian berhasil dihapus")),
        );

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        }
      } else {
        throw Exception(response["message"]);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus: $error")),
      );
    }
  }
}
