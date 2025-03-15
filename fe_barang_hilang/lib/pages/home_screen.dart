import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> recentItems = [];
  ApiService? apiService;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? '');
    _loadRecentItems();

    // Listen to scroll events
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 0 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentItems() async {
    try {
      final data = await apiService?.get('found-items');
      if (data != null) {
        setState(() {
          recentItems = (data as List).map((item) => Item.fromJson(item)).toList();
        });
      }
    } catch (e) {
      print('Error loading recent items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content column
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Header Merah
                Container(
                  color: Colors.redAccent,
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LOREM IPSUM LOREM IPSUM\nLOREM IPSUM",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 50), // Extra space for the search bar to overlap
                    ],
                  ),
                ),
                
                // Lokasi
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Lokasi", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),

                // Location cards with proper spacing and rounded corners
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildLocationCard("GRIYA LEGITA"),
                      SizedBox(width: 8),
                      _buildLocationCard("GOR"),
                      SizedBox(width: 8),
                      _buildLocationCard("SELASAR"),
                      SizedBox(width: 8),
                      _buildLocationCard("KANTIN"),
                      SizedBox(width: 8),
                      _buildLocationCard("PARKIRAN"),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Kategori Barang (Biru)
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryCircle("KUNCI"),
                      _buildCategoryCircle("KTM"),
                      _buildCategoryCircle("DOMPET"),
                      _buildCategoryCircle("..."),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Peringatan - Rounded corners
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "JAGA SELALU BARANG ANDA !!!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Temuan Terbaru
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Temuan Terbaru", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),

                // Recent items grid
                Container(
                  height: 100, // Set a fixed height for the horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recentItems.length,
                    itemBuilder: (context, index) {
                      return _buildRecentItem(recentItems[index]);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Custom AppBar with transparent background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              color: _isScrolled ? Colors.white : Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: _isScrolled ? Colors.grey[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "SEARCH BAR",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: CircleAvatar(
                        backgroundColor: _isScrolled ? Colors.grey[200] : Colors.grey[300],
                        radius: 20,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: buildQrFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildLocationCard(String title) {
    return GestureDetector(
      onTap: () {
        // Aksi saat box lokasi dipencet
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildCategoryCircle(String title) {
    return GestureDetector(
      onTap: () {
        // Aksi saat kategori dipencet
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItem(Item item) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(item.description), // Sesuaikan dengan struktur data API
      ),
    );
  }

  Container buildQrFloatingActionButton() {
    return Container(
      width: 56.0,
      height: 56.0,
      margin: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFC5BAFF),
            Color(0xFFC4D9FF),
            Color(0xFFE8F9FF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: IconButton(
        icon: const Text("QR", style: TextStyle(color: Colors.black)),
        onPressed: () {
          Navigator.pushNamed(context, '/qr_scan');
        },
      ),
    );
  }
}