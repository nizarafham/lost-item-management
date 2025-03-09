import 'package:flutter/material.dart';
    import 'package:intl/intl.dart';
    import '../services/api_service.dart';
    import 'package:flutter_dotenv/flutter_dotenv.dart';

    class ReportLostItemScreen extends StatefulWidget {
      @override
      _ReportLostItemScreenState createState() => _ReportLostItemScreenState();
    }

    class _ReportLostItemScreenState extends State<ReportLostItemScreen> {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController _descriptionController = TextEditingController();
      final TextEditingController _locationController = TextEditingController();
      String? _selectedCategory;
      DateTime _selectedDate = DateTime.now();
      ApiService? apiService;

      @override
      void initState() {
        super.initState();
        apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? '');
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
          appBar: AppBar(title: Text('Report Lost Item')),
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
                    decoration: InputDecoration(labelText: 'Location Lost'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: Text("Date Lost: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim data ke backend
                        final data = {
                          'category_id': _selectedCategory, // Perlu diubah jika category_id adalah integer
                          'description': _descriptionController.text,
                          'location': _locationController.text,
                          'date_lost': DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedDate), // Format tanggal dan waktu
                        };

                        try {
                          dynamic response = await apiService?.post('lost-items', data);

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