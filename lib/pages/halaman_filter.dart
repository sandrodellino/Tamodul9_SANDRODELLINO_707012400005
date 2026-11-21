import 'package:flutter/material.dart';
import '../helpers/pengaturan_helper.dart';
import '../models/status_laporan.dart';

class HalamanFilter extends StatelessWidget {
  const HalamanFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Status')),
      body: ValueListenableBuilder<String>(
        valueListenable: PengaturanHelper.filterStatus,
        builder: (context, aktif, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Filter aktif: $aktif',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilihan disimpan dengan key filter_status_laporan '
                'dan tetap dipakai setelah aplikasi dibuka kembali.',
              ),
              const SizedBox(height: 8),
              for (final filter in daftarFilter)
                ListTile(
                  title: Text(filter),
                  selected: filter == aktif,
                  trailing: filter == aktif ? const Icon(Icons.check) : null,
                  onTap: () => PengaturanHelper.simpanFilter(filter),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  await PengaturanHelper.resetFilter();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Filter dikembalikan ke Semua'),
                    ),
                  );
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset filter ke Semua'),
              ),
              const SizedBox(height: 8),
              const Text('Reset filter tidak menghapus laporan.'),
            ],
          );
        },
      ),
    );
  }
}
