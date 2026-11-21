import 'package:flutter_test/flutter_test.dart';
import 'package:tamodul9pelaporanfasilitas/main.dart';

void main() {
  test('Aplikasi dapat dikonstruksi', () {
    const aplikasi = PelaporanFasilitasApp();
    expect(aplikasi, isA<PelaporanFasilitasApp>());
  });
}
