class ResSelectConditionModel {
  String status;
  List<SelectedCondition> response;

  ResSelectConditionModel({this.status, this.response});

  ResSelectConditionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<SelectedCondition>();
      json['response'].forEach((v) {
        response.add(new SelectedCondition.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectedCondition {
  String name;
  String subName;
  String image;
  List<String> symptoms;
  List<String> problemBetter;
  List<String> problemWorst;
  String sId;
  List<BodyPart> bodyPart;
  String createdAt;
  String updatedAt;
  int hasBodyParts;
  int hasSymptoms;
  int hasRatings;
  int iV;

  SelectedCondition(
      {this.name,
      this.subName,
      this.image,
      this.symptoms,
      this.problemBetter,
      this.problemWorst,
      this.sId,
      this.bodyPart,
      this.createdAt,
      this.updatedAt,
      this.hasBodyParts,
      this.hasSymptoms,
      this.hasRatings,
      this.iV});

  SelectedCondition.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    subName = json['subName'];
    image = json['image'];
    symptoms = json['symptoms'].cast<String>();
    problemBetter = json['problemBetter'].cast<String>();
    problemWorst = json['problemWorst'].cast<String>();
    sId = json['_id'];
    if (json['bodyPart'] != null) {
      bodyPart = new List<BodyPart>();
      json['bodyPart'].forEach((v) {
        bodyPart.add(new BodyPart.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    hasBodyParts = json['hasBodyParts'];
    hasSymptoms = json['hasSymptoms'];
    hasRatings = json['hasRatings'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['subName'] = this.subName;
    data['image'] = this.image;
    data['symptoms'] = this.symptoms;
    data['problemBetter'] = this.problemBetter;
    data['problemWorst'] = this.problemWorst;
    data['_id'] = this.sId;
    if (this.bodyPart != null) {
      data['bodyPart'] = this.bodyPart.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['hasBodyParts'] = this.hasBodyParts;
    data['hasSymptoms'] = this.hasSymptoms;
    data['hasRatings'] = this.hasRatings;
    data['__v'] = this.iV;
    return data;
  }
}

class BodyPart {
  String name;
  List<int> sides;
  String sId;

  BodyPart({this.name, this.sides, this.sId});

  BodyPart.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sides = json['sides'].cast<int>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['sides'] = this.sides;
    data['_id'] = this.sId;
    return data;
  }
}
