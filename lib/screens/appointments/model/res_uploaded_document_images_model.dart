class ResUploadedDocumentImagesModel {
  String status;
  DocumentImage response;

  ResUploadedDocumentImagesModel({this.status, this.response});

  ResUploadedDocumentImagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new DocumentImage.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class DocumentImage {
  List<dynamic> otherMedicalHistory;
  String sId;
  List<MedicalHistory> medicalHistory;
  String userId;
  List<MedicalImages> medicalImages;
  List<MedicalDocuments> medicalDocuments;
  List<UserAddress> userAddress;
  String createdAt;
  String updatedAt;
  int iV;

  DocumentImage(
      {this.otherMedicalHistory,
      this.sId,
      this.medicalHistory,
      this.userId,
      this.medicalImages,
      this.medicalDocuments,
      this.userAddress,
      this.createdAt,
      this.updatedAt,
      this.iV});

  DocumentImage.fromJson(Map<String, dynamic> json) {
    otherMedicalHistory = json['otherMedicalHistory'];
    sId = json['_id'];
    if (json['medicalHistory'] != null) {
      medicalHistory = new List<MedicalHistory>();
      json['medicalHistory'].forEach((v) {
        medicalHistory.add(new MedicalHistory.fromJson(v));
      });
    }
    userId = json['userId'];
    if (json['medicalImages'] != null) {
      medicalImages = new List<MedicalImages>();
      json['medicalImages'].forEach((v) {
        medicalImages.add(new MedicalImages.fromJson(v));
      });
    }
    if (json['medicalDocuments'] != null) {
      medicalDocuments = new List<MedicalDocuments>();
      json['medicalDocuments'].forEach((v) {
        medicalDocuments.add(new MedicalDocuments.fromJson(v));
      });
    }
    if (json['userAddress'] != null) {
      userAddress = new List<UserAddress>();
      json['userAddress'].forEach((v) {
        userAddress.add(new UserAddress.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otherMedicalHistory'] = this.otherMedicalHistory;
    data['_id'] = this.sId;
    if (this.medicalHistory != null) {
      data['medicalHistory'] =
          this.medicalHistory.map((v) => v.toJson()).toList();
    }
    data['userId'] = this.userId;
    if (this.medicalImages != null) {
      data['medicalImages'] =
          this.medicalImages.map((v) => v.toJson()).toList();
    }
    if (this.medicalDocuments != null) {
      data['medicalDocuments'] =
          this.medicalDocuments.map((v) => v.toJson()).toList();
    }
    if (this.userAddress != null) {
      data['userAddress'] = this.userAddress.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class MedicalHistory {
  String name;
  int year;
  String month;
  String sId;

  MedicalHistory({this.name, this.year, this.month, this.sId});

  MedicalHistory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    year = json['year'];
    month = json['month'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['year'] = this.year;
    data['month'] = this.month;
    data['_id'] = this.sId;
    return data;
  }
}

class MedicalImages {
  String images;
  String name;
  String date;
  String sId;

  MedicalImages({this.images, this.name, this.date, this.sId});

  MedicalImages.fromJson(Map<String, dynamic> json) {
    images = json['images'];
    name = json['name'];
    date = json['date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['name'] = this.name;
    data['date'] = this.date;
    data['_id'] = this.sId;
    return data;
  }
}

class MedicalDocuments {
  String medicalDocuments;
  String type;
  String name;
  String date;
  String sId;
  String size;

  MedicalDocuments(
      {this.medicalDocuments, this.type, this.name, this.date, this.sId,this.size});

  MedicalDocuments.fromJson(Map<String, dynamic> json) {
    medicalDocuments = json['medicalDocuments'];
    type = json['type'];
    name = json['name'];
    date = json['date'];
    sId = json['_id'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalDocuments'] = this.medicalDocuments;
    data['type'] = this.type;
    data['name'] = this.name;
    data['date'] = this.date;
    data['_id'] = this.sId;
    data['size'] = this.size;
    return data;
  }
}

class UserAddress {
  String title;
  int addresstype;
  String address;
  String street;
  String city;
  String state;
  String stateCode;
  String zipCode;
  String type;
  List<double> coordinates;
  String sId;
  String number;
  String securityGate;

  UserAddress(
      {this.title,
      this.addresstype,
      this.address,
      this.street,
      this.city,
      this.state,
      this.stateCode,
      this.zipCode,
      this.type,
      this.coordinates,
      this.sId,
      this.number,
      this.securityGate});

  UserAddress.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    addresstype = json['addresstype'];
    address = json['address'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    stateCode = json['stateCode'];
    zipCode = json['zipCode'];
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
    sId = json['_id'];
    number = json['number'];
    securityGate = json['securityGate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['addresstype'] = this.addresstype;
    data['address'] = this.address;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['stateCode'] = this.stateCode;
    data['zipCode'] = this.zipCode;
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    data['_id'] = this.sId;
    data['number'] = this.number;
    data['securityGate'] = this.securityGate;
    return data;
  }
}
