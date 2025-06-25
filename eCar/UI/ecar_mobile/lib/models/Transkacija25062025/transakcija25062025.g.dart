// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transakcija25062025.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transakcija25062025 _$Transakcija25062025FromJson(Map<String, dynamic> json) =>
    Transakcija25062025(
      id: (json['id'] as num?)?.toInt(),
      iznos: (json['iznos'] as num?)?.toDouble(),
      datumTransakcije: json['datumTransakcije'] == null
          ? null
          : DateTime.parse(json['datumTransakcije'] as String),
      opis: json['opis'] as String?,
      status: json['status'] as String?,
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      kategorijaId: (json['kategorijaId'] as num?)?.toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : User.fromJson(json['korisnik'] as Map<String, dynamic>),
      kategorija: json['kategorija'] == null
          ? null
          : KategorijaTransakcije25062025.fromJson(
              json['kategorija'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Transakcija25062025ToJson(
        Transakcija25062025 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'iznos': instance.iznos,
      'datumTransakcije': instance.datumTransakcije?.toIso8601String(),
      'opis': instance.opis,
      'status': instance.status,
      'korisnikId': instance.korisnikId,
      'kategorijaId': instance.kategorijaId,
      'korisnik': instance.korisnik,
      'kategorija': instance.kategorija,
    };
