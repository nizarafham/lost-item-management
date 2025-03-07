import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lost & Found Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Cari barang hilang...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Judul Kategori Populer
            Text(
              "Kategori Populer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Grid Kategori Populer
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Jumlah kolom
                crossAxisSpacing: 10, // Spasi antar kolom
                mainAxisSpacing: 10, // Spasi antar baris
                children: [
                  _buildCategoryCard("Dompet", Icons.wallet),
                  _buildCategoryCard("Kunci", Icons.key),
                  _buildCategoryCard("Handphone", Icons.phone),
                  _buildCategoryCard("Laptop", Icons.laptop),
                  _buildCategoryCard("Tas", Icons.work),
                  _buildCategoryCard("Perhiasan", Icons.diamond),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat card kategori
  Widget _buildCategoryCard(String title, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          // Aksi saat kategori diklik
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}