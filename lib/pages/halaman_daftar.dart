import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../helpers/hive_helper.dart';
import '../helpers/pengaturan_helper.dart';
import '../models/laporan_fasilitas.dart';
import '../models/status_laporan.dart';

class HalamanDaftar extends StatelessWidget {
  const HalamanDaftar({super.key});

  static Color _warna(String status) {
    switch (status) {
      case statusDiproses:
        return Colors.orange;
      case statusSelesai:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  static IconData _ikon(String status) {
    switch (status) {
      case statusDiproses:
        return Icons.autorenew;
      case statusSelesai:
        return Icons.check_circle;
      default:
        return Icons.fiber_new;
    }
  }

  Future<void> _ubahStatus(
    BuildContext context,
    LaporanFasilitas laporan,
    String status,
  ) async {
    final berhasil = await repositoriLaporan.ubahStatus(laporan.kode, status);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          berhasil
              ? 'Status ${laporan.kode} diubah menjadi $status'
              : 'Status tidak dapat diubah',
        ),
      ),
    );
  }

  Future<void> _hapus(BuildContext context, LaporanFasilitas laporan) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus laporan?'),
        content: Text(
          'Hapus laporan ${laporan.kode} (${laporan.jenis}) '
          'di ${laporan.lokasi}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;
    await repositoriLaporan.hapus(laporan.kode);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Laporan ${laporan.kode} dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Laporan')),
      body: ValueListenableBuilder<String>(
        valueListenable: PengaturanHelper.filterStatus,
        builder: (context, filter, _) {
          return ValueListenableBuilder<Box<LaporanFasilitas>>(
            valueListenable: laporanFasilitasBox.listenable(),
            builder: (context, box, _) {
              final daftar = repositoriLaporan.daftar(filter: filter);

              Widget isi;
              if (daftar.isEmpty) {
                isi = Center(
                  child: Text(
                    box.isEmpty
                        ? 'Belum ada laporan'
                        : 'Tidak ada laporan berstatus $filter',
                  ),
                );
              } else {
                isi = ListView.builder(
                  itemCount: daftar.length,
                  itemBuilder: (context, index) {
                    final laporan = daftar[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _warna(laporan.status),
                          foregroundColor: Colors.white,
                          child: Icon(_ikon(laporan.status)),
                        ),
                        title: Text('${laporan.kode} - ${laporan.jenis}'),
                        subtitle: Text(
                          'Lokasi: ${laporan.lokasi}\n'
                          'Status: ${laporan.status}',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PopupMenuButton<String>(
                              tooltip: 'Ubah status',
                              icon: const Icon(Icons.edit_note),
                              onSelected: (status) =>
                                  _ubahStatus(context, laporan, status),
                              itemBuilder: (context) => [
                                for (final status in daftarStatus)
                                  PopupMenuItem<String>(
                                    value: status,
                                    enabled: status != laporan.status,
                                    child: Text(
                                      status == laporan.status
                                          ? '$status (saat ini)'
                                          : status,
                                    ),
                                  ),
                              ],
                            ),
                            IconButton(
                              tooltip: 'Hapus laporan',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _hapus(context, laporan),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      children: [
                        Chip(
                          avatar: const Icon(Icons.filter_alt, size: 18),
                          label: Text('Filter: $filter'),
                        ),
                        const Spacer(),
                        Text('${daftar.length} dari ${box.length} laporan'),
                      ],
                    ),
                  ),
                  Expanded(child: isi),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
