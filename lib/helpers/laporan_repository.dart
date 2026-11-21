import 'package:hive/hive.dart';
import '../models/laporan_fasilitas.dart';
import '../models/status_laporan.dart';

class LaporanRepository {
  LaporanRepository(this._box);

  final Box<LaporanFasilitas> _box;

  static String normalisasiKode(String kode) => kode.trim().toUpperCase();

  String? validasiKode(String? nilai) {
    final kode = normalisasiKode(nilai ?? '');
    if (kode.isEmpty) return 'Kode tidak boleh kosong';
    if (_box.containsKey(kode)) return 'Kode $kode sudah dipakai';
    return null;
  }

  static String? validasiJenis(String? nilai) {
    return (nilai ?? '').trim().isEmpty ? 'Jenis tidak boleh kosong' : null;
  }

  static String? validasiLokasi(String? nilai) {
    return (nilai ?? '').trim().isEmpty ? 'Lokasi tidak boleh kosong' : null;
  }

  Future<String?> tambah({
    required String kode,
    required String jenis,
    required String lokasi,
  }) async {
    final galat =
        validasiKode(kode) ?? validasiJenis(jenis) ?? validasiLokasi(lokasi);
    if (galat != null) return galat;

    final kodeBersih = normalisasiKode(kode);
    await _box.put(
      kodeBersih,
      LaporanFasilitas(
        kode: kodeBersih,
        jenis: jenis.trim(),
        lokasi: lokasi.trim(),
      ),
    );
    return null;
  }

  List<LaporanFasilitas> daftar({String filter = filterSemua}) {
    final hasil = _box.values
        .where((laporan) => filter == filterSemua || laporan.status == filter)
        .toList();
    hasil.sort((a, b) => a.kode.compareTo(b.kode));
    return hasil;
  }

  LaporanFasilitas? ambil(String kode) => _box.get(normalisasiKode(kode));

  Future<bool> ubahStatus(String kode, String status) async {
    if (!daftarStatus.contains(status)) return false;
    final kodeBersih = normalisasiKode(kode);
    final laporan = _box.get(kodeBersih);
    if (laporan == null) return false;
    await _box.put(kodeBersih, laporan.copyWith(status: status));
    return true;
  }

  Future<void> hapus(String kode) => _box.delete(normalisasiKode(kode));
}
