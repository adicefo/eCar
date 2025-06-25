import 'package:ecar_mobile/models/User/user.dart';

import 'package:json_annotation/json_annotation.dart';

part 'kategorijaTransakcije25062025.g.dart';

@JsonSerializable()
class Kategorijatransakcije25062025 {
  int? id;
  String? naziv;
  String? tip;


  Kategorijatransakcije25062025({
    this.id,
    this.naziv,
      this.tip
  });

  factory Kategorijatransakcije25062025.fromJson(Map<String, dynamic> json) =>
      _$Kategorijatransakcije25062025FromJson(json);

  Map<String, dynamic> toJson() => _$Kategorijatransakcije25062025ToJson(this);
}
