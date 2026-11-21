import 'package:hive_flutter/hive_flutter.dart';
import '../models/laporan_fasilitas.dart';
import 'laporan_repository.dart';

const String namaBoxLaporan = 'laporanFasilitasBox';

late final Box<LaporanFasilitas> laporanFasilitasBox;
late final LaporanRepository repositoriLaporan;

Future<void> bukaBoxLaporan() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(LaporanFasilitasAdapter());
  }
  laporanFasilitasBox = await Hive.openBox<LaporanFasilitas>(namaBoxLaporan);
  repositoriLaporan = LaporanRepository(laporanFasilitasBox);
}
