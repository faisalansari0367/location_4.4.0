class UserSpecies {
  String? status;
  List<SpeciesData>? data;

  UserSpecies({this.status, this.data});

  UserSpecies.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SpeciesData>[];
      json['data'].forEach((v) {
        data!.add(SpeciesData.fromJson(Map<String, dynamic>.from(v)));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpeciesData {
  String? species;
  String? image;
  bool? value;

  SpeciesData({this.value = false, this.species, this.image});

  SpeciesData.fromJson(Map<String, dynamic> json) {
    species = json['species'];
    image = json['image'];
    value = json['value'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['species'] = species;
    data['image'] = image;
    data['value'] = value;
    return data;
  }
}
