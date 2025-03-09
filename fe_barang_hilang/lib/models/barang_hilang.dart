import 'package:cloud_firestore/cloud_firestore.dart';

class BarangHilangModel {
  String? id;
  String? kategoriId;
  String? deskripsi;
  String? lokasiHilang;
  Timestamp? tanggalHilang;
  String? pelaporId; // User ID yang melaporkan
  String? imageUrl;

  BarangHilangModel({
    this.id,
    this.kategoriId,
    this.deskripsi,
    this.lokasiHilang,
    this.tanggalHilang,
    this.pelaporId,
    this.imageUrl
  });

  BarangHilangModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    kategoriId = map['kategoriId'];
    deskripsi = map['deskripsi'];
    lokasiHilang = map['lokasiHilang'];
    tanggalHilang = map['tanggalHilang'];
    pelaporId = map['pelaporId'];
    imageUrl = map['imageUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kategoriId': kategoriId,
      'deskripsi': deskripsi,
      'lokasiHilang': lokasiHilang,
      'tanggalHilang': tanggalHilang,
      'pelaporId': pelaporId,
      'imageUrl': imageUrl,
    };
  }
}