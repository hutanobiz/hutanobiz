class DoctorData {
  String? sId;
  String? userId;
  String? about;
  BusinessLocation? businessLocation;
  String? practicingSince;
  int? appointmentSetting;
  List<ConsultanceFee>? consultanceFee;
  double? distance;
  List<FollowUpFee>? followUpFee;
  bool? isLiveTrackable;
  bool? isOfficeEnabled;
  bool? isOnsiteEnabled;
  bool? isVideoChatEnabled;
  String? averageRating;
  List<User>? user;
  List<ProfessionalTitle>? professionalTitle;
  List<Specialties>? specialties;
  List<StateData>? state;
  List<CommomnConsultanceFee>? vedioConsultanceFee;
  List<CommomnConsultanceFee>? onsiteConsultanceFee;
  List<CommomnConsultanceFee>? officeConsultanceFee;

  DoctorData(
      {this.sId,
      this.userId,
      this.about,
      this.businessLocation,
      this.practicingSince,
      this.appointmentSetting,
      this.consultanceFee,
      this.distance,
      this.followUpFee,
      this.isLiveTrackable,
      this.isOfficeEnabled,
      this.isOnsiteEnabled,
      this.isVideoChatEnabled,
      this.averageRating,
      this.user,
      this.professionalTitle,
      this.officeConsultanceFee,
      this.onsiteConsultanceFee,
      this.vedioConsultanceFee,
      this.specialties,
      this.state});

  DoctorData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    about = json['about'];
    businessLocation = json['businessLocation'] != null
        ? new BusinessLocation.fromJson(json['businessLocation'])
        : null;
    practicingSince = json['practicingSince'];
    appointmentSetting = json['appointmentSetting'];
    if (json['consultanceFee'] != null) {
      consultanceFee = <ConsultanceFee>[];
      json['consultanceFee'].forEach((v) {
        consultanceFee!.add(new ConsultanceFee.fromJson(v));
      });
    }
    distance = json['distance'];
    averageRating = json['averageRating'].toString();
    if (json['followUpFee'] != null) {
      followUpFee = <FollowUpFee>[];
      json['followUpFee'].forEach((v) {
        followUpFee!.add(new FollowUpFee.fromJson(v));
      });
    }
    if (json['officeConsultanceFee'] != null) {
      officeConsultanceFee = <CommomnConsultanceFee>[];
      json['officeConsultanceFee'].forEach((v) {
        officeConsultanceFee!.add(new CommomnConsultanceFee.fromJson(v));
      });
    }
    if (json['onsiteConsultanceFee'] != null) {
      onsiteConsultanceFee = <CommomnConsultanceFee>[];
      json['onsiteConsultanceFee'].forEach((v) {
        onsiteConsultanceFee!.add(new CommomnConsultanceFee.fromJson(v));
      });
    }
    if (json['vedioConsultanceFee'] != null) {
      vedioConsultanceFee = <CommomnConsultanceFee>[];
      json['vedioConsultanceFee'].forEach((v) {
        vedioConsultanceFee!.add(new CommomnConsultanceFee.fromJson(v));
      });
    }
    isLiveTrackable = json['isLiveTrackable'];
    isOfficeEnabled = json['isOfficeEnabled'];
    isOnsiteEnabled = json['isOnsiteEnabled'];
    isVideoChatEnabled = json['isVideoChatEnabled'];
    if (json['User'] != null) {
      user = <User>[];
      json['User'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
    if (json['ProfessionalTitle'] != null) {
      professionalTitle = <ProfessionalTitle>[];
      json['ProfessionalTitle'].forEach((v) {
        professionalTitle!.add(new ProfessionalTitle.fromJson(v));
      });
    }
    if (json['Specialties'] != null) {
      specialties = <Specialties>[];
      json['Specialties'].forEach((v) {
        specialties!.add(new Specialties.fromJson(v));
      });
    }
    if (json['State'] != null) {
      state = <StateData>[];
      json['State'].forEach((v) {
        state!.add(new StateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['about'] = this.about;
    if (this.businessLocation != null) {
      data['businessLocation'] = this.businessLocation!.toJson();
    }
    data['practicingSince'] = this.practicingSince;
    data['averageRating'] = this.averageRating;
    data['appointmentSetting'] = this.appointmentSetting;
    if (this.consultanceFee != null) {
      data['consultanceFee'] =
          this.consultanceFee!.map((v) => v.toJson()).toList();
    }
    if (this.officeConsultanceFee != null) {
      data['officeConsultanceFee'] =
          this.officeConsultanceFee!.map((v) => v.toJson()).toList();
    }
    if (this.onsiteConsultanceFee != null) {
      data['onsiteConsultanceFee'] =
          this.onsiteConsultanceFee!.map((v) => v.toJson()).toList();
    }
    if (this.vedioConsultanceFee != null) {
      data['vedioConsultanceFee'] =
          this.vedioConsultanceFee!.map((v) => v.toJson()).toList();
    }
    data['distance'] = this.distance;
    if (this.followUpFee != null) {
      data['followUpFee'] = this.followUpFee!.map((v) => v.toJson()).toList();
    }
    data['isLiveTrackable'] = this.isLiveTrackable;
    data['isOfficeEnabled'] = this.isOfficeEnabled;
    data['isOnsiteEnabled'] = this.isOnsiteEnabled;
    data['isVideoChatEnabled'] = this.isVideoChatEnabled;
    if (this.user != null) {
      data['User'] = this.user!.map((v) => v.toJson()).toList();
    }
    if (this.professionalTitle != null) {
      data['ProfessionalTitle'] =
          this.professionalTitle!.map((v) => v.toJson()).toList();
    }
    if (this.specialties != null) {
      data['Specialties'] = this.specialties!.map((v) => v.toJson()).toList();
    }
    if (this.state != null) {
      data['StateData'] = this.state!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BusinessLocation {
  String? address;
  String? street;
  String? city;
  String? state;
  String? stateCode;
  String? zipCode;
  String? type;
  List<double>? coordinates;

  BusinessLocation(
      {this.address,
      this.street,
      this.city,
      this.state,
      this.stateCode,
      this.zipCode,
      this.type,
      this.coordinates});

  BusinessLocation.fromJson(Map<String, dynamic> json) {
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

class ConsultanceFee {
  int? fee;
  int? duration;

  ConsultanceFee({this.fee, this.duration});

  ConsultanceFee.fromJson(Map<String, dynamic> json) {
    fee = json['fee'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['duration'] = this.duration;
    return data;
  }
}

class User {
  String? sId;
  Location? location;
  String? fullName;
  String? firstName;
  String? lastName;
  String? dob;
  String? address;
  String? city;
  String? state;
  String? avatar;
  int? zipCode;
  String? phoneNumber;
  int? gender;
  List<String>? language;
  String? email;
  bool? isAbleTOReceiveOffersAndPromotions;
  bool? isAgreeTermsAndCondition;
  String? mobileCountryCode;
  String? verificationCodeSendAt;
  String? verificationCode;
  bool? isContactInformationVerified;
  bool? isEmailVerified;
  int? status;
  int? type;

  User(
      {this.sId,
      this.location,
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
      this.language,
      this.email,
      this.isAbleTOReceiveOffersAndPromotions,
      this.isAgreeTermsAndCondition,
      this.mobileCountryCode,
      this.verificationCodeSendAt,
      this.verificationCode,
      this.isContactInformationVerified,
      this.isEmailVerified,
      this.status,
      this.type});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
    phoneNumber = json['phoneNumber'].toString();
    gender = json['gender'];
    language = json['language'].cast<String>();
    email = json['email'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
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
    data['language'] = this.language;
    data['email'] = this.email;
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

class ProfessionalTitle {
  String? sId;
  String? title;
  String? image;
  int? status;

  ProfessionalTitle({this.sId, this.title, this.image, this.status});

  ProfessionalTitle.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}

class Specialties {
  String? sId;
  String? title;
  String? image;
  String? cover;
  bool? isFeatured;
  int? status;

  Specialties(
      {this.sId,
      this.title,
      this.image,
      this.cover,
      this.isFeatured,
      this.status});

  Specialties.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    image = json['image'];
    cover = json['cover'];
    isFeatured = json['isFeatured'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['cover'] = this.cover;
    data['isFeatured'] = this.isFeatured;
    data['status'] = this.status;
    return data;
  }
}

class StateData {
  String? sId;
  String? title;
  String? stateCode;

  StateData({this.sId, this.title, this.stateCode});

  StateData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    stateCode = json['stateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['stateCode'] = this.stateCode;
    return data;
  }
}

class FollowUpFee {
  int? fee;
  int? duration;

  FollowUpFee({this.fee, this.duration});

  FollowUpFee.fromJson(Map<String, dynamic> json) {
    fee = json['fee'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['duration'] = this.duration;
    return data;
  }
}

class CommomnConsultanceFee {
  int? fee;
  int? duration;
  String? sId;

  CommomnConsultanceFee({this.fee, this.duration, this.sId});

  CommomnConsultanceFee.fromJson(Map<String, dynamic> json) {
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
