class ResUploadedDocumentImagesModel {
  String status;
  Response response;

  ResUploadedDocumentImagesModel({this.status, this.response});

  ResUploadedDocumentImagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
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

class Response {
  int otherMedicalHistory;
  String sId;
  List<String> medicalHistory;
  String userId;
  List<UserAddress> userAddress;
  List<MedicalImages> medicalImages;
  List<MedicalDocuments> medicalDocuments;
  String createdAt;
  String updatedAt;
  int iV;
  List<Medications> medications;
  List<String> medicalDiagnostics;
  List<String> preferredPharmacy;

  Response(
      {this.otherMedicalHistory,
      this.sId,
      this.medicalHistory,
      this.userId,
      this.userAddress,
      this.medicalImages,
      this.medicalDocuments,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.medications,
      this.medicalDiagnostics,
      this.preferredPharmacy});

  Response.fromJson(Map<String, dynamic> json) {
    otherMedicalHistory = json['otherMedicalHistory'];
    sId = json['_id'];
    medicalHistory = json['medicalHistory'].cast<String>();
    userId = json['userId'];
    if (json['userAddress'] != null) {
      userAddress = new List<UserAddress>();
      json['userAddress'].forEach((v) {
        userAddress.add(new UserAddress.fromJson(v));
      });
    }
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['medications'] != null) {
      medications = new List<Medications>();
      json['medications'].forEach((v) {
        medications.add(new Medications.fromJson(v));
      });
    }
    medicalDiagnostics = json['medicalDiagnostics'].cast<String>();
    preferredPharmacy = json['preferredPharmacy'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otherMedicalHistory'] = this.otherMedicalHistory;
    data['_id'] = this.sId;
    data['medicalHistory'] = this.medicalHistory;
    data['userId'] = this.userId;
    if (this.userAddress != null) {
      data['userAddress'] = this.userAddress.map((v) => v.toJson()).toList();
    }
    if (this.medicalImages != null) {
      data['medicalImages'] =
          this.medicalImages.map((v) => v.toJson()).toList();
    }
    if (this.medicalDocuments != null) {
      data['medicalDocuments'] =
          this.medicalDocuments.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.medications != null) {
      data['medications'] = this.medications.map((v) => v.toJson()).toList();
    }
    data['medicalDiagnostics'] = this.medicalDiagnostics;
    data['preferredPharmacy'] = this.preferredPharmacy;
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
  List<int> coordinates;
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
    coordinates = json['coordinates'].cast<int>();
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

  MedicalDocuments(
      {this.medicalDocuments, this.type, this.name, this.date, this.sId});

  MedicalDocuments.fromJson(Map<String, dynamic> json) {
    medicalDocuments = json['medicalDocuments'];
    type = json['type'];
    name = json['name'];
    date = json['date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalDocuments'] = this.medicalDocuments;
    data['type'] = this.type;
    data['name'] = this.name;
    data['date'] = this.date;
    data['_id'] = this.sId;
    return data;
  }
}

class Medications {
  String prescriptionId;
  String name;
  String dose;
  String frequency;
  String sId;

  Medications(
      {this.prescriptionId, this.name, this.dose, this.frequency, this.sId});

  Medications.fromJson(Map<String, dynamic> json) {
    prescriptionId = json['prescriptionId'];
    name = json['name'];
    dose = json['dose'];
    frequency = json['frequency'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prescriptionId'] = this.prescriptionId;
    data['name'] = this.name;
    data['dose'] = this.dose;
    data['frequency'] = this.frequency;
    data['_id'] = this.sId;
    return data;
  }
}
