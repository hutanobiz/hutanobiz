class SocialHistory {
  Smoking smoking;
  List<RecreationalDrugs> recreationalDrugs;
  Drinker drinker;

  SocialHistory({this.smoking, this.recreationalDrugs, this.drinker});

  SocialHistory.fromJson(Map<String, dynamic> json) {
    smoking =
        json['smoking'] != null ? new Smoking.fromJson(json['smoking']) : null;
    if (json['recreationalDrugs'] != null) {
      recreationalDrugs = new List<RecreationalDrugs>();
      json['recreationalDrugs'].forEach((v) {
        recreationalDrugs.add(new RecreationalDrugs.fromJson(v));
      });
    }
    drinker =
        json['Drinker'] != null ? new Drinker.fromJson(json['Drinker']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.smoking != null) {
      data['smoking'] = this.smoking.toJson();
    }
    if (this.recreationalDrugs != null) {
      data['recreationalDrugs'] =
          this.recreationalDrugs.map((v) => v.toJson()).toList();
    }
    if (this.drinker != null) {
      data['Drinker'] = this.drinker.toJson();
    }
    return data;
  }
}

class Smoking {
  String frequency;

  Smoking({this.frequency});

  Smoking.fromJson(Map<String, dynamic> json) {
    frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frequency'] = this.frequency;
    return data;
  }
}

class RecreationalDrugs {
  String type;
  String frequency;

  RecreationalDrugs({this.type, this.frequency});

  RecreationalDrugs.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['frequency'] = this.frequency;
    return data;
  }
}

class Drinker {
  String type;
  String frequency;
  String liquorQuantity;
  String beerQuantity;

  Drinker({this.type, this.frequency, this.liquorQuantity, this.beerQuantity});

  Drinker.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    frequency = json['frequency'];
    liquorQuantity = json['liquorQuantity'];
    beerQuantity = json['BeerQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['frequency'] = this.frequency;
    data['liquorQuantity'] = this.liquorQuantity;
    data['BeerQuantity'] = this.beerQuantity;
    return data;
  }
}
