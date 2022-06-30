class ResGetMedicationDetail {
  String? status;
  Response? response;

  ResGetMedicationDetail({this.status, this.response});

  ResGetMedicationDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? sId;
  List<Medications>? medications;

  Response({this.sId, this.medications});

  Response.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications!.add(new Medications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.medications != null) {
      data['medications'] = this.medications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medications {
  String? prescriptionId;
  String? name;
  String? dose;
  String? frequency;
  String? sId;
  bool? isSelected;

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

class PatientMedicationResponseData {
  String? status;
  PatientMedicationResponse? response;

  PatientMedicationResponseData({this.status, this.response});

  PatientMedicationResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new PatientMedicationResponse.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class PatientMedicationResponse {
  int? perPage;
  int? currentPage;
  int? totalPages;
  int? totalCount;
  List<Data>? data;

  PatientMedicationResponse(
      {this.perPage,
      this.currentPage,
      this.totalPages,
      this.totalCount,
      this.data});

  PatientMedicationResponse.fromJson(Map<String, dynamic> json) {
    perPage = json['perPage'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalCount = json['totalCount'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['perPage'] = this.perPage;
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalCount'] = this.totalCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  User? user;
  Doctor? doctor;
  String? appointment;
  String? prescriptionId;
  PreviousRef? previousRef;
  String? name;
  String? dose;
  String? frequency;
  String? providerReason;
  int? actionBy;
  int? status;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.user,
      this.doctor,
      this.appointment,
      this.prescriptionId,
      this.previousRef,
      this.name,
      this.dose,
      this.frequency,
      this.providerReason,
      this.actionBy,
      this.status,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    doctor =
        json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    appointment = json['appointment'];
    prescriptionId = json['prescriptionId'];
    previousRef = json['previousRef'] != null
        ? new PreviousRef.fromJson(json['previousRef'])
        : null;
    name = json['name'];
    dose = json['dose'];
    frequency = json['frequency'];
    providerReason = json['providerReason'];
    actionBy = json['actionBy'];
    status = json['status'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    data['appointment'] = this.appointment;
    data['prescriptionId'] = this.prescriptionId;
    if (this.previousRef != null) {
      data['previousRef'] = this.previousRef!.toJson();
    }
    data['name'] = this.name;
    data['dose'] = this.dose;
    data['frequency'] = this.frequency;
    data['providerReason'] = this.providerReason;
    data['actionBy'] = this.actionBy;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
  Location? location;
  String? title;
  String? fullName;
  String? firstName;
  String? lastName;
  String? dob;
  String? address;
  String? addressTitle;
  String? addresstype;
  String? addressNumber;
  String? city;
  String? state;
  String? avatar;
  int? zipCode;
  int? phoneNumber;
  int? gender;
  int? genderType;
  List<String>? language;
  String? email;
  int? status;
  bool? isReferred;
  int? type;
  String? ssn;
  String? signature;
  bool? isOtpValid;
  int? wallet;
  bool? isResetPinOTPVerified;

  String? referredByUserId;
  List<String>? doctorTestAndMeasurePreference;
  List<String>? doctorTreatmentPreference;
  String? sId;
  List<Insurance>? insurance;
  List<Tokens>? tokens;
  List<FamilyMembers>? familyMembers;
  // List<Null>? familyNetwork;
  List<ProviderNetwork>? providerNetwork;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User(
      {this.location,
      this.title,
      this.fullName,
      this.firstName,
      this.lastName,
      this.dob,
      this.address,
      this.addressTitle,
      this.addresstype,
      this.addressNumber,
      this.city,
      this.state,
      this.avatar,
      this.zipCode,
      this.phoneNumber,
      this.gender,
      this.genderType,
      this.language,
      this.email,
      this.status,
      this.isReferred,
      this.type,
      this.ssn,
      this.signature,
      this.isOtpValid,
      this.wallet,
      this.isResetPinOTPVerified,
      this.referredByUserId,
      this.doctorTestAndMeasurePreference,
      this.doctorTreatmentPreference,
      this.sId,
      this.insurance,
      this.tokens,
      this.familyMembers,
      // this.familyNetwork,
      this.providerNetwork,
      this.createdAt,
      this.updatedAt,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    title = json['title'];
    fullName = json['fullName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    address = json['address'];
    addressTitle = json['addressTitle'];
    addresstype = json['addresstype'];
    addressNumber = json['addressNumber'];
    city = json['city'];
    state = json['state'];
    avatar = json['avatar'];
    zipCode = json['zipCode'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    genderType = json['genderType'];
    if (json['language'] != null) {
      language = <String>[];
      json['language'].forEach((v) {
        language!.add(v);
      });
    }
    email = json['email'];
    status = json['status'];
    isReferred = json['isReferred'];
    type = json['type'];
    ssn = json['ssn'];
    signature = json['signature'];
    isOtpValid = json['isOtpValid'];
    wallet = json['wallet'];
    referredByUserId = json['referredByUserId'];
    if (json['doctorTestAndMeasurePreference'] != null) {
      doctorTestAndMeasurePreference = <String>[];
      json['doctorTestAndMeasurePreference'].forEach((v) {
        doctorTestAndMeasurePreference!.add(v);
      });
    }
    if (json['doctorTreatmentPreference'] != null) {
      doctorTreatmentPreference = [];
      json['doctorTreatmentPreference'].forEach((v) {
        doctorTreatmentPreference!.add(v);
      });
    }
    sId = json['_id'];
    if (json['insurance'] != null) {
      insurance = <Insurance>[];
      json['insurance'].forEach((v) {
        insurance!.add(new Insurance.fromJson(v));
      });
    }
    if (json['tokens'] != null) {
      tokens = <Tokens>[];
      json['tokens'].forEach((v) {
        tokens!.add(new Tokens.fromJson(v));
      });
    }
    if (json['familyMembers'] != null) {
      familyMembers = <FamilyMembers>[];
      json['familyMembers'].forEach((v) {
        familyMembers!.add(new FamilyMembers.fromJson(v));
      });
    }
    // if (json['familyNetwork'] != null) {
    //   familyNetwork = <Null>[];
    //   json['familyNetwork'].forEach((v) {
    //     familyNetwork!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['providerNetwork'] != null) {
      providerNetwork = <ProviderNetwork>[];
      json['providerNetwork'].forEach((v) {
        providerNetwork!.add(new ProviderNetwork.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['title'] = this.title;
    data['fullName'] = this.fullName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['addressTitle'] = this.addressTitle;
    data['addresstype'] = this.addresstype;
    data['addressNumber'] = this.addressNumber;
    data['city'] = this.city;
    data['state'] = this.state;
    data['avatar'] = this.avatar;
    data['zipCode'] = this.zipCode;
    data['phoneNumber'] = this.phoneNumber;
    data['gender'] = this.gender;
    data['genderType'] = this.genderType;
    if (this.language != null) {
      data['language'] = this.language!.map((v) => v).toList();
    }
    data['email'] = this.email;
    data['status'] = this.status;
    data['isReferred'] = this.isReferred;
    data['type'] = this.type;
    data['ssn'] = this.ssn;
    data['signature'] = this.signature;
    data['isOtpValid'] = this.isOtpValid;
    data['wallet'] = this.wallet;
    data['referredByUserId'] = this.referredByUserId;
    if (this.doctorTestAndMeasurePreference != null) {
      data['doctorTestAndMeasurePreference'] =
          this.doctorTestAndMeasurePreference!.map((v) => v).toList();
    }
    if (this.doctorTreatmentPreference != null) {
      data['doctorTreatmentPreference'] =
          this.doctorTreatmentPreference!.map((v) => v).toList();
    }
    data['_id'] = this.sId;
    if (this.insurance != null) {
      data['insurance'] = this.insurance!.map((v) => v.toJson()).toList();
    }
    if (this.tokens != null) {
      data['tokens'] = this.tokens!.map((v) => v.toJson()).toList();
    }
    if (this.familyMembers != null) {
      data['familyMembers'] =
          this.familyMembers!.map((v) => v.toJson()).toList();
    }
    // if (this.familyNetwork != null) {
    //   data['familyNetwork'] =
    //       this.familyNetwork!.map((v) => v.toJson()).toList();
    // }
    if (this.providerNetwork != null) {
      data['providerNetwork'] =
          this.providerNetwork!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Location {
  String? type;
  List<int>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Insurance {
  String? insuranceId;
  String? insuranceDocumentFront;
  String? insuranceDocumentBack;
  bool? isPrimary;
  String? sId;
  String? insuredMemberName;
  String? memberId;
  String? groupNumber;
  String? healthPlan;
  String? effectiveDate;

  Insurance(
      {this.insuranceId,
      this.insuranceDocumentFront,
      this.insuranceDocumentBack,
      this.isPrimary,
      this.sId,
      this.insuredMemberName,
      this.memberId,
      this.groupNumber,
      this.healthPlan,
      this.effectiveDate});

  Insurance.fromJson(Map<String, dynamic> json) {
    insuranceId = json['insuranceId'];
    insuranceDocumentFront = json['insuranceDocumentFront'];
    insuranceDocumentBack = json['insuranceDocumentBack'];
    isPrimary = json['isPrimary'];
    sId = json['_id'];
    insuredMemberName = json['insuredMemberName'];
    memberId = json['memberId'];
    groupNumber = json['groupNumber'];
    healthPlan = json['healthPlan'];
    effectiveDate = json['effectiveDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['insuranceId'] = this.insuranceId;
    data['insuranceDocumentFront'] = this.insuranceDocumentFront;
    data['insuranceDocumentBack'] = this.insuranceDocumentBack;
    data['isPrimary'] = this.isPrimary;
    data['_id'] = this.sId;
    data['insuredMemberName'] = this.insuredMemberName;
    data['memberId'] = this.memberId;
    data['groupNumber'] = this.groupNumber;
    data['healthPlan'] = this.healthPlan;
    data['effectiveDate'] = this.effectiveDate;
    return data;
  }
}

class Tokens {
  String? sId;
  String? access;
  String? token;

  Tokens({this.sId, this.access, this.token});

  Tokens.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    access = json['access'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['access'] = this.access;
    data['token'] = this.token;
    return data;
  }
}

class FamilyMembers {
  String? name;
  String? phone;
  int? relationId;
  // List<Null> userPermissions;
  String? sId;

  FamilyMembers({this.name, this.phone, this.relationId, this.sId});

  FamilyMembers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    relationId = json['relationId'];

    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['relationId'] = this.relationId;

    data['_id'] = this.sId;
    return data;
  }
}

class ProviderNetwork {
  String? groupName;
  List<String>? doctorId;
  String? sId;

  ProviderNetwork({this.groupName, this.doctorId, this.sId});

  ProviderNetwork.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    doctorId = json['doctorId'].cast<String>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupName'] = this.groupName;
    data['doctorId'] = this.doctorId;
    data['_id'] = this.sId;
    return data;
  }
}

class Doctor {
  Location? location;
  String? title;
  String? fullName;
  String? firstName;
  String? lastName;
  String? dob;
  String? address;
  String? addressTitle;
  String? addresstype;
  String? addressNumber;
  String? city;
  String? state;
  String? avatar;
  int? zipCode;
  int? phoneNumber;
  int? gender;
  // int? genderType;
  List<String>? language;
  String? email;
  int? status;
  bool? isReferred;
  int? type;

  String? ssn;
  String? signature;
  bool? isOtpValid;
  int? wallet;

  String? referredByUserId;

  String? sId;

  String? createdAt;
  String? updatedAt;
  int? iV;

  Doctor({
    this.location,
    this.title,
    this.fullName,
    this.firstName,
    this.lastName,
    this.dob,
    this.address,
    this.addressTitle,
    this.addresstype,
    this.addressNumber,
    this.city,
    this.state,
    this.avatar,
    this.zipCode,
    this.phoneNumber,
    this.gender,
    this.language,
    this.email,
    this.status,
    this.isReferred,
    this.type,
    this.ssn,
    this.signature,
    this.isOtpValid,
    this.wallet,
    this.referredByUserId,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    title = json['title'];
    fullName = json['fullName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    address = json['address'];
    addressTitle = json['addressTitle'];
    addresstype = json['addresstype'];
    addressNumber = json['addressNumber'];
    city = json['city'];
    state = json['state'];
    avatar = json['avatar'];
    zipCode = json['zipCode'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    language = json['language'].cast<String>();
    email = json['email'];
    status = json['status'];
    isReferred = json['isReferred'];
    type = json['type'];

    ssn = json['ssn'];
    signature = json['signature'];
    isOtpValid = json['isOtpValid'];
    wallet = json['wallet'];

    referredByUserId = json['referredByUserId'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['title'] = this.title;
    data['fullName'] = this.fullName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['addressTitle'] = this.addressTitle;
    data['addresstype'] = this.addresstype;
    data['addressNumber'] = this.addressNumber;
    data['city'] = this.city;
    data['state'] = this.state;
    data['avatar'] = this.avatar;
    data['zipCode'] = this.zipCode;
    data['phoneNumber'] = this.phoneNumber;
    data['gender'] = this.gender;
    data['language'] = this.language;
    data['email'] = this.email;

    data['status'] = this.status;
    data['isReferred'] = this.isReferred;
    data['type'] = this.type;
    data['ssn'] = this.ssn;
    data['signature'] = this.signature;
    data['isOtpValid'] = this.isOtpValid;
    data['wallet'] = this.wallet;
    data['referredByUserId'] = this.referredByUserId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;

    return data;
  }
}

class PreviousRef {
  String? user;
  String? doctor;
  String? appointment;
  String? prescriptionId;
  String? previousRef;
  String? name;
  String? dose;
  String? frequency;
  String? providerReason;
  int? actionBy;
  int? status;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PreviousRef(
      {this.user,
      this.doctor,
      this.appointment,
      this.prescriptionId,
      this.previousRef,
      this.name,
      this.dose,
      this.frequency,
      this.providerReason,
      this.actionBy,
      this.status,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  PreviousRef.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    doctor = json['doctor'];
    appointment = json['appointment'];
    prescriptionId = json['prescriptionId'];
    previousRef = json['previousRef'];
    name = json['name'];
    dose = json['dose'];
    frequency = json['frequency'];
    providerReason = json['providerReason'];
    actionBy = json['actionBy'];
    status = json['status'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['doctor'] = this.doctor;
    data['appointment'] = this.appointment;
    data['prescriptionId'] = this.prescriptionId;
    data['previousRef'] = this.previousRef;
    data['name'] = this.name;
    data['dose'] = this.dose;
    data['frequency'] = this.frequency;
    data['providerReason'] = this.providerReason;
    data['actionBy'] = this.actionBy;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
