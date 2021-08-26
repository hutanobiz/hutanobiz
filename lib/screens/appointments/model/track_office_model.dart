

class TrackOfficeModelData {
  String status;
  TrackOfficeModel response;

  TrackOfficeModelData({this.status, this.response});

  TrackOfficeModelData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new TrackOfficeModel.fromJson(json['response'])
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

class TrackOfficeModel {
  String currentDate;
  Data data;
  List<AppointmentProblems> appointmentProblems;
  List<DoctorFeedBack> doctorFeedBack;
  List<DoctorData> doctorData;
  int averageRating;
  List<Reason> reason;
  MedicalHistory medicalHistory;
  double distance;
  Degree degree;
  DoctorConfigration doctorConfigration;

  TrackOfficeModel(
      {this.currentDate,
      this.data,
      this.appointmentProblems,
      this.doctorFeedBack,
      this.doctorData,
      this.averageRating,
      this.reason,
      this.medicalHistory,
      this.distance,
      this.degree,
      this.doctorConfigration});

  TrackOfficeModel.fromJson(Map<String, dynamic> json) {
    currentDate = json['currentDate'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;

    if (json['appointmentProblems'] != null) {
      appointmentProblems = new List<AppointmentProblems>();
      json['appointmentProblems'].forEach((v) {
        appointmentProblems.add(new AppointmentProblems.fromJson(v));
      });
    }
    if (json['doctorFeedBack'] != null) {
      doctorFeedBack = new List<DoctorFeedBack>();
      json['doctorFeedBack'].forEach((v) {
        doctorFeedBack.add(new DoctorFeedBack.fromJson(v));
      });
    }

     averageRating = json['averageRating'];
    if (json['reason'] != null) {
      reason = new List<Reason>();
      json['reason'].forEach((v) {
        reason.add(new Reason.fromJson(v));
      });
    }

    medicalHistory = json['medicalHistory'] != null
        ? new MedicalHistory.fromJson(json['medicalHistory'])
        : null;
    distance = json['distance'];
    degree =
        json['degree'] != null ? new Degree.fromJson(json['degree']) : null;
    doctorConfigration = json['doctorConfigration'] != null
        ? new DoctorConfigration.fromJson(json['doctorConfigration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentDate'] = this.currentDate;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }

    if (this.appointmentProblems != null) {
      data['appointmentProblems'] =
          this.appointmentProblems.map((v) => v.toJson()).toList();
    }
    if (this.doctorFeedBack != null) {
      data['doctorFeedBack'] =
          this.doctorFeedBack.map((v) => v.toJson()).toList();
    }
    if (this.doctorData != null) {
      data['doctorData'] = this.doctorData.map((v) => v.toJson()).toList();
    }
    data['averageRating'] = this.averageRating;
    if (this.reason != null) {
      data['reason'] = this.reason.map((v) => v.toJson()).toList();
    }

    if (this.medicalHistory != null) {
      data['medicalHistory'] = this.medicalHistory.toJson();
    }
    data['distance'] = this.distance;
    if (this.degree != null) {
      data['degree'] = this.degree.toJson();
    }
    if (this.doctorConfigration != null) {
      data['doctorConfigration'] = this.doctorConfigration.toJson();
    }
    return data;
  }
}

class Data {
  DoctorAddress doctorAddress;
  Location location;
  TrackingStatus trackingStatus;
  Pharmacy pharmacy;
  int count;
  String officeId;
  String doctorName;
  int type;
  bool isFollowUp;
  String date;
  String fromTime;
  String toTime;
  bool consentToTreat;
  bool isProblemImproving;
  bool isTreatmentReceived;
  int paymentStatus;
  String doctorSign;
  int status;
  int paymentMethod;
  int fees;
  double providerFees;
  double applicationFees;
  String paymentIntentId;
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
  String sId;
  User user;
  Doctor doctor;
  CardDetails cardDetails;
  List<MedicalHistory> medicalHistory;
  List<Medications> medications;
  String referenceId;
  String createdAt;
  String updatedAt;
  int iV;

  Data(
      {this.doctorAddress,
      this.location,
      this.trackingStatus,
      this.pharmacy,
      this.count,
      this.officeId,
      this.doctorName,
      this.type,
      this.isFollowUp,
      this.date,
      this.fromTime,
      this.toTime,
      this.consentToTreat,
      this.isTreatmentReceived,
      this.paymentStatus,
      this.doctorSign,
      this.status,
      this.paymentMethod,
      this.fees,
      this.providerFees,
      this.applicationFees,
      this.paymentIntentId,
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
      this.sId,
      this.user,
      this.doctor,
      this.cardDetails,
      this.medicalHistory,
      this.medications,
      this.referenceId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    doctorAddress = json['doctorAddress'] != null
        ? new DoctorAddress.fromJson(json['doctorAddress'])
        : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;

    trackingStatus = json['trackingStatus'] != null
        ? new TrackingStatus.fromJson(json['trackingStatus'])
        : null;

    pharmacy = json['pharmacy'] != null
        ? new Pharmacy.fromJson(json['pharmacy'])
        : null;

    count = json['count'];
    officeId = json['officeId'];
    doctorName = json['doctorName'];
    type = json['type'];
    isFollowUp = json['isFollowUp'];
    date = json['date'];
    fromTime = json['fromTime'];
    toTime = json['toTime'];
    consentToTreat = json['consentToTreat'];
    isProblemImproving = json['isProblemImproving'];
    isTreatmentReceived = json['isTreatmentReceived'];
    paymentStatus = json['paymentStatus'];
    doctorSign = json['doctorSign'];
    status = json['status'];
    paymentMethod = json['paymentMethod'];
    fees = json['fees'];
    providerFees = json['providerFees'];
    applicationFees = json['applicationFees'];
    paymentIntentId = json['paymentIntentId'];
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
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    doctor =
        json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    cardDetails = json['cardDetails'] != null
        ? new CardDetails.fromJson(json['cardDetails'])
        : null;
    if (json['medicalHistory'] != null) {
      medicalHistory = new List<MedicalHistory>();
      json['medicalHistory'].forEach((v) {
        medicalHistory.add(new MedicalHistory.fromJson(v));
      });
    }
    if (json['medications'] != null) {
      medications = new List<Medications>();
      json['medications'].forEach((v) {
        medications.add(new Medications.fromJson(v));
      });
    }
    referenceId = json['referenceId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorAddress != null) {
      data['doctorAddress'] = this.doctorAddress.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }

    if (this.trackingStatus != null) {
      data['trackingStatus'] = this.trackingStatus.toJson();
    }
    if (this.pharmacy != null) {
      data['pharmacy'] = this.pharmacy.toJson();
    }

    data['count'] = this.count;
    data['officeId'] = this.officeId;
    data['doctorName'] = this.doctorName;
    data['type'] = this.type;
    data['isFollowUp'] = this.isFollowUp;
    data['date'] = this.date;
    data['fromTime'] = this.fromTime;
    data['toTime'] = this.toTime;
    data['consentToTreat'] = this.consentToTreat;
    data['isProblemImproving'] = this.isProblemImproving;
    data['isTreatmentReceived'] = this.isTreatmentReceived;
    data['paymentStatus'] = this.paymentStatus;
    data['doctorSign'] = this.doctorSign;
    data['status'] = this.status;
    data['paymentMethod'] = this.paymentMethod;
    data['fees'] = this.fees;
    data['providerFees'] = this.providerFees;
    data['applicationFees'] = this.applicationFees;
    data['paymentIntentId'] = this.paymentIntentId;
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
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    if (this.cardDetails != null) {
      data['cardDetails'] = this.cardDetails.toJson();
    }
    if (this.medicalHistory != null) {
      data['medicalHistory'] =
          this.medicalHistory.map((v) => v.toJson()).toList();
    }
    if (this.medications != null) {
      data['medications'] = this.medications.map((v) => v.toJson()).toList();
    }
    data['referenceId'] = this.referenceId;

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
  String zipCode;
  String type;
  List<double> coordinates;

  DoctorAddress(
      {this.address,
      this.street,
      this.city,
      this.state,
      this.zipCode,
      this.type,
      this.coordinates});

  DoctorAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
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

class TrackingStatus {
  int status;
  String patientStartDriving;
  String patientArrived;
  String treatmentStarted;
  String providerTreatmentEnded;
  String patientTreatmentEnded;

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

class Pharmacy {
  Address address;
  String name;

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
  String address;
  String city;
  String phone;
  String state;
  String zipCode;

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

class User {
  Location location;
  String fullName;
  String firstName;
  String lastName;
  String dob;
  String address;
  String city;
  String state;
  String avatar;
  int zipCode;
  int phoneNumber;
  int gender;
  String email;
  String password;
  bool isAbleTOReceiveOffersAndPromotions;
  bool isAgreeTermsAndCondition;
  String mobileCountryCode;
  String verificationCodeSendAt;
  String verificationCode;
  bool isContactInformationVerified;
  bool isEmailVerified;
  int status;
  int type;
  bool isResetPasswordOTPVerified;
  String stripeCustomerId;
  bool isStripeAcoountVerified;
  bool isOtpValid;
  int wallet;
  bool isResetPinOTPVerified;
  String sId;
  List<Tokens> tokens;

  String createdAt;
  String updatedAt;
  int iV;

  User(
      {this.location,
      this.fullName,
      this.firstName,
      this.lastName,
      this.dob,
      this.address,
      this.city,
      this.state,
      this.avatar,
      this.zipCode,
      this.phoneNumber,
      this.gender,
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
      this.isResetPasswordOTPVerified,
      this.stripeCustomerId,
      this.isStripeAcoountVerified,
      this.isOtpValid,
      this.wallet,
      this.isResetPinOTPVerified,
      this.sId,
      this.tokens,
      this.createdAt,
      this.updatedAt,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    fullName = json['fullName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    avatar = json['avatar'];
    zipCode = json['zipCode'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];

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
    isResetPasswordOTPVerified = json['isResetPasswordOTPVerified'];
    stripeCustomerId = json['stripeCustomerId'];
    isStripeAcoountVerified = json['isStripeAcoountVerified'];

    isOtpValid = json['isOtpValid'];
    wallet = json['wallet'];
    isResetPinOTPVerified = json['isResetPinOTPVerified'];
    sId = json['_id'];

    if (json['tokens'] != null) {
      tokens = new List<Tokens>();
      json['tokens'].forEach((v) {
        tokens.add(new Tokens.fromJson(v));
      });
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    // data['title'] = this.title;
    data['fullName'] = this.fullName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['avatar'] = this.avatar;
    data['zipCode'] = this.zipCode;
    data['phoneNumber'] = this.phoneNumber;
    data['gender'] = this.gender;

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
    data['isResetPasswordOTPVerified'] = this.isResetPasswordOTPVerified;
    data['stripeCustomerId'] = this.stripeCustomerId;
    data['isStripeAcoountVerified'] = this.isStripeAcoountVerified;
    data['isOtpValid'] = this.isOtpValid;
    data['wallet'] = this.wallet;
    data['isResetPinOTPVerified'] = this.isResetPinOTPVerified;
    data['_id'] = this.sId;

    if (this.tokens != null) {
      data['tokens'] = this.tokens.map((v) => v.toJson()).toList();
    }

    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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

class Doctor {
  Location location;
  String title;
  String fullName;
  String firstName;
  String lastName;
  String dob;
  String address;
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
  String verificationCodeSendAt;
  bool isContactInformationVerified;
  bool isEmailVerified;
  int status;
  int type;
  bool isResetPasswordOTPVerified;
  String stripeCustomerId;
  String stripeConnectAccount;
  bool isStripeAcoountVerified;
  String ssn;
  bool isOtpValid;
  int wallet;
  bool isResetPinOTPVerified;
  String sId;
  List<Tokens> tokens;
  String createdAt;
  String updatedAt;
  int iV;
  String webhookTest;

  Doctor(
      {this.location,
      this.title,
      this.fullName,
      this.firstName,
      this.lastName,
      this.dob,
      this.address,
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
      this.verificationCodeSendAt,
      this.isContactInformationVerified,
      this.isEmailVerified,
      this.status,
      this.type,
      this.isResetPasswordOTPVerified,
      this.stripeCustomerId,
      this.stripeConnectAccount,
      this.isStripeAcoountVerified,
      this.ssn,
      this.isOtpValid,
      this.wallet,
      this.isResetPinOTPVerified,
      this.sId,
      this.tokens,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.webhookTest});

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
    verificationCodeSendAt = json['verificationCodeSendAt'];
    isContactInformationVerified = json['isContactInformationVerified'];
    isEmailVerified = json['isEmailVerified'];
    status = json['status'];
    type = json['type'];
    isResetPasswordOTPVerified = json['isResetPasswordOTPVerified'];
    stripeCustomerId = json['stripeCustomerId'];
    stripeConnectAccount = json['stripeConnectAccount'];
    isStripeAcoountVerified = json['isStripeAcoountVerified'];
    ssn = json['ssn'];
    isOtpValid = json['isOtpValid'];
    wallet = json['wallet'];
    isResetPinOTPVerified = json['isResetPinOTPVerified'];
    sId = json['_id'];

    if (json['tokens'] != null) {
      tokens = new List<Tokens>();
      json['tokens'].forEach((v) {
        tokens.add(new Tokens.fromJson(v));
      });
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];

    webhookTest = json['webhookTest'];
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
    data['verificationCodeSendAt'] = this.verificationCodeSendAt;
    data['isContactInformationVerified'] = this.isContactInformationVerified;
    data['isEmailVerified'] = this.isEmailVerified;
    data['status'] = this.status;
    data['type'] = this.type;
    data['isResetPasswordOTPVerified'] = this.isResetPasswordOTPVerified;
    data['stripeCustomerId'] = this.stripeCustomerId;
    data['stripeConnectAccount'] = this.stripeConnectAccount;
    data['isStripeAcoountVerified'] = this.isStripeAcoountVerified;
    data['ssn'] = this.ssn;
    data['isOtpValid'] = this.isOtpValid;
    data['wallet'] = this.wallet;
    data['isResetPinOTPVerified'] = this.isResetPinOTPVerified;
    data['_id'] = this.sId;
    if (this.tokens != null) {
      data['tokens'] = this.tokens.map((v) => v.toJson()).toList();
    }

    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;

    data['webhookTest'] = this.webhookTest;
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

  BillingDetails({this.address});

  BillingDetails.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }

    return data;
  }
}

class Card {
  String brand;
  String country;
  int expMonth;
  int expYear;
  String fingerprint;
  String funding;
  String last4;

  Card(
      {this.brand,
      this.country,
      this.expMonth,
      this.expYear,
      this.fingerprint,
      this.funding,
      this.last4});

  Card.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    country = json['country'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    funding = json['funding'];
    last4 = json['last4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this.brand;

    data['country'] = this.country;
    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['fingerprint'] = this.fingerprint;
    data['funding'] = this.funding;
    data['last4'] = this.last4;

    return data;
  }
}

class MedicalHistory {
  String name;
  String year;
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

class AppointmentProblems {
  String name;
  String image;
  List<String> symptoms;
  List<String> problemBetter;
  List<String> problemWorst;
  int problemRating;
  String dailyActivity;
  int isProblemImproving;
  int isTreatmentReceived;
  String sId;
  List<BodyPart> bodyPart;
  ProblemFacingTimeSpan problemFacingTimeSpan;
  String problemId;
  ProblemFacingTimeSpan treatmentReceived;
  String userId;
  String appointmentId;
  String createdAt;
  String updatedAt;
  int iV;

  AppointmentProblems(
      {this.name,
      this.image,
      this.symptoms,
      this.problemBetter,
      this.problemWorst,
      this.problemRating,
      this.dailyActivity,
      this.isProblemImproving,
      this.isTreatmentReceived,
      this.sId,
      this.bodyPart,
      this.problemFacingTimeSpan,
      this.problemId,
      this.treatmentReceived,
      this.userId,
      this.appointmentId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AppointmentProblems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    symptoms = json['symptoms'].cast<String>();
    problemBetter = json['problemBetter'].cast<String>();
    problemWorst = json['problemWorst'].cast<String>();
    problemRating = json['problemRating'];
    dailyActivity = json['dailyActivity'];
    isProblemImproving = json['isProblemImproving'];
    isTreatmentReceived = json['isTreatmentReceived'];
    sId = json['_id'];
    if (json['bodyPart'] != null) {
      bodyPart = new List<BodyPart>();
      json['bodyPart'].forEach((v) {
        bodyPart.add(new BodyPart.fromJson(v));
      });
    }
    problemFacingTimeSpan = json['problemFacingTimeSpan'] != null
        ? new ProblemFacingTimeSpan.fromJson(json['problemFacingTimeSpan'])
        : null;
    problemId = json['problemId'];
    treatmentReceived = json['treatmentReceived'] != null
        ? new ProblemFacingTimeSpan.fromJson(json['treatmentReceived'])
        : null;
    userId = json['userId'];
    appointmentId = json['appointmentId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['symptoms'] = this.symptoms;
    data['problemBetter'] = this.problemBetter;
    data['problemWorst'] = this.problemWorst;
    data['problemRating'] = this.problemRating;
    data['dailyActivity'] = this.dailyActivity;
    data['isProblemImproving'] = this.isProblemImproving;
    data['isTreatmentReceived'] = this.isTreatmentReceived;
    data['_id'] = this.sId;
    if (this.bodyPart != null) {
      data['bodyPart'] = this.bodyPart.map((v) => v.toJson()).toList();
    }
    if (this.problemFacingTimeSpan != null) {
      data['problemFacingTimeSpan'] = this.problemFacingTimeSpan.toJson();
    }
    data['problemId'] = this.problemId;
    if (this.treatmentReceived != null) {
      data['treatmentReceived'] = this.treatmentReceived.toJson();
    }
    data['userId'] = this.userId;
    data['appointmentId'] = this.appointmentId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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

class ProblemFacingTimeSpan {
  String type;
  String period;

  ProblemFacingTimeSpan({this.type, this.period});

  ProblemFacingTimeSpan.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    period = json['period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['period'] = this.period;
    return data;
  }
}

class DoctorFeedBack {
  String sId;
  String appointmentId;
  String doctorId;
  String createdAt;
  String updatedAt;
  int iV;

  DoctorFeedBack(
      {this.sId,
      this.appointmentId,
      this.doctorId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  DoctorFeedBack.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    appointmentId = json['appointmentId'];
    doctorId = json['doctorId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['_id'] = this.sId;
    data['appointmentId'] = this.appointmentId;
    data['doctorId'] = this.doctorId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class DoctorData {
  BusinessLocation businessLocation;
  PaymentMethod paymentMethod;
  bool isLiveTrackable;
  ProfessionalTitle professionalTitle;
  String practicingSince;
  List<Specialties> specialties;
  bool isOfficeEnabled;
  bool isVideoChatEnabled;
  bool isOnsiteEnabled;
  String about;
  int appointmentSetting;
  int status;
  String sId;
  String userId;
  int iV;
  String createdAt;
  String updatedAt;
  List<Education> education;
  List<LicenseDetails> licenseDetails;

  List<OfficeConsultanceFee> officeConsultanceFee;
  List<Schedules> schedules;

  DoctorData(
      {this.businessLocation,
      this.paymentMethod,
      this.isLiveTrackable,
      this.professionalTitle,
      this.practicingSince,
      this.specialties,
      this.isOfficeEnabled,
      this.isVideoChatEnabled,
      this.isOnsiteEnabled,
      this.about,
      this.appointmentSetting,
      this.status,
      this.sId,
      this.userId,
      this.iV,
      this.createdAt,
      this.updatedAt,
      this.education,
      this.licenseDetails,
      this.officeConsultanceFee,
      this.schedules});

  DoctorData.fromJson(Map<String, dynamic> json) {
    businessLocation = json['businessLocation'] != null
        ? new BusinessLocation.fromJson(json['businessLocation'])
        : null;

    paymentMethod = json['paymentMethod'] != null
        ? new PaymentMethod.fromJson(json['paymentMethod'])
        : null;
    isLiveTrackable = json['isLiveTrackable'];
    professionalTitle = json['professionalTitle'] != null
        ? new ProfessionalTitle.fromJson(json['professionalTitle'])
        : null;
    practicingSince = json['practicingSince'];
    if (json['specialties'] != null) {
      specialties = new List<Specialties>();
      json['specialties'].forEach((v) {
        specialties.add(new Specialties.fromJson(v));
      });
    }
    isOfficeEnabled = json['isOfficeEnabled'];
    isVideoChatEnabled = json['isVideoChatEnabled'];
    isOnsiteEnabled = json['isOnsiteEnabled'];
    about = json['about'];
    appointmentSetting = json['appointmentSetting'];

    status = json['status'];
    sId = json['_id'];
    userId = json['userId'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['education'] != null) {
      education = new List<Education>();
      json['education'].forEach((v) {
        education.add(new Education.fromJson(v));
      });
    }
    if (json['licenseDetails'] != null) {
      licenseDetails = new List<LicenseDetails>();
      json['licenseDetails'].forEach((v) {
        licenseDetails.add(new LicenseDetails.fromJson(v));
      });
    }

    if (json['officeConsultanceFee'] != null) {
      officeConsultanceFee = new List<OfficeConsultanceFee>();
      json['officeConsultanceFee'].forEach((v) {
        officeConsultanceFee.add(new OfficeConsultanceFee.fromJson(v));
      });
    }

    if (json['schedules'] != null) {
      schedules = new List<Schedules>();
      json['schedules'].forEach((v) {
        schedules.add(new Schedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.businessLocation != null) {
      data['businessLocation'] = this.businessLocation.toJson();
    }
    if (this.paymentMethod != null) {
      data['paymentMethod'] = this.paymentMethod.toJson();
    }
    data['isLiveTrackable'] = this.isLiveTrackable;
    if (this.professionalTitle != null) {
      data['professionalTitle'] = this.professionalTitle.toJson();
    }
    data['practicingSince'] = this.practicingSince;
    if (this.specialties != null) {
      data['specialties'] = this.specialties.map((v) => v.toJson()).toList();
    }
    data['isOfficeEnabled'] = this.isOfficeEnabled;
    data['isVideoChatEnabled'] = this.isVideoChatEnabled;
    data['isOnsiteEnabled'] = this.isOnsiteEnabled;
    data['about'] = this.about;
    data['appointmentSetting'] = this.appointmentSetting;

    data['status'] = this.status;
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.education != null) {
      data['education'] = this.education.map((v) => v.toJson()).toList();
    }
    if (this.licenseDetails != null) {
      data['licenseDetails'] =
          this.licenseDetails.map((v) => v.toJson()).toList();
    }

    if (this.officeConsultanceFee != null) {
      data['officeConsultanceFee'] =
          this.officeConsultanceFee.map((v) => v.toJson()).toList();
    }

    if (this.schedules != null) {
      data['schedules'] = this.schedules.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class BusinessLocation {
  String address;
  String street;
  String city;
  // State state;
  String zipCode;
  String type;
  List<double> coordinates;
  String suite;
  String saveAs;

  BusinessLocation(
      {this.address,
      this.street,
      this.city,
      // this.state,
      this.zipCode,
      this.type,
      this.coordinates,
      this.suite,
      this.saveAs});

  BusinessLocation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    street = json['street'];
    city = json['city'];
    // state = json['state'] != null ? new State.fromJson(json['state']) : null;
    zipCode = json['zipCode'];
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
    suite = json['suite'];
    saveAs = json['saveAs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['street'] = this.street;
    data['city'] = this.city;
    // if (this.state != null) {
    //   data['state'] = this.state.toJson();
    // }
    data['zipCode'] = this.zipCode;
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    data['suite'] = this.suite;
    data['saveAs'] = this.saveAs;
    return data;
  }
}

// class State {
//   String title;
//   String stateCode;
//   String sId;
//   String createdAt;
//   String updatedAt;
//   int iV;

//   State(
//       {this.title,
//       this.stateCode,
//       this.sId,
//       this.createdAt,
//       this.updatedAt,
//       this.iV});

//   State.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     stateCode = json['stateCode'];
//     sId = json['_id'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     data['stateCode'] = this.stateCode;
//     data['_id'] = this.sId;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }

class PaymentMethod {
  int cardPayment;
  int cashPayment;

  PaymentMethod({this.cardPayment, this.cashPayment});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    cardPayment = json['cardPayment'];
    cashPayment = json['cashPayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardPayment'] = this.cardPayment;
    data['cashPayment'] = this.cashPayment;
    return data;
  }
}

class ProfessionalTitle {
  String title;
  int status;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  ProfessionalTitle(
      {this.title,
      this.status,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ProfessionalTitle.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    status = json['status'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Specialties {
  String title;
  String image;
  int status;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  Specialties(
      {this.title,
      this.image,
      this.status,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Specialties.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    status = json['status'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image'] = this.image;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Education {
  String degree;
  String year;
  String institute;

  Education({this.degree, this.year, this.institute});

  Education.fromJson(Map<String, dynamic> json) {
    degree = json['degree'];
    year = json['year'];
    institute = json['institute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['degree'] = this.degree;
    data['year'] = this.year;
    data['institute'] = this.institute;
    return data;
  }
}

class LicenseDetails {
  String licenseNumber;
  String licenseState;
  String expirationDate;
  int restriction;
  String licenseImageFront;
  String npiNumber;
  String deaNumber;
  String sId;

  LicenseDetails(
      {this.licenseNumber,
      this.licenseState,
      this.expirationDate,
      this.restriction,
      this.licenseImageFront,
      this.npiNumber,
      this.deaNumber,
      this.sId});

  LicenseDetails.fromJson(Map<String, dynamic> json) {
    licenseNumber = json['licenseNumber'];
    licenseState = json['licenseState'];
    expirationDate = json['expirationDate'];
    restriction = json['restriction'];
    licenseImageFront = json['licenseImageFront'];
    npiNumber = json['npiNumber'];
    deaNumber = json['deaNumber'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['licenseNumber'] = this.licenseNumber;
    data['licenseState'] = this.licenseState;
    data['expirationDate'] = this.expirationDate;
    data['restriction'] = this.restriction;
    data['licenseImageFront'] = this.licenseImageFront;
    data['npiNumber'] = this.npiNumber;
    data['deaNumber'] = this.deaNumber;
    data['_id'] = this.sId;
    return data;
  }
}

class OfficeConsultanceFee {
  int fee;
  int duration;
  String sId;

  OfficeConsultanceFee({this.fee, this.duration, this.sId});

  OfficeConsultanceFee.fromJson(Map<String, dynamic> json) {
    fee = json['fee'];
    duration = json['duration'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['duration'] = this.duration;
    data['_id'] = this.sId;
    return data;
  }
}

class Schedules {
  int scheduleType;
  int scheduleAppointmentType;
  String addressId;
  List<int> day;
  bool isEveryYear;
  String sId;
  List<Session> session;

  Schedules(
      {this.scheduleType,
      this.scheduleAppointmentType,
      this.addressId,
      this.day,
      this.isEveryYear,
      this.sId,
      this.session});

  Schedules.fromJson(Map<String, dynamic> json) {
    scheduleType = json['scheduleType'];
    scheduleAppointmentType = json['scheduleAppointmentType'];
    addressId = json['addressId'];
    day = json['day'].cast<int>();
    isEveryYear = json['isEveryYear'];
    sId = json['_id'];
    if (json['session'] != null) {
      session = new List<Session>();
      json['session'].forEach((v) {
        session.add(new Session.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheduleType'] = this.scheduleType;
    data['scheduleAppointmentType'] = this.scheduleAppointmentType;
    data['addressId'] = this.addressId;
    data['day'] = this.day;
    data['isEveryYear'] = this.isEveryYear;
    data['_id'] = this.sId;
    if (this.session != null) {
      data['session'] = this.session.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Session {
  String fromTime;
  String toTime;
  String sId;

  Session({this.fromTime, this.toTime, this.sId});

  Session.fromJson(Map<String, dynamic> json) {
    fromTime = json['fromTime'];
    toTime = json['toTime'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromTime'] = this.fromTime;
    data['toTime'] = this.toTime;
    data['_id'] = this.sId;
    return data;
  }
}

class Reason {
  String appointment;
  User user;
  int userType;
  int rating;
  List<String> reason;
  String review;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  Reason(
      {this.appointment,
      this.user,
      this.userType,
      this.rating,
      this.reason,
      this.review,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Reason.fromJson(Map<String, dynamic> json) {
    appointment = json['appointment'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userType = json['userType'];
    rating = json['rating'];
    reason = json['reason'].cast<String>();
    review = json['review'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment'] = this.appointment;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['userType'] = this.userType;
    data['rating'] = this.rating;
    data['reason'] = this.reason;
    data['review'] = this.review;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
  Null size;
  String sId;

  MedicalDocuments(
      {this.medicalDocuments,
      this.type,
      this.name,
      this.date,
      this.size,
      this.sId});

  MedicalDocuments.fromJson(Map<String, dynamic> json) {
    medicalDocuments = json['medicalDocuments'];
    type = json['type'];
    name = json['name'];
    date = json['date'];
    size = json['size'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalDocuments'] = this.medicalDocuments;
    data['type'] = this.type;
    data['name'] = this.name;
    data['date'] = this.date;
    data['size'] = this.size;
    data['_id'] = this.sId;
    return data;
  }
}

class MedicalDiagnostics {
  String image;
  String type;
  String name;
  String date;
  String sId;

  MedicalDiagnostics({this.image, this.type, this.name, this.date, this.sId});

  MedicalDiagnostics.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    type = json['type'];
    name = json['name'];
    date = json['date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['type'] = this.type;
    data['name'] = this.name;
    data['date'] = this.date;
    data['_id'] = this.sId;
    return data;
  }
}

class PreferredPharmacy {
  Address address;
  String name;
  String sId;

  PreferredPharmacy({this.address, this.name, this.sId});

  PreferredPharmacy.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['name'] = this.name;
    data['_id'] = this.sId;
    return data;
  }
}

class Degree {
  String s1;
  String s2;
  String s3;
  String s4;
  String s5;
  String s6;
  String s7;

  Degree({this.s1, this.s2, this.s3, this.s4, this.s5, this.s6, this.s7});

  Degree.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
    s6 = json['6'];
    s7 = json['7'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    data['6'] = this.s6;
    data['7'] = this.s7;
    return data;
  }
}

class DoctorConfigration {
  String s1;
  String s2;
  String s3;
  String s4;
  String s5;

  DoctorConfigration({this.s1, this.s2, this.s3, this.s4, this.s5});

  DoctorConfigration.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    return data;
  }
}
