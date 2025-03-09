 import 'dart:io';
    import 'package:flutter/material.dart';
    import 'package:image_picker/image_picker.dart';
    import 'package:intl/intl.dart'; // Import intl
    import '../services/api_service.dart';
    import 'package:flutter_dotenv/flutter_dotenv.dart';

    class ReportFoundItemScreen extends StatefulWidget {
      @override
      _ReportFoundItemScreenState createState() => _ReportFoundItemScreenState();
    }

    class _ReportFoundItemScreenState extends State<ReportFoundItemScreen> {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController _descriptionController = TextEditingController();
      final TextEditingController _locationController = TextEditingController();
      String? _selectedCategory;
      DateTime _selectedDate = DateTime.now();
      File? _image;
      ApiService? apiService;

      @override
      void initState() {
        super.initState();
        apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? '');
      }

      Future<void> _pickImage() async {
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

        setState(() {
          if (pickedFile != null) {
            _image = File(pickedFile.path);
          } else {
            print('No image selected.');
          }
        });
      }

      Future<void> _selectDate(BuildContext context) async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2025)
        );
        if (picked != null && picked != _selectedDate)
          setState(() {
            _selectedDate = picked;
          });
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Report Found Item')),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Category'),
                    value: _selectedCategory,
                    items: <String>['Kunci', 'KTM', 'Dompet', 'Lainnya'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a category' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Location Found'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: Text("Date Found: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(_image!, height: 100),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim data ke backend
                        final data = {
                          'category_id': _selectedCategory, // Perlu diubah jika category_id adalah integer
                          'description': _descriptionController.text,
                          'location': _locationController.text,
                          'date_found': DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedDate), // Format tanggal dan waktu
                        };

                        try {
                          dynamic response = await apiService?.postWithImage('found-items', data, _image?.path ?? '');

                          if (response != null) {
                            // Berhasil
                            print('Report submitted successfully!');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Report submitted successfully!'))
                            );
                            Navigator.pop(context); // Kembali ke halaman sebelumnya
                          } else {
                            // Gagal
                            print('Failed to submit report.');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to submit report.'))
                            );
                          }
                        } catch (e) {
                          print('Error submitting report: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error submitting report: $e'))
                          );
                        }
                      }
                    },
                    child: Text('Submit Report'),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }