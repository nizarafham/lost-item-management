 import 'package:fe_barang_hilang/firebase_options.dart';
import 'package:flutter/material.dart';
    import 'package:firebase_core/firebase_core.dart';
    import 'package:fe_barang_hilang/pages/home_screen.dart';
    import 'package:fe_barang_hilang/pages/login_screen.dart';
    import 'package:fe_barang_hilang/pages/report_found_item_screen.dart';
    import 'package:fe_barang_hilang/pages/report_lost_item_screen.dart';
    import 'package:fe_barang_hilang/pages/lost_item_screen.dart';
    import 'package:fe_barang_hilang/pages/chat_screen.dart';
    import 'package:fe_barang_hilang/pages/profile_screen.dart';
    import 'package:fe_barang_hilang/pages/qr_scan_screen.dart';
    import 'package:flutter_dotenv/flutter_dotenv.dart';

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform, // Gunakan ini
      );
      await dotenv.load(fileName: ".env"); // Load .env file
      runApp(MyApp());
    }

    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'OLIVIA - Lost and Found App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/report_found': (context) => ReportFoundItemScreen(),
            '/report_lost': (context) => ReportLostItemScreen(),
            '/lost_items': (context) => LostItemsScreen(),
            // '/chat': (context) => ChatScreen(),
            '/profile': (context) => ProfileScreen(),
            '/qr_scan': (context) => QrScanScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/chat') {
              final args = settings.arguments as Map<String, String>;
              return MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiverId: args['receiverId']!, // Pastikan tidak null
                  receiverName: args['receiverName']!, // Pastikan tidak null
                ),
              );
            }
            // Jika route tidak ditemukan, kembalikan null
            return null;
          },
        );
      }
    }