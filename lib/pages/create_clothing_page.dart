import 'package:flutter/material.dart';
import 'package:tugas_3/models/clothing_model.dart';
import 'package:tugas_3/services/clothing_api.dart';
import 'package:tugas_3/pages/home_page.dart';

class CreateClothingPage extends StatefulWidget {
  const CreateClothingPage({super.key});

  @override
  State<CreateClothingPage> createState() => _CreateClothingPageState();
}

class _CreateClothingPageState extends State<CreateClothingPage> {
  final name = TextEditingController();
  final brand = TextEditingController();
  final price = TextEditingController();
  final category = TextEditingController();
  final material = TextEditingController();
  final stock = TextEditingController();
  final sold = TextEditingController();
  final rating = TextEditingController();
  final yearReleased = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _createClothing(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      Clothing newClothing = Clothing(
        name: name.text.trim(),
        brand: brand.text.trim(),
        price: int.parse(price.text),
        category: category.text.trim(),
        material: material.text.trim(),
        stock: int.parse(stock.text),
        sold: int.parse(sold.text),
        rating: double.parse(rating.text),
        yearReleased: int.parse(yearReleased.text),
      );

      final response = await ClothingApi.createClothing(newClothing);

      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil menambah pakaian baru")),
        );
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
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
      appBar: AppBar(title: const Text("Tambah Pakaian")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  if (val == null) return "Rating harus berupa angka";
                  if (val < 0 || val > 5) return "Rating harus 0 - 5";
                  return null;
                },
              ),
              _buildTextField(
                controller: yearReleased,
                label: "Tahun Rilis",
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = int.tryParse(value ?? '');
                  if (val == null) return "Tahun Rilis harus berupa angka";
                  if (val < 2018 || val > 2025) {
                    return "Tahun Rilis harus antara 2018 - 2025";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _createClothing(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text("Tambah Pakaian"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
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
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return "$label tidak boleh kosong";
              }
              return null;
            },
      ),
    );
  }
}
