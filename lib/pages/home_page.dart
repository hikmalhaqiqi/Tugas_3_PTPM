import 'package:flutter/material.dart';
import 'package:tugas_3/services/clothing_api.dart';
import 'package:tugas_3/models/clothing_model.dart';
import 'package:tugas_3/pages/create_clothing_page.dart';
import 'package:tugas_3/pages/edit_clothing_page.dart';
import 'package:tugas_3/pages/detail_clothing_page.dart';
import 'package:tugas_3/pages/delete_clothing_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Clothing>> getData() async {
    final response = await ClothingApi.getClothes();
    final model = ClothingModel.fromJson(response);
    return model.data ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pakaian"),
      ),
      body: FutureBuilder<List<Clothing>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data pakaian kosong."));
          }

          final clothings = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemCount: clothings.length,
            itemBuilder: (context, index) {
              final item = clothings[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailClothingPage(id: item.id!),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 227, 253, 242),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Pakaian
                      Text(
                        item.name ?? "-",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Informasi Pakaian dalam format label: nilai
                      _infoRow("Brand", item.brand),
                      _infoRow("Kategori", item.category),
                      _infoRow("Harga", "Rp${item.price ?? 0}"),
                      _infoRow("Stok", item.stock?.toString()),

                      const Spacer(),

                      // Tombol Aksi Edit dan Delete
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditClothingPage(id: item.id!),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: const Color.fromARGB(255, 49, 44, 44),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DeleteClothingPage(id: item.id!),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateClothingPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget _infoRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            "$label",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(": "),
        Expanded(
          child: Text(
            value ?? '-',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
