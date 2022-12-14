import 'package:hutano/screens/book_appointment/model/allergy.dart';
import 'package:hutano/screens/book_appointment/vitals/model/social_history.dart';

class ReqBookingAppointmentModel {
  String? cardId;
  bool? consentToTreat;
  String? consultation;
  String? date;
  String? doctor;
  String? fromTime;
  String? insuranceId;
  String? isFollowUp;
  int? isOndemand;
  List<String?>? medicalDiagnosticsTests;
  List<String?>? medicalDocuments;
  List<BookedMedicalHistory>? medicalHistory;
  List<String?>? medicalImages;
  String? officeId;
  String? otherMedicalHistory;
  int? paymentMethod;
  PreferredPharmacy? preferredPharmacy;
  List<Problems>? problems;
  List<dynamic>? services;
  String? statusType;
  String? timeZonePlace;
  String? type;
  Vitals? vitals;
  List<String>? medicationDetails;
  String? previousAppointmentId;
  String? parkingFee;
  String? parkingType;
  String? instruction;
  String? userAddressId;
  String? parkingBay;
  List<Allergy>? allergy;
  SocialHistory? socialHistory;

  ReqBookingAppointmentModel(
      {this.cardId,
      this.consentToTreat,
      this.consultation,
      this.date,
      this.doctor,
      this.fromTime,
      this.insuranceId,
      this.isFollowUp,
      this.isOndemand,
      this.medicalDiagnosticsTests,
      this.medicalDocuments,
      this.medicalHistory,
      this.medicalImages,
      this.officeId,
      this.otherMedicalHistory,
      this.paymentMethod,
      this.preferredPharmacy,
      this.problems,
      this.services,
      this.statusType,
      this.timeZonePlace,
      this.type,
      this.vitals,
      this.medicationDetails,
      this.previousAppointmentId,
      this.parkingFee,
      this.parkingType,
      this.instruction,
      this.userAddressId,
      this.parkingBay,
      this.allergy,
      this.socialHistory});

  ReqBookingAppointmentModel.fromJson(Map<String, dynamic> json) {
    cardId = json['cardId'];
    consentToTreat = json['consentToTreat'];
    consultation = json['consultation'];
    date = json['date'];
    doctor = json['doctor'];
    fromTime = json['fromTime'];
    insuranceId = json['insuranceId'];
    isFollowUp = json['isFollowUp'];
    isOndemand = json['isOndemand'];
    medicalDiagnosticsTests = json['medicalDiagnosticsTests'].cast<String>();
    medicalDocuments = json['medicalDocuments'].cast<String>();
    if (json['medicalHistory'] != null) {
      medicalHistory = <BookedMedicalHistory>[];
      json['medicalHistory'].forEach((v) {
        medicalHistory!.add(new BookedMedicalHistory.fromJson(v));
      });
    }
    medicalImages = json['medicalImages'].cast<String>();
    officeId = json['officeId'];
    otherMedicalHistory = json['otherMedicalHistory'];
    paymentMethod = json['paymentMethod'];
    preferredPharmacy = json['preferredPharmacy'] != null
        ? new PreferredPharmacy.fromJson(json['preferredPharmacy'])
        : null;
    if (json['problems'] != null) {
      problems = <Problems>[];
      json['problems'].forEach((v) {
        problems!.add(new Problems.fromJson(v));
      });
    }
    services = json['services'].cast<String>();
    statusType = json['statusType'];
    timeZonePlace = json['timeZonePlace'];
    type = json['type'];
    vitals =
        json['vitals'] != null ? new Vitals.fromJson(json['vitals']) : null;
    medicationDetails = json['medicationDetails'].cast<String>();
    previousAppointmentId = json['previousAppointmentId'];
    parkingFee = json['parkingFee'];
    parkingType = json['parkingType'];
    instruction = json['instruction'];
    userAddressId = json['userAddressId'];
    parkingBay = json['parkingBay'];
    if (json['allergy'] != null) {
      allergy = <Allergy>[];
      json['allergy'].forEach((v) {
        allergy!.add(new Allergy.fromJson(v));
      });
    }
    socialHistory = json['socialHistory'] != null
        ? new SocialHistory.fromJson(json['socialHistory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardId'] = this.cardId;
    data['consentToTreat'] = this.consentToTreat;
    data['consultation'] = this.consultation;
    data['date'] = this.date;
    data['doctor'] = this.doctor;
    data['fromTime'] = this.fromTime;
    data['insuranceId'] = this.insuranceId;
    data['isFollowUp'] = this.isFollowUp;
    data['isOndemand'] = this.isOndemand;
    data['medicalDiagnosticsTests'] = this.medicalDiagnosticsTests;
    data['medicalDocuments'] = this.medicalDocuments;
    if (this.medicalHistory != null) {
      data['medicalHistory'] =
          this.medicalHistory!.map((v) => v.toJson()).toList();
    }
    data['medicalImages'] = this.medicalImages;
    data['officeId'] = this.officeId;
    data['otherMedicalHistory'] = this.otherMedicalHistory;
    data['paymentMethod'] = this.paymentMethod;
    if (this.preferredPharmacy != null) {
      data['preferredPharmacy'] = this.preferredPharmacy!.toJson();
    }
    if (this.problems != null) {
      data['problems'] = this.problems!.map((v) => v.toJson()).toList();
    }
    data['services'] = this.services;
    data['statusType'] = this.statusType;
    data['timeZonePlace'] = this.timeZonePlace;
    data['type'] = this.type;
    if (this.vitals != null) {
      data['vitals'] = this.vitals!.toJson();
    }
    data['medicationDetails'] = this.medicationDetails;
    data['previousAppointmentId'] = this.previousAppointmentId;
    data['parkingFee'] = this.parkingFee;
    data['parkingType'] = this.parkingType;
    data['instruction'] = this.instruction;
    data['userAddressId'] = this.userAddressId;
    data['parkingBay'] = this.parkingBay;
    if (this.socialHistory != null) {
      data['socialHistory'] = this.socialHistory!.toJson();
    }
    if (this.allergy != null) {
      data['allergy'] = this.allergy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookedMedicalHistory {
  String? name;
  int? year;
  String? month;

  BookedMedicalHistory({this.name, this.year, this.month});

  BookedMedicalHistory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    year = json['year'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['year'] = this.year;
    data['month'] = this.month;
    return data;
  }
}

class PreferredPharmacy {
  String? pharmacyId;

  PreferredPharmacy({this.pharmacyId});

  PreferredPharmacy.fromJson(Map<String, dynamic> json) {
    pharmacyId = json['pharmacyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pharmacyId'] = this.pharmacyId;
    return data;
  }
}

class Problems {
  List<BodyPartWithSide>? bodyPart;
  String? dailyActivity;
  String? image;
  String? isProblemImproving;
  String? isTreatmentReceived;
  String? name;
  List<String>? problemBetter;
  ProblemFacingTimeSpan? problemFacingTimeSpan;
  String? problemId;
  int? problemRating;
  List<String>? problemWorst;
  List<String>? symptoms;
  ProblemFacingTimeSpan? treatmentReceived;
  String? description;

  Problems(
      {this.bodyPart,
      this.dailyActivity,
      this.image,
      this.isProblemImproving,
      this.isTreatmentReceived,
      this.name,
      this.problemBetter,
      this.problemFacingTimeSpan,
      this.problemId,
      this.problemRating,
      this.problemWorst,
      this.symptoms,
      this.treatmentReceived,
      this.description});

  Problems.fromJson(Map<String, dynamic> json) {
    if (json['bodyPart'] != null) {
      bodyPart = <BodyPartWithSide>[];
      json['bodyPart'].forEach((v) {
        bodyPart!.add(new BodyPartWithSide.fromJson(v));
      });
    }
    dailyActivity = json['dailyActivity'];
    image = json['image'];
    isProblemImproving = json['isProblemImproving'];
    isTreatmentReceived = json['isTreatmentReceived'];
    name = json['name'];
    problemBetter = json['problemBetter'].cast<String>();
    problemFacingTimeSpan = json['problemFacingTimeSpan'] != null
        ? new ProblemFacingTimeSpan.fromJson(json['problemFacingTimeSpan'])
        : null;
    problemId = json['problemId'];
    problemRating = json['problemRating'];
    problemWorst = json['problemWorst'].cast<String>();
    symptoms = json['symptoms'].cast<String>();
    treatmentReceived = json['treatmentReceived'] != null
        ? new ProblemFacingTimeSpan.fromJson(json['treatmentReceived'])
        : null;
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bodyPart != null) {
      data['bodyPart'] = this.bodyPart!.map((v) => v.toJson()).toList();
    }
    data['dailyActivity'] = this.dailyActivity;
    data['image'] = this.image;
    data['isProblemImproving'] = this.isProblemImproving;
    data['isTreatmentReceived'] = this.isTreatmentReceived;
    data['name'] = this.name;
    data['problemBetter'] = this.problemBetter;
    if (this.problemFacingTimeSpan != null) {
      data['problemFacingTimeSpan'] = this.problemFacingTimeSpan!.toJson();
    }
    data['problemId'] = this.problemId;
    data['problemRating'] = this.problemRating;
    data['problemWorst'] = this.problemWorst;
    data['symptoms'] = this.symptoms;
    if (this.treatmentReceived != null) {
      data['treatmentReceived'] = this.treatmentReceived!.toJson();
    }
    data['description'] = description;
    return data;
  }
}

class BodyPartWithSide {
  String? name;
  String? sides;

  BodyPartWithSide({this.name, this.sides});

  BodyPartWithSide.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sides = json['sides'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['sides'] = this.sides;
    return data;
  }
}

class ProblemFacingTimeSpan {
  String? type;
  String? period;
  String? typeOfCare;

  ProblemFacingTimeSpan({this.type, this.period, this.typeOfCare});

  ProblemFacingTimeSpan.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    period = json['period'];
    typeOfCare = json['typeOfCare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['period'] = this.period;
    data['typeOfCare'] = this.typeOfCare;
    return data;
  }
}

class Vitals {
  String? date;
  String? time;
  int? bloodPressureSbp;
  int? bloodPressureDbp;
  int? heartRate;
  int? oxygenSaturation;
  double? temperature;
  double? height;
  double? weight;
  double? bmi;
  double? bloodGlucose;

  Vitals(
      {this.date,
      this.time,
      this.bloodPressureSbp,
      this.bloodPressureDbp,
      this.heartRate,
      this.oxygenSaturation,
      this.temperature,
      this.height,
      this.weight,
      this.bmi,
      this.bloodGlucose});

  Vitals.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    bloodPressureSbp = json['bloodPressureSbp'];
    bloodPressureDbp = json['bloodPressureDbp'];
    heartRate = json['heartRate'];
    oxygenSaturation = json['oxygenSaturation'];
    temperature = json['temperature'];
    height = json['height'];
    weight = json['weight'];
    bmi = json['bmi'];
    bloodGlucose = json['bloodGlucose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['bloodPressureSbp'] = this.bloodPressureSbp.toString();
    data['bloodPressureDbp'] = this.bloodPressureDbp.toString();
    data['heartRate'] = this.heartRate.toString();
    data['oxygenSaturation'] = this.oxygenSaturation.toString();
    data['temperature'] = this.temperature.toString();
    data['height'] = this.height.toString();
    data['weight'] = this.weight.toString();
    data['bmi'] = this.bmi.toString();
    data['bloodGlucose'] = this.bloodGlucose.toString();
    return data;
  }
}
