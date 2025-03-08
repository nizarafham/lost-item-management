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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed: () {
        //       BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
        //       Navigator.pushReplacementNamed(context, "/");
        //     },
        //   ),
        // ],
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
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Kategori Populer (Lingkaran Horizontal)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 10, // Spasi antar lingkaran
                children: [
                  _buildCategoryCircle("Dompet", Icons.wallet),
                  _buildCategoryCircle("Kunci", Icons.key),
                  _buildCategoryCircle("Elektronik", Icons.flash_on),
                  _buildCategoryCircle("Tas", Icons.work),
                  _buildCategoryCircle("Perhiasan", Icons.diamond),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Tambahkan bagian lain dari halaman home di sini
            Expanded(
              child: Center(
                child: Text("Bagian lain dari halaman home"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat lingkaran kategori
  Widget _buildCategoryCircle(String title, IconData icon) {
    return InkWell(
      onTap: () {
        // Aksi saat kategori diklik
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30, // Ukuran lingkaran
            backgroundColor: Colors.blue.withOpacity(0.2), // Warna latar belakang
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}