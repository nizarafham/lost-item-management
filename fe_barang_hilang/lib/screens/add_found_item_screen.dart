import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddFoundItemScreen extends StatefulWidget {
  @override
  _AddFoundItemScreenState createState() => _AddFoundItemScreenState();
}

class _AddFoundItemScreenState extends State<AddFoundItemScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> submitFoundItem() async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://127.0.0.1:8000/api/found-items/"), // Ganti dengan URL backend
    );

    request.fields["name"] = nameController.text;
    request.fields["location"] = locationController.text;
    request.fields["description"] = descriptionController.text;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath("image", _image!.path));
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      print("Barang temuan berhasil ditambahkan!");
    } else {
      print("Gagal menambahkan barang temuan.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laporkan Barang Temuan")),
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
              decoration: InputDecoration(labelText: "Lokasi Ditemukan"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Deskripsi Barang (Opsional)"),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 200)
                : Text("Belum ada gambar", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Pilih Gambar"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitFoundItem,
              child: Text("Laporkan"),
            ),
          ],
        ),
      ),
    );
  }
}
