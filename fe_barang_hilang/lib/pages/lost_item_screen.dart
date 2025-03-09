import 'package:flutter/material.dart';
    import '../services/api_service.dart';
    import '../models/item.dart';
    import 'package:flutter_dotenv/flutter_dotenv.dart';

    class LostItemsScreen extends StatefulWidget {
      @override
      _LostItemsScreenState createState() => _LostItemsScreenState();
    }

    class _LostItemsScreenState extends State<LostItemsScreen> {
      List<Item> lostItems = [];
      ApiService? apiService;
      String? _selectedLocation;
      String? _selectedCategory;

      @override
      void initState() {
        super.initState();
        apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? '');
        _loadLostItems();
      }

      Future<void> _loadLostItems() async {
        try {
          // Tambahkan parameter filter ke URL
          String url = 'lost-items';
          if (_selectedLocation != null || _selectedCategory != null) {
            url += '?';
            if (_selectedLocation != null) {
              url += 'location=$_selectedLocation&';
            }
            if (_selectedCategory != null) {
              url += 'category=$_selectedCategory&';
            }
            url = url.substring(0, url.length - 1); // Hapus karakter '&' terakhir
          }

          final data = await apiService?.get(url);
          if (data != null) {
            setState(() {
              lostItems = (data as List).map((item) => Item.fromJson(item)).toList();
            });
          }
        } catch (e) {
          print('Error loading lost items: $e');
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Lost Items')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        hint: Text('Select Location'),
                        value: _selectedLocation,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                            _loadLostItems();
                          });
                        },
                        items: <String>['Semua','Griya Legita', 'GOR', 'Selasar', 'Kantin', 'Parkiran']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        hint: Text('Select Category'),
                        value: _selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                            _loadLostItems();
                          });
                        },
                        items: <String>['Semua','Kunci', 'KTM', 'Dompet', 'Lainnya']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: lostItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(lostItems[index].description),
                      subtitle: Text('Location: ${lostItems[index].location}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    }