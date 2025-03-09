class KategoriModel {
  String? id;
  String? nama;

  KategoriModel({this.id, this.nama});

  KategoriModel.fromMap(Map<String, dynamic> map) {
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