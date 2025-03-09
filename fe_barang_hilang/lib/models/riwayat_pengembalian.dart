import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatPengembalianModel {
  String? id;
  String? barangTemuanId;
  String? pengklaimId; // User ID yang mengklaim
  Timestamp? tanggalPengembalian;
  String? penemuId; // User ID petugas yang memverifikasi (opsional)
  String? pelaporId; // User ID petugas yang memverifikasi (opsional)

  RiwayatPengembalianModel({
    this.id,
    this.barangTemuanId,
    this.pengklaimId,
    this.tanggalPengembalian,
    this.pelaporId,
    this.penemuId,
  });

  RiwayatPengembalianModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    barangTemuanId = map['barangTemuanId'];
    pengklaimId = map['pengklaimId'];
    tanggalPengembalian = map['tanggalPengembalian'];
    pelaporId = map['pelaporId'];
    penemuId = map['penemuId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barangTemuanId': barangTemuanId,
      'pengklaimId': pengklaimId,
      'tanggalPengembalian': tanggalPengembalian,
      'petugasId': pelaporId,
      'penemuId': penemuId,
    };
  }
}