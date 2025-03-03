import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddLostItemScreen extends StatefulWidget {
  @override
  _AddLostItemScreenState createState() => _AddLostItemScreenState();
}

class _AddLostItemScreenState extends State<AddLostItemScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> submitLostItem() async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/lost-items/"), // Ganti dengan URL backend
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "location": locationController.text,
        "description": descriptionController.text,
      }),
    );

    if (response.statusCode == 201) {
      print("Barang hilang berhasil dilaporkan!");
    } else {
      print("Gagal melaporkan barang hilang.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laporkan Barang Hilang")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama Barang"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Lokasi Kehilangan"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Deskripsi Barang (Opsional)"),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitLostItem,
              child: Text("Laporkan"),
            ),
          ],
        ),
      ),
    );
  }
}
