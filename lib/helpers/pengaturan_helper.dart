import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/status_laporan.dart';

class PengaturanHelper {
  PengaturanHelper._();

  static const String _kunciFilter = 'filter_status_laporan';
  static late SharedPreferences _prefs;

  static final ValueNotifier<String> filterStatus = ValueNotifier<String>(
    filterSemua,
  );

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    filterStatus.value = muatFilter();
  }

  static String muatFilter() {
    final nilai = _prefs.getString(_kunciFilter);
    if (nilai != null && daftarFilter.contains(nilai)) return nilai;
    return filterSemua;
  }

  static Future<void> simpanFilter(String filter) async {
    await _prefs.setString(_kunciFilter, filter);
    filterStatus.value = filter;
  }

  static Future<void> resetFilter() async {
    await _prefs.remove(_kunciFilter);
    filterStatus.value = filterSemua;
  }
}
