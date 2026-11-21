import 'package:flutter/material.dart';
import '../helpers/hive_helper.dart';
import '../helpers/laporan_repository.dart';

class HalamanTambah extends StatefulWidget {
  const HalamanTambah({super.key});

  @override
  State<HalamanTambah> createState() => _HalamanTambahState();
}

class _HalamanTambahState extends State<HalamanTambah> {
  final _formKey = GlobalKey<FormState>();
  final _kode = TextEditingController();
  final _jenis = TextEditingController();
  final _lokasi = TextEditingController();

  @override
  void dispose() {
    _kode.dispose();
    _jenis.dispose();
    _lokasi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final kode = LaporanRepository.normalisasiKode(_kode.text);
    final galat = await repositoriLaporan.tambah(
      kode: _kode.text,
      jenis: _jenis.text,
      lokasi: _lokasi.text,
    );
    if (!mounted) return;

    if (galat != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(galat)));
      return;
    }

    _kode.clear();
    _jenis.clear();
    _lokasi.clear();
    _formKey.currentState!.reset();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Laporan $kode berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Laporan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _kode,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Kode laporan',
                hintText: 'Contoh: SC01',
                border: OutlineInputBorder(),
              ),
              validator: repositoriLaporan.validasiKode,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jenis,
              decoration: const InputDecoration(
                labelText: 'Jenis fasilitas / kerusakan',
                hintText: 'Contoh: Lampu jalan mati',
                border: OutlineInputBorder(),
              ),
              validator: LaporanRepository.validasiJenis,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lokasi,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                hintText: 'Contoh: Jl. Melati',
                border: OutlineInputBorder(),
              ),
              validator: LaporanRepository.validasiLokasi,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: const Text('Simpan laporan'),
            ),
            const SizedBox(height: 8),
            const Text('Status awal setiap laporan baru adalah "Baru".'),
          ],
        ),
      ),
    );
  }
}
