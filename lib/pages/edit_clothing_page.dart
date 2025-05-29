import 'package:flutter/material.dart';
import 'package:tugas_3/models/clothing_model.dart';
import 'package:tugas_3/services/clothing_api.dart';
import 'package:tugas_3/pages/home_page.dart';

class EditClothingPage extends StatefulWidget {
  final int id;

  const EditClothingPage({super.key, required this.id});

  @override
  State<EditClothingPage> createState() => _EditClothingPageState();
}

class _EditClothingPageState extends State<EditClothingPage> {
  final name = TextEditingController();
  final size = TextEditingController();
  final color = TextEditingController();
  final brand = TextEditingController();
  final price = TextEditingController();
  final category = TextEditingController();
  final material = TextEditingController();
  final stock = TextEditingController();
  final sold = TextEditingController();
  final rating = TextEditingController();
  final yearReleased = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isDataLoaded = false;

  Future<void> _updateClothing(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      Clothing updatedClothing = Clothing(
        id: widget.id,
        name: name.text.trim(),
        brand: brand.text.trim(),
        price: int.tryParse(price.text),
        category: category.text.trim(),
        material: material.text.trim(),
        stock: int.tryParse(stock.text),
        sold: int.tryParse(sold.text),
        rating: double.tryParse(rating.text),
        yearReleased: int.tryParse(yearReleased.text),
      );

      final response =
          await ClothingApi.updateClothing(updatedClothing, widget.id);

      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Berhasil mengubah pakaian ${updatedClothing.name}")),
        );
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        throw Exception(response["message"]);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Pakaian"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: ClothingApi.getClothingById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              if (!_isDataLoaded) {
                _isDataLoaded = true;
                final clothing = Clothing.fromJson(snapshot.data!["data"]);
                name.text = clothing.name ?? '';
                brand.text = clothing.brand ?? '';
                price.text = clothing.price?.toString() ?? '';
                category.text = clothing.category ?? '';
                material.text = clothing.material ?? '';
                stock.text = clothing.stock?.toString() ?? '';
                sold.text = clothing.sold?.toString() ?? '';
                rating.text = clothing.rating?.toString() ?? '';
                yearReleased.text = clothing.yearReleased?.toString() ?? '';
              }

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(controller: name, label: "Nama Pakaian"),
                    _buildTextField(controller: brand, label: "Brand"),
                    _buildTextField(
                        controller: price,
                        label: "Harga",
                        keyboardType: TextInputType.number),
                    _buildTextField(controller: category, label: "Kategori"),
                    _buildTextField(controller: material, label: "Bahan"),
                    _buildTextField(
                        controller: stock,
                        label: "Stok",
                        keyboardType: TextInputType.number),
                    _buildTextField(
                        controller: sold,
                        label: "Terjual",
                        keyboardType: TextInputType.number),
                    _buildTextField(
                        controller: rating,
                        label: "Rating",
                        keyboardType: TextInputType.number),
                    _buildTextField(
                        controller: yearReleased,
                        label: "Tahun Rilis",
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _updateClothing(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text("Update Pakaian"),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label tidak boleh kosong";
          }
          return null;
        },
      ),
    );
  }
}
