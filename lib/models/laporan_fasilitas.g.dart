part of 'laporan_fasilitas.dart';

class LaporanFasilitasAdapter extends TypeAdapter<LaporanFasilitas> {
  @override
  final int typeId = 0;

  @override
  LaporanFasilitas read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LaporanFasilitas(
      kode: fields[0] as String,
      jenis: fields[1] as String,
      lokasi: fields[2] as String,
      status: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LaporanFasilitas obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.kode)
      ..writeByte(1)
      ..write(obj.jenis)
      ..writeByte(2)
      ..write(obj.lokasi)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaporanFasilitasAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
