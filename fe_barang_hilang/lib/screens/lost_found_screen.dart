import 'package:flutter/material.dart';

class LostFoundScreen extends StatefulWidget {
  @override
  _LostFoundScreenState createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> {
  // Dummy data sementara, nanti bisa diambil dari API
  List<Map<String, dynamic>> lostItems = [
    {
      "id": 1,
      "name": "Dompet Hitam",
      "category": "Aksesoris",
      "location": "Kantin Kampus",
      "date": "28 Feb 2025",
      "status": "Hilang",
    },
    {
      "id": 2,
      "name": "Kunci Motor",
      "category": "Kunci",
      "location": "Parkiran FTI",
      "date": "25 Feb 2025",
      "status": "Ditemukan",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Barang Hilang & Temuan")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add_lost_item");
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: lostItems.length,
        itemBuilder: (context, index) {
          var item = lostItems[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(item["name"], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Kategori: ${item["category"]}"),
                  Text("Lokasi: ${item["location"]}"),
                  Text("Tanggal: ${item["date"]}"),
                  Text("Status: ${item["status"]}", style: TextStyle(color: item["status"] == "Hilang" ? Colors.red : Colors.green)),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Nanti diarahkan ke halaman detail barang
              },
            ),
          );
        },
      ),
    );
  }
}
