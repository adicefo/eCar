import 'package:ecar_mobile/models/KategorijaTransakcije25062025/kategorijaTransakcije25062025.dart';
import 'package:ecar_mobile/models/User/user.dart';

import 'package:json_annotation/json_annotation.dart';

part 'transakcija25062025.g.dart';

@JsonSerializable()
class Transakcija25062025 {
  int? id;
  double? iznos;
  DateTime? datumTransakcije;
  String? opis;
  String? status;
  int? korisnikId;
  int? kategorijaId;
  User? korisnik;
  KategorijaTransakcije25062025? kategorija;

  Transakcija25062025({
    this.id,
    this.iznos,
    this.datumTransakcije,
    this.opis,
    this.status,
    this.korisnikId,
    this.kategorijaId,
    this.korisnik,
    this.kategorija,
  });

  factory Transakcija25062025.fromJson(Map<String, dynamic> json) =>
      _$Transakcija25062025FromJson(json);

  Map<String, dynamic> toJson() => _$Transakcija25062025ToJson(this);
}
