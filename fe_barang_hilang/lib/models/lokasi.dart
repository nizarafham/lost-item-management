class LokasiModel {
  String? id;
  String? nama;

  LokasiModel({this.id, this.nama});

  LokasiModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nama = map['nama'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}