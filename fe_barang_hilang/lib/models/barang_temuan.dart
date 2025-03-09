import 'package:cloud_firestore/cloud_firestore.dart';

class BarangTemuanModel {
  String? id;
  String? kategoriId;
  String? deskripsi;
  String? lokasiTemuan;
  Timestamp? tanggalTemuan;
  String? penemuId; // User ID yang menemukan
  String? imageUrl;
  String? qrCode;

  BarangTemuanModel({
    this.id,
    this.kategoriId,
    this.deskripsi,
    this.lokasiTemuan,
    this.tanggalTemuan,
    this.penemuId,
    this.imageUrl,
    this.qrCode,
  });

  BarangTemuanModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    kategoriId = map['kategoriId'];
    deskripsi = map['deskripsi'];
    lokasiTemuan = map['lokasiTemuan'];
    tanggalTemuan = map['tanggalTemuan'];
    penemuId = map['penemuId'];
    imageUrl = map['imageUrl'];
    qrCode = map['qrCode'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kategoriId': kategoriId,
      'deskripsi': deskripsi,
      'lokasiTemuan': lokasiTemuan,
      'tanggalTemuan': tanggalTemuan,
      'penemuId': penemuId,
      'imageUrl': imageUrl,
      'qrCode': qrCode,
    };
  }
}