class SearchAppointmentData {
  String status;
  List<SearchAppointment> response;

  SearchAppointmentData({this.status, this.response});

  SearchAppointmentData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<SearchAppointment>();
      json['response'].forEach((v) {
        response.add(new SearchAppointment.fromJson(v));
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

class SearchAppointment {
  String sId;
  DoctorAddress doctorAddress;
  Location location;
  Residence residence;
  Parking parking;
  CardPayment cardPayment;
  AdverseEffectsOfTreatment adverseEffectsOfTreatment;
  PharmaceuticalsAdminstration pharmaceuticalsAdminstration;
  FollowUp followUp;
  TrackingStatus trackingStatus;
  TrackingStatusProvider trackingStatusProvider;
  UserAddress userAddress;
  VideoAppointmentStatus videoAppointmentStatus;
  Pharmacy pharmacy;
  Vitals vitals;
  int count;
  String officeId;
  String doctorName;
  // Null appointmentFor;
  int type;
  bool isFollowUp;
  String date;
  String fromTime;
  String toTime;
  bool consentToTreat;
  // Null problemTimeSpan;
  bool isProblemImproving;
  bool isTreatmentReceived;
  // Null description;
  // Null instructions;
  int paymentStatus;
  // Null insuranceId;
  // Null cashPayment;
  // Null recommendedFollowUpCare;
  // Null doctorSign;
  // Null cancelledReason;
  // Null cancellationFees;
  // Null cancelledBy;
  int status;
  // Null payment;
  int paymentMethod;
  int fees;
  double providerFees;
  double applicationFees;
  String paymentIntentId;
  // List<Null> disease;
  // Null otherMedicalHistory;
  String timeZonePlace;
  int feeType;
  int providerSubscriptionType;
  bool isUserJoin;
  bool isDoctorJoin;
  bool isRefund;
  bool isUserWantRejoin;
  bool isDoctorWantRejoin;
  bool isOndemand;
  bool isOndemandExpire;
  String user;
  List<Doctor> doctor;
  CardDetails cardDetails;
  // List<Null> medications;
  // List<Null> medicalDiagnostics;
  String referenceId;
  // List<Null> medicalImages;
  // List<Null> medicalDocuments;
  // List<Null> medicalHistory;
  // List<Null> consultanceFee;
  // List<Null> services;
  String createdAt;
  String updatedAt;
  int iV;

  SearchAppointment(
      {this.sId,
      this.doctorAddress,
      this.location,
      this.residence,
      this.parking,
      this.cardPayment,
      this.adverseEffectsOfTreatment,
      this.pharmaceuticalsAdminstration,
      this.followUp,
      this.trackingStatus,
      this.trackingStatusProvider,
      this.userAddress,
      this.videoAppointmentStatus,
      this.pharmacy,
      this.vitals,
      this.count,
      this.officeId,
      this.doctorName,
      // this.appointmentFor,
      this.type,
      this.isFollowUp,
      this.date,
      this.fromTime,
      this.toTime,
      this.consentToTreat,
      // this.problemTimeSpan,
      this.isProblemImproving,
      this.isTreatmentReceived,
      // this.description,
      // this.instructions,
      this.paymentStatus,
      // this.insuranceId,
      // this.cashPayment,
      // this.recommendedFollowUpCare,
      // this.doctorSign,
      // this.cancelledReason,
      // this.cancellationFees,
      // this.cancelledBy,
      this.status,
      // this.payment,
      this.paymentMethod,
      this.fees,
      this.providerFees,
      this.applicationFees,
      this.paymentIntentId,
      // this.disease,
      // this.otherMedicalHistory,
      this.timeZonePlace,
      this.feeType,
      this.providerSubscriptionType,
      this.isUserJoin,
      this.isDoctorJoin,
      this.isRefund,
      this.isUserWantRejoin,
      this.isDoctorWantRejoin,
      this.isOndemand,
      this.isOndemandExpire,
      this.user,
      this.doctor,
      this.cardDetails,
      // this.medications,
      // this.medicalDiagnostics,
      this.referenceId,
      // this.medicalImages,
      // this.medicalDocuments,
      // this.medicalHistory,
      // this.consultanceFee,
      // this.services,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SearchAppointment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    doctorAddress = json['doctorAddress'] != null
        ? new DoctorAddress.fromJson(json['doctorAddress'])
        : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    residence = json['residence'] != null
        ? new Residence.fromJson(json['residence'])
        : null;
    // parking =
    //     json['parking'] != null ? new Parking.fromJson(json['parking']) : null;
    // cardPayment = json['cardPayment'] != null
    //     ? new CardPayment.fromJson(json['cardPayment'])
    //     : null;
    // adverseEffectsOfTreatment = json['adverseEffectsOfTreatment'] != null
    //     ? new AdverseEffectsOfTreatment.fromJson(
    //         json['adverseEffectsOfTreatment'])
    //     : null;
    // pharmaceuticalsAdminstration = json['pharmaceuticalsAdminstration'] != null
    //     ? new PharmaceuticalsAdminstration.fromJson(
    //         json['pharmaceuticalsAdminstration'])
    //     : null;
    // followUp = json['followUp'] != null
    //     ? new FollowUp.fromJson(json['followUp'])
    //     : null;
    // trackingStatus = json['trackingStatus'] != null
    //     ? new TrackingStatus.fromJson(json['trackingStatus'])
    //     : null;
    // trackingStatusProvider = json['trackingStatusProvider'] != null
    //     ? new TrackingStatusProvider.fromJson(json['trackingStatusProvider'])
    //     : null;
    // userAddress = json['userAddress'] != null
    //     ? new UserAddress.fromJson(json['userAddress'])
    //     : null;
    // videoAppointmentStatus = json['videoAppointmentStatus'] != null
    //     ? new VideoAppointmentStatus.fromJson(json['videoAppointmentStatus'])
    //     : null;
    // pharmacy = json['pharmacy'] != null
    //     ? new Pharmacy.fromJson(json['pharmacy'])
    //     : null;
    // vitals =
    //     json['vitals'] != null ? new Vitals.fromJson(json['vitals']) : null;
    count = json['count'];
    officeId = json['officeId'];
    doctorName = json['doctorName'];
    // appointmentFor = json['appointmentFor'];
    type = json['type'];
    isFollowUp = json['isFollowUp'];
    date = json['date'];
    fromTime = json['fromTime'];
    toTime = json['toTime'];
    consentToTreat = json['consentToTreat'];
    // problemTimeSpan = json['problemTimeSpan'];
    isProblemImproving = json['isProblemImproving'];
    isTreatmentReceived = json['isTreatmentReceived'];
    // description = json['description'];
    // instructions = json['instructions'];
    paymentStatus = json['paymentStatus'];
    // insuranceId = json['insuranceId'];
    // cashPayment = json['cashPayment'];
    // recommendedFollowUpCare = json['recommendedFollowUpCare'];
    // doctorSign = json['doctorSign'];
    // cancelledReason = json['cancelledReason'];
    // cancellationFees = json['cancellationFees'];
    // cancelledBy = json['cancelledBy'];
    status = json['status'];
    // payment = json['payment'];
    paymentMethod = json['paymentMethod'];
    fees = json['fees'];
    providerFees = json['providerFees'];
    applicationFees = json['applicationFees'];
    paymentIntentId = json['paymentIntentId'];
    // if (json['disease'] != null) {
    //   disease = new List<Null>();
    //   json['disease'].forEach((v) {
    //     disease.add(new Null.fromJson(v));
    //   });
    // }
    // otherMedicalHistory = json['otherMedicalHistory'];
    timeZonePlace = json['timeZonePlace'];
    feeType = json['feeType'];
    providerSubscriptionType = json['providerSubscriptionType'];
    isUserJoin = json['isUserJoin'];
    isDoctorJoin = json['isDoctorJoin'];
    isRefund = json['isRefund'];
    isUserWantRejoin = json['isUserWantRejoin'];
    isDoctorWantRejoin = json['isDoctorWantRejoin'];
    isOndemand = json['isOndemand'];
    isOndemandExpire = json['isOndemandExpire'];
    user = json['user'];
    if (json['doctor'] != null) {
      doctor = new List<Doctor>();
      json['doctor'].forEach((v) {
        doctor.add(new Doctor.fromJson(v));
      });
    }
    cardDetails = json['cardDetails'] != null
        ? new CardDetails.fromJson(json['cardDetails'])
        : null;
    // if (json['medications'] != null) {
    //   medications = new List<Null>();
    //   json['medications'].forEach((v) {
    //     medications.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['medicalDiagnostics'] != null) {
    //   medicalDiagnostics = new List<Null>();
    //   json['medicalDiagnostics'].forEach((v) {
    //     medicalDiagnostics.add(new Null.fromJson(v));
    //   });
    // }
    // referenceId = json['referenceId'];
    // if (json['medicalImages'] != null) {
    //   medicalImages = new List<Null>();
    //   json['medicalImages'].forEach((v) {
    //     medicalImages.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['medicalDocuments'] != null) {
    //   medicalDocuments = new List<Null>();
    //   json['medicalDocuments'].forEach((v) {
    //     medicalDocuments.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['medicalHistory'] != null) {
    //   medicalHistory = new List<Null>();
    //   json['medicalHistory'].forEach((v) {
    //     medicalHistory.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['consultanceFee'] != null) {
    //   consultanceFee = new List<Null>();
    //   json['consultanceFee'].forEach((v) {
    //     consultanceFee.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['services'] != null) {
    //   services = new List<Null>();
    //   json['services'].forEach((v) {
    //     services.add(new Null.fromJson(v));
    //   });
    // }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.doctorAddress != null) {
      data['doctorAddress'] = this.doctorAddress.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.residence != null) {
      data['residence'] = this.residence.toJson();
    }
    if (this.parking != null) {
      data['parking'] = this.parking.toJson();
    }
    if (this.cardPayment != null) {
      data['cardPayment'] = this.cardPayment.toJson();
    }
    if (this.adverseEffectsOfTreatment != null) {
      data['adverseEffectsOfTreatment'] =
          this.adverseEffectsOfTreatment.toJson();
    }
    if (this.pharmaceuticalsAdminstration != null) {
      data['pharmaceuticalsAdminstration'] =
          this.pharmaceuticalsAdminstration.toJson();
    }
    if (this.followUp != null) {
      data['followUp'] = this.followUp.toJson();
    }
    if (this.trackingStatus != null) {
      data['trackingStatus'] = this.trackingStatus.toJson();
    }
    if (this.trackingStatusProvider != null) {
      data['trackingStatusProvider'] = this.trackingStatusProvider.toJson();
    }
    if (this.userAddress != null) {
      data['userAddress'] = this.userAddress.toJson();
    }
    if (this.videoAppointmentStatus != null) {
      data['videoAppointmentStatus'] = this.videoAppointmentStatus.toJson();
    }
    if (this.pharmacy != null) {
      data['pharmacy'] = this.pharmacy.toJson();
    }
    if (this.vitals != null) {
      data['vitals'] = this.vitals.toJson();
    }
    data['count'] = this.count;
    data['officeId'] = this.officeId;
    data['doctorName'] = this.doctorName;
    // data['appointmentFor'] = this.appointmentFor;
    data['type'] = this.type;
    data['isFollowUp'] = this.isFollowUp;
    data['date'] = this.date;
    data['fromTime'] = this.fromTime;
    data['toTime'] = this.toTime;
    data['consentToTreat'] = this.consentToTreat;
    // data['problemTimeSpan'] = this.problemTimeSpan;
    data['isProblemImproving'] = this.isProblemImproving;
    data['isTreatmentReceived'] = this.isTreatmentReceived;
    // data['description'] = this.description;
    // data['instructions'] = this.instructions;
    data['paymentStatus'] = this.paymentStatus;
    // data['insuranceId'] = this.insuranceId;
    // data['cashPayment'] = this.cashPayment;
    // data['recommendedFollowUpCare'] = this.recommendedFollowUpCare;
    // data['doctorSign'] = this.doctorSign;
    // data['cancelledReason'] = this.cancelledReason;
    // data['cancellationFees'] = this.cancellationFees;
    // data['cancelledBy'] = this.cancelledBy;
    data['status'] = this.status;
    // data['payment'] = this.payment;
    data['paymentMethod'] = this.paymentMethod;
    data['fees'] = this.fees;
    data['providerFees'] = this.providerFees;
    data['applicationFees'] = this.applicationFees;
    data['paymentIntentId'] = this.paymentIntentId;
    // if (this.disease != null) {
    //   data['disease'] = this.disease.map((v) => v.toJson()).toList();
    // }
    // data['otherMedicalHistory'] = this.otherMedicalHistory;
    data['timeZonePlace'] = this.timeZonePlace;
    data['feeType'] = this.feeType;
    data['providerSubscriptionType'] = this.providerSubscriptionType;
    data['isUserJoin'] = this.isUserJoin;
    data['isDoctorJoin'] = this.isDoctorJoin;
    data['isRefund'] = this.isRefund;
    data['isUserWantRejoin'] = this.isUserWantRejoin;
    data['isDoctorWantRejoin'] = this.isDoctorWantRejoin;
    data['isOndemand'] = this.isOndemand;
    data['isOndemandExpire'] = this.isOndemandExpire;
    data['user'] = this.user;
    if (this.doctor != null) {
      data['doctor'] = this.doctor.map((v) => v.toJson()).toList();
    }
    if (this.cardDetails != null) {
      data['cardDetails'] = this.cardDetails.toJson();
    }
    // if (this.medications != null) {
    //   data['medications'] = this.medications.map((v) => v.toJson()).toList();
    // }
    // if (this.medicalDiagnostics != null) {
    //   data['medicalDiagnostics'] =
    //       this.medicalDiagnostics.map((v) => v.toJson()).toList();
    // }
    // data['referenceId'] = this.referenceId;
    // if (this.medicalImages != null) {
    //   data['medicalImages'] =
    //       this.medicalImages.map((v) => v.toJson()).toList();
    // }
    // if (this.medicalDocuments != null) {
    //   data['medicalDocuments'] =
    //       this.medicalDocuments.map((v) => v.toJson()).toList();
    // }
    // if (this.medicalHistory != null) {
    //   data['medicalHistory'] =
    //       this.medicalHistory.map((v) => v.toJson()).toList();
    // }
    // if (this.consultanceFee != null) {
    //   data['consultanceFee'] =
    //       this.consultanceFee.map((v) => v.toJson()).toList();
    // }
    // if (this.services != null) {
    //   data['services'] = this.services.map((v) => v.toJson()).toList();
    // }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class DoctorAddress {
  String address;
  String street;
  String city;
  String state;
  Null stateCode;
  String zipCode;
  String type;
  List<double> coordinates;

  DoctorAddress(
      {this.address,
      this.street,
      this.city,
      this.state,
      this.stateCode,
      this.zipCode,
      this.type,
      this.coordinates});

  DoctorAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    stateCode = json['stateCode'];
    zipCode = json['zipCode'];
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['stateCode'] = this.stateCode;
    data['zipCode'] = this.zipCode;
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Location {
  String type;
  List<int> coordinates;

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

class Residence {
  Null type;
  Null roomNumber;

  Residence({this.type, this.roomNumber});

  Residence.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    roomNumber = json['roomNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['roomNumber'] = this.roomNumber;
    return data;
  }
}

class Parking {
  Null type;
  int fee;
  Null bay;

  Parking({this.type, this.fee, this.bay});

  Parking.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    fee = json['fee'];
    bay = json['bay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['fee'] = this.fee;
    data['bay'] = this.bay;
    return data;
  }
}

class CardPayment {
  String cardId;
  Null cardNumber;

  CardPayment({this.cardId, this.cardNumber});

  CardPayment.fromJson(Map<String, dynamic> json) {
    cardId = json['cardId'];
    cardNumber = json['cardNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardId'] = this.cardId;
    data['cardNumber'] = this.cardNumber;
    return data;
  }
}

class AdverseEffectsOfTreatment {
  Null adverseEffects;
  Null actionTaken;

  AdverseEffectsOfTreatment({this.adverseEffects, this.actionTaken});

  AdverseEffectsOfTreatment.fromJson(Map<String, dynamic> json) {
    adverseEffects = json['adverseEffects'];
    actionTaken = json['actionTaken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adverseEffects'] = this.adverseEffects;
    data['actionTaken'] = this.actionTaken;
    return data;
  }
}

class PharmaceuticalsAdminstration {
  Null drugs;
  Null administrationRoute;

  PharmaceuticalsAdminstration({this.drugs, this.administrationRoute});

  PharmaceuticalsAdminstration.fromJson(Map<String, dynamic> json) {
    drugs = json['drugs'];
    administrationRoute = json['administrationRoute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drugs'] = this.drugs;
    data['administrationRoute'] = this.administrationRoute;
    return data;
  }
}

class FollowUp {
  Null date;
  Null fromTime;
  Null toTime;
  Null fee;

  FollowUp({this.date, this.fromTime, this.toTime, this.fee});

  FollowUp.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    fromTime = json['fromTime'];
    toTime = json['toTime'];
    fee = json['fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['fromTime'] = this.fromTime;
    data['toTime'] = this.toTime;
    data['fee'] = this.fee;
    return data;
  }
}

class TrackingStatus {
  int status;
  Null patientStartDriving;
  Null patientArrived;
  Null treatmentStarted;
  Null providerTreatmentEnded;
  Null patientTreatmentEnded;

  TrackingStatus(
      {this.status,
      this.patientStartDriving,
      this.patientArrived,
      this.treatmentStarted,
      this.providerTreatmentEnded,
      this.patientTreatmentEnded});

  TrackingStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    patientStartDriving = json['patientStartDriving'];
    patientArrived = json['patientArrived'];
    treatmentStarted = json['treatmentStarted'];
    providerTreatmentEnded = json['providerTreatmentEnded'];
    patientTreatmentEnded = json['patientTreatmentEnded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['patientStartDriving'] = this.patientStartDriving;
    data['patientArrived'] = this.patientArrived;
    data['treatmentStarted'] = this.treatmentStarted;
    data['providerTreatmentEnded'] = this.providerTreatmentEnded;
    data['patientTreatmentEnded'] = this.patientTreatmentEnded;
    return data;
  }
}

class TrackingStatusProvider {
  int status;
  Null providerStartDriving;
  Null providerArrived;
  Null treatmentStarted;
  Null providerTreatmentEnded;
  Null patientTreatmentEnded;
  bool isProviderArrivedConfirm;

  TrackingStatusProvider(
      {this.status,
      this.providerStartDriving,
      this.providerArrived,
      this.treatmentStarted,
      this.providerTreatmentEnded,
      this.patientTreatmentEnded,
      this.isProviderArrivedConfirm});

  TrackingStatusProvider.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    providerStartDriving = json['providerStartDriving'];
    providerArrived = json['providerArrived'];
    treatmentStarted = json['treatmentStarted'];
    providerTreatmentEnded = json['providerTreatmentEnded'];
    patientTreatmentEnded = json['patientTreatmentEnded'];
    isProviderArrivedConfirm = json['isProviderArrivedConfirm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['providerStartDriving'] = this.providerStartDriving;
    data['providerArrived'] = this.providerArrived;
    data['treatmentStarted'] = this.treatmentStarted;
    data['providerTreatmentEnded'] = this.providerTreatmentEnded;
    data['patientTreatmentEnded'] = this.patientTreatmentEnded;
    data['isProviderArrivedConfirm'] = this.isProviderArrivedConfirm;
    return data;
  }
}

class UserAddress {
  Null title;
  Null addresstype;
  Null number;
  Null securityGate;
  Null address;
  Null street;
  Null city;
  Null state;
  Null stateCode;
  Null zipCode;
  String type;
  List<int> coordinates;
  Null nId;

  UserAddress(
      {this.title,
      this.addresstype,
      this.number,
      this.securityGate,
      this.address,
      this.street,
      this.city,
      this.state,
      this.stateCode,
      this.zipCode,
      this.type,
      this.coordinates,
      this.nId});

  UserAddress.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    addresstype = json['addresstype'];
    number = json['number'];
    securityGate = json['securityGate'];
    address = json['address'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    stateCode = json['stateCode'];
    zipCode = json['zipCode'];
    type = json['type'];
    coordinates = json['coordinates'].cast<int>();
    nId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['addresstype'] = this.addresstype;
    data['number'] = this.number;
    data['securityGate'] = this.securityGate;
    data['address'] = this.address;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['stateCode'] = this.stateCode;
    data['zipCode'] = this.zipCode;
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    data['_id'] = this.nId;
    return data;
  }
}

class VideoAppointmentStatus {
  int status;
  String startcallTime;
  String endcallTime;
  bool isPatientVideoCallStart;
  bool isDoctorVideoCallStart;

  VideoAppointmentStatus(
      {this.status,
      this.startcallTime,
      this.endcallTime,
      this.isPatientVideoCallStart,
      this.isDoctorVideoCallStart});

  VideoAppointmentStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    startcallTime = json['startcallTime'];
    endcallTime = json['endcallTime'];
    isPatientVideoCallStart = json['isPatientVideoCallStart'];
    isDoctorVideoCallStart = json['isDoctorVideoCallStart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['startcallTime'] = this.startcallTime;
    data['endcallTime'] = this.endcallTime;
    data['isPatientVideoCallStart'] = this.isPatientVideoCallStart;
    data['isDoctorVideoCallStart'] = this.isDoctorVideoCallStart;
    return data;
  }
}

class Pharmacy {
  Address address;
  Null name;

  Pharmacy({this.address, this.name});

  Pharmacy.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class Address {
  Null address;
  Null city;
  Null phone;
  Null state;
  Null zipCode;

  Address({this.address, this.city, this.phone, this.state, this.zipCode});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    phone = json['phone'];
    state = json['state'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['phone'] = this.phone;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    return data;
  }
}

class Vitals {
  String bloodPressureDbp;
  String bloodPressureSbp;
  String date;
  String heartRate;
  String oxygenSaturation;
  String temperature;
  String time;

  Vitals(
      {this.bloodPressureDbp,
      this.bloodPressureSbp,
      this.date,
      this.heartRate,
      this.oxygenSaturation,
      this.temperature,
      this.time});

  Vitals.fromJson(Map<String, dynamic> json) {
    bloodPressureDbp = json['bloodPressureDbp'];
    bloodPressureSbp = json['bloodPressureSbp'];
    date = json['date'];
    heartRate = json['heartRate'];
    oxygenSaturation = json['oxygenSaturation'];
    temperature = json['temperature'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bloodPressureDbp'] = this.bloodPressureDbp;
    data['bloodPressureSbp'] = this.bloodPressureSbp;
    data['date'] = this.date;
    data['heartRate'] = this.heartRate;
    data['oxygenSaturation'] = this.oxygenSaturation;
    data['temperature'] = this.temperature;
    data['time'] = this.time;
    return data;
  }
}

class Doctor {
  Location location;
  String title;
  String fullName;
  String firstName;
  String lastName;
  String dob;
  String address;
  Null addressTitle;
  Null addresstype;
  String addressNumber;
  String city;
  String state;
  String avatar;
  int zipCode;
  int phoneNumber;
  int gender;
  List<String> language;
  String email;
  String password;
  bool isAbleTOReceiveOffersAndPromotions;
  bool isAgreeTermsAndCondition;
  Null mobileCountryCode;
  String verificationCodeSendAt;
  String verificationCode;
  bool isContactInformationVerified;
  bool isEmailVerified;
  int status;
  int type;
  int resetPasswordVerificationCode;
  String resetPasswordVerificationCodeSentAt;
  bool isResetPasswordOTPVerified;
  String stripeCustomerId;
  String stripeConnectAccount;
  bool isStripeAcoountVerified;
  String ssn;
  bool isOtpValid;
  int wallet;
  bool isResetPinOTPVerified;
  Null resetPinVerificationCode;
  Null resetPinVerificationCodeSentAt;
  Null pin;
  Null referredByUserId;
  String sId;
  List<Null> insurance;
  List<Tokens> tokens;
  String createdAt;
  String updatedAt;
  int iV;
  StripeVerificationRequirements stripeVerificationRequirements;
  String webhookTest;
  List<Null> familyMembers;
  List<Null> providerNetwork;
  List<Null> familyNetwork;

  Doctor(
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
      this.language,
      this.email,
      this.password,
      this.isAbleTOReceiveOffersAndPromotions,
      this.isAgreeTermsAndCondition,
      this.mobileCountryCode,
      this.verificationCodeSendAt,
      this.verificationCode,
      this.isContactInformationVerified,
      this.isEmailVerified,
      this.status,
      this.type,
      this.resetPasswordVerificationCode,
      this.resetPasswordVerificationCodeSentAt,
      this.isResetPasswordOTPVerified,
      this.stripeCustomerId,
      this.stripeConnectAccount,
      this.isStripeAcoountVerified,
      this.ssn,
      this.isOtpValid,
      this.wallet,
      this.isResetPinOTPVerified,
      this.resetPinVerificationCode,
      this.resetPinVerificationCodeSentAt,
      this.pin,
      this.referredByUserId,
      this.sId,
      this.insurance,
      this.tokens,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.stripeVerificationRequirements,
      this.webhookTest,
      this.familyMembers,
      this.providerNetwork,
      this.familyNetwork});

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
    password = json['password'];
    isAbleTOReceiveOffersAndPromotions =
        json['isAbleTOReceiveOffersAndPromotions'];
    isAgreeTermsAndCondition = json['isAgreeTermsAndCondition'];
    mobileCountryCode = json['mobileCountryCode'];
    verificationCodeSendAt = json['verificationCodeSendAt'];
    verificationCode = json['verificationCode'];
    isContactInformationVerified = json['isContactInformationVerified'];
    isEmailVerified = json['isEmailVerified'];
    status = json['status'];
    type = json['type'];
    resetPasswordVerificationCode = json['resetPasswordVerificationCode'];
    resetPasswordVerificationCodeSentAt =
        json['resetPasswordVerificationCodeSentAt'];
    isResetPasswordOTPVerified = json['isResetPasswordOTPVerified'];
    stripeCustomerId = json['stripeCustomerId'];
    stripeConnectAccount = json['stripeConnectAccount'];
    isStripeAcoountVerified = json['isStripeAcoountVerified'];
    ssn = json['ssn'];
    isOtpValid = json['isOtpValid'];
    wallet = json['wallet'];
    isResetPinOTPVerified = json['isResetPinOTPVerified'];
    resetPinVerificationCode = json['resetPinVerificationCode'];
    resetPinVerificationCodeSentAt = json['resetPinVerificationCodeSentAt'];
    pin = json['pin'];
    referredByUserId = json['referredByUserId'];
    sId = json['_id'];
    // if (json['insurance'] != null) {
    //   insurance = new List<Null>();
    //   json['insurance'].forEach((v) {
    //     insurance.add(new Null.fromJson(v));
    //   });
    // }
    if (json['tokens'] != null) {
      tokens = new List<Tokens>();
      json['tokens'].forEach((v) {
        tokens.add(new Tokens.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    stripeVerificationRequirements =
        json['stripeVerificationRequirements'] != null
            ? new StripeVerificationRequirements.fromJson(
                json['stripeVerificationRequirements'])
            : null;
    webhookTest = json['webhookTest'];
    // if (json['familyMembers'] != null) {
    //   familyMembers = new List<Null>();
    //   json['familyMembers'].forEach((v) {
    //     familyMembers.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['providerNetwork'] != null) {
    //   providerNetwork = new List<Null>();
    //   json['providerNetwork'].forEach((v) {
    //     providerNetwork.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['familyNetwork'] != null) {
    //   familyNetwork = new List<Null>();
    //   json['familyNetwork'].forEach((v) {
    //     familyNetwork.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
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
    data['password'] = this.password;
    data['isAbleTOReceiveOffersAndPromotions'] =
        this.isAbleTOReceiveOffersAndPromotions;
    data['isAgreeTermsAndCondition'] = this.isAgreeTermsAndCondition;
    data['mobileCountryCode'] = this.mobileCountryCode;
    data['verificationCodeSendAt'] = this.verificationCodeSendAt;
    data['verificationCode'] = this.verificationCode;
    data['isContactInformationVerified'] = this.isContactInformationVerified;
    data['isEmailVerified'] = this.isEmailVerified;
    data['status'] = this.status;
    data['type'] = this.type;
    data['resetPasswordVerificationCode'] = this.resetPasswordVerificationCode;
    data['resetPasswordVerificationCodeSentAt'] =
        this.resetPasswordVerificationCodeSentAt;
    data['isResetPasswordOTPVerified'] = this.isResetPasswordOTPVerified;
    data['stripeCustomerId'] = this.stripeCustomerId;
    data['stripeConnectAccount'] = this.stripeConnectAccount;
    data['isStripeAcoountVerified'] = this.isStripeAcoountVerified;
    data['ssn'] = this.ssn;
    data['isOtpValid'] = this.isOtpValid;
    data['wallet'] = this.wallet;
    data['isResetPinOTPVerified'] = this.isResetPinOTPVerified;
    data['resetPinVerificationCode'] = this.resetPinVerificationCode;
    data['resetPinVerificationCodeSentAt'] =
        this.resetPinVerificationCodeSentAt;
    data['pin'] = this.pin;
    data['referredByUserId'] = this.referredByUserId;
    data['_id'] = this.sId;
    // if (this.insurance != null) {
    //   data['insurance'] = this.insurance.map((v) => v.toJson()).toList();
    // }
    if (this.tokens != null) {
      data['tokens'] = this.tokens.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.stripeVerificationRequirements != null) {
      data['stripeVerificationRequirements'] =
          this.stripeVerificationRequirements.toJson();
    }
    data['webhookTest'] = this.webhookTest;
    // if (this.familyMembers != null) {
    //   data['familyMembers'] =
    //       this.familyMembers.map((v) => v.toJson()).toList();
    // }
    // if (this.providerNetwork != null) {
    //   data['providerNetwork'] =
    //       this.providerNetwork.map((v) => v.toJson()).toList();
    // }
    // if (this.familyNetwork != null) {
    //   data['familyNetwork'] =
    //       this.familyNetwork.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Tokens {
  String sId;
  String access;
  String token;

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

class StripeVerificationRequirements {
  Null currentDeadline;
  List<Null> currentlyDue;
  String disabledReason;
  List<Null> errors;
  List<Null> eventuallyDue;
  List<String> pastDue;
  List<Null> pendingVerification;

  StripeVerificationRequirements(
      {this.currentDeadline,
      this.currentlyDue,
      this.disabledReason,
      this.errors,
      this.eventuallyDue,
      this.pastDue,
      this.pendingVerification});

  StripeVerificationRequirements.fromJson(Map<String, dynamic> json) {
    currentDeadline = json['current_deadline'];
    // if (json['currently_due'] != null) {
    //   currentlyDue = new List<Null>();
    //   json['currently_due'].forEach((v) {
    //     currentlyDue.add(new Null.fromJson(v));
    //   });
    // }
    // disabledReason = json['disabled_reason'];
    // if (json['errors'] != null) {
    //   errors = new List<Null>();
    //   json['errors'].forEach((v) {
    //     errors.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['eventually_due'] != null) {
    //   eventuallyDue = new List<Null>();
    //   json['eventually_due'].forEach((v) {
    //     eventuallyDue.add(new Null.fromJson(v));
    //   });
    // }
    pastDue = json['past_due'].cast<String>();
    // if (json['pending_verification'] != null) {
    //   pendingVerification = new List<Null>();
    //   json['pending_verification'].forEach((v) {
    //     pendingVerification.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_deadline'] = this.currentDeadline;
    // if (this.currentlyDue != null) {
    //   data['currently_due'] = this.currentlyDue.map((v) => v.toJson()).toList();
    // }
    // data['disabled_reason'] = this.disabledReason;
    // if (this.errors != null) {
    //   data['errors'] = this.errors.map((v) => v.toJson()).toList();
    // }
    // if (this.eventuallyDue != null) {
    //   data['eventually_due'] =
    //       this.eventuallyDue.map((v) => v.toJson()).toList();
    // }
    // data['past_due'] = this.pastDue;
    // if (this.pendingVerification != null) {
    //   data['pending_verification'] =
    //       this.pendingVerification.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class CardDetails {
  String id;
  String object;
  BillingDetails billingDetails;
  Card card;
  int created;
  String customer;
  bool livemode;
  String type;

  CardDetails(
      {this.id,
      this.object,
      this.billingDetails,
      this.card,
      this.created,
      this.customer,
      this.livemode,
      this.type});

  CardDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    billingDetails = json['billing_details'] != null
        ? new BillingDetails.fromJson(json['billing_details'])
        : null;
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
    created = json['created'];
    customer = json['customer'];
    livemode = json['livemode'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    if (this.billingDetails != null) {
      data['billing_details'] = this.billingDetails.toJson();
    }
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    data['created'] = this.created;
    data['customer'] = this.customer;
    data['livemode'] = this.livemode;
    data['type'] = this.type;
    return data;
  }
}

class BillingDetails {
  Address address;
  Null email;
  String name;
  Null phone;

  BillingDetails({this.address, this.email, this.name, this.phone});

  BillingDetails.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}

// class Address {
//   Null city;
//   Null country;
//   Null line1;
//   Null line2;
//   Null postalCode;
//   Null state;

//   Address(
//       {this.city,
//       this.country,
//       this.line1,
//       this.line2,
//       this.postalCode,
//       this.state});

//   Address.fromJson(Map<String, dynamic> json) {
//     city = json['city'];
//     country = json['country'];
//     line1 = json['line1'];
//     line2 = json['line2'];
//     postalCode = json['postal_code'];
//     state = json['state'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['city'] = this.city;
//     // data['country'] = this.country;
//     // data['line1'] = this.line1;
//     // data['line2'] = this.line2;
//     // data['postal_code'] = this.postalCode;
//     data['state'] = this.state;
//     return data;
//   }
// }

class Card {
  String brand;
  Checks checks;
  String country;
  int expMonth;
  int expYear;
  String fingerprint;
  String funding;
  Null generatedFrom;
  String last4;
  Networks networks;
  ThreeDSecureUsage threeDSecureUsage;
  Null wallet;

  Card(
      {this.brand,
      this.checks,
      this.country,
      this.expMonth,
      this.expYear,
      this.fingerprint,
      this.funding,
      this.generatedFrom,
      this.last4,
      this.networks,
      this.threeDSecureUsage,
      this.wallet});

  Card.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    checks =
        json['checks'] != null ? new Checks.fromJson(json['checks']) : null;
    country = json['country'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    funding = json['funding'];
    generatedFrom = json['generated_from'];
    last4 = json['last4'];
    networks = json['networks'] != null
        ? new Networks.fromJson(json['networks'])
        : null;
    threeDSecureUsage = json['three_d_secure_usage'] != null
        ? new ThreeDSecureUsage.fromJson(json['three_d_secure_usage'])
        : null;
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this.brand;
    if (this.checks != null) {
      data['checks'] = this.checks.toJson();
    }
    data['country'] = this.country;
    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['fingerprint'] = this.fingerprint;
    data['funding'] = this.funding;
    data['generated_from'] = this.generatedFrom;
    data['last4'] = this.last4;
    if (this.networks != null) {
      data['networks'] = this.networks.toJson();
    }
    if (this.threeDSecureUsage != null) {
      data['three_d_secure_usage'] = this.threeDSecureUsage.toJson();
    }
    data['wallet'] = this.wallet;
    return data;
  }
}

class Checks {
  Null addressLine1Check;
  Null addressPostalCodeCheck;
  String cvcCheck;

  Checks({this.addressLine1Check, this.addressPostalCodeCheck, this.cvcCheck});

  Checks.fromJson(Map<String, dynamic> json) {
    addressLine1Check = json['address_line1_check'];
    addressPostalCodeCheck = json['address_postal_code_check'];
    cvcCheck = json['cvc_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line1_check'] = this.addressLine1Check;
    data['address_postal_code_check'] = this.addressPostalCodeCheck;
    data['cvc_check'] = this.cvcCheck;
    return data;
  }
}

class Networks {
  List<String> available;
  Null preferred;

  Networks({this.available, this.preferred});

  Networks.fromJson(Map<String, dynamic> json) {
    available = json['available'].cast<String>();
    preferred = json['preferred'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available'] = this.available;
    data['preferred'] = this.preferred;
    return data;
  }
}

class ThreeDSecureUsage {
  bool supported;

  ThreeDSecureUsage({this.supported});

  ThreeDSecureUsage.fromJson(Map<String, dynamic> json) {
    supported = json['supported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supported'] = this.supported;
    return data;
  }
}
