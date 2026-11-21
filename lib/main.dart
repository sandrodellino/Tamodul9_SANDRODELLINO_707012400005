import 'package:flutter/material.dart';
import 'helpers/hive_helper.dart';
import 'helpers/pengaturan_helper.dart';
import 'pages/halaman_daftar.dart';
import 'pages/halaman_filter.dart';
import 'pages/halaman_tambah.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bukaBoxLaporan(); // Hive + adapter + Box laporanFasilitasBox
  await PengaturanHelper.init(); // SharedPreferences + filter tersimpan
  runApp(const PelaporanFasilitasApp());
}

class PelaporanFasilitasApp extends StatelessWidget {
  const PelaporanFasilitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pelaporan Fasilitas Kota',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int index = 0;

  final halaman = const [HalamanDaftar(), HalamanTambah(), HalamanFilter()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (nilai) => setState(() => index = nilai),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Daftar'),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Tambah',
          ),
          NavigationDestination(icon: Icon(Icons.filter_alt), label: 'Filter'),
        ],
      ),
    );
  }
}
