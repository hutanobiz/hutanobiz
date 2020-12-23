class ResAppointmentDetail {
  String status;
  Response response;

  ResAppointmentDetail({this.status, this.response});

  ResAppointmentDetail.fromJson(Map<String, dynamic> json) {
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
  List<PresentRequest> presentRequest;

  Response({this.presentRequest});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['presentRequest'] != null) {
      presentRequest = new List<PresentRequest>();
      json['presentRequest'].forEach((v) {
        presentRequest.add(new PresentRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.presentRequest != null) {
      data['presentRequest'] =
          this.presentRequest.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PresentRequest {
  int count;
  String doctorName;
  List<String> medicalHistory;
  bool isFollowUp;
  String date;
  String fromTime;
  String toTime;
  String symptopmType;
  String sId;
  User user;
  Doctor doctor;
  List<GeneralInformation> generalInformation;
  String referenceId;
  String createdAt;
  String updatedAt;
  int iV;
  List<DoctorData> doctorData;
  int averageRating;

  PresentRequest(
      {this.count,
      this.doctorName,
      this.medicalHistory,
      this.isFollowUp,
      this.date,
      this.fromTime,
      this.toTime,
      this.symptopmType,
      this.sId,
      this.user,
      this.doctor,
      this.generalInformation,
      this.referenceId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.doctorData,
      this.averageRating});

  PresentRequest.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    doctorName = json['doctorName'];
    medicalHistory = json['medicalHistory'].cast<String>();
    isFollowUp = json['isFollowUp'];
    date = json['date'];
    fromTime = json['fromTime'];
    toTime = json['toTime'];
    symptopmType = json['symptopmType'];
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    doctor =
        json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    if (json['generalInformation'] != null) {
      generalInformation = new List<GeneralInformation>();
      json['generalInformation'].forEach((v) {
        generalInformation.add(new GeneralInformation.fromJson(v));
      });
    }
    referenceId = json['referenceId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['doctorData'] != null) {
      doctorData = new List<DoctorData>();
      json['doctorData'].forEach((v) {
        doctorData.add(new DoctorData.fromJson(v));
      });
    }
    averageRating = json['averageRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['doctorName'] = this.doctorName;
    data['medicalHistory'] = this.medicalHistory;
    data['isFollowUp'] = this.isFollowUp;
    data['date'] = this.date;
    data['fromTime'] = this.fromTime;
    data['toTime'] = this.toTime;
    data['symptopmType'] = this.symptopmType;
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    if (this.generalInformation != null) {
      data['generalInformation'] =
          this.generalInformation.map((v) => v.toJson()).toList();
    }
    data['referenceId'] = this.referenceId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.doctorData != null) {
      data['doctorData'] = this.doctorData.map((v) => v.toJson()).toList();
    }
    data['averageRating'] = this.averageRating;
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
  String phoneNumber;
  String sId;
  String createdAt;
  String updatedAt;

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
      this.sId,
      this.createdAt,
      this.updatedAt});

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
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
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
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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

class Doctor {
  Location location;
  String title;
  String fullName;
  String firstName;
  String lastName;
  String dob;
  String address;
  String city;
  String state;
  String avatar;
  int zipCode;
  String phoneNumber;
  String sId;
  String createdAt;
  String updatedAt;

  Doctor(
      {this.location,
      this.title,
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
      this.sId,
      this.createdAt,
      this.updatedAt});

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
    city = json['city'];
    state = json['state'];
    avatar = json['avatar'];
    zipCode = json['zipCode'];
    phoneNumber = json['phoneNumber'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    data['city'] = this.city;
    data['state'] = this.state;
    data['avatar'] = this.avatar;
    data['zipCode'] = this.zipCode;
    data['phoneNumber'] = this.phoneNumber;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class GeneralInformation {
  String question;
  String answer;
  String sId;

  GeneralInformation({this.question, this.answer, this.sId});

  GeneralInformation.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['_id'] = this.sId;
    return data;
  }
}

class DoctorData {
  BusinessLocation businessLocation;
  ProfessionalTitle professionalTitle;
  String practicingSince;
  bool isOfficeEnabled;
  bool isVideoChatEnabled;
  bool isOnsiteEnabled;
  String about;
  int appointmentSetting;
  int status;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;

  DoctorData(
      {this.businessLocation,
      this.professionalTitle,
      this.practicingSince,
      this.isOfficeEnabled,
      this.isVideoChatEnabled,
      this.isOnsiteEnabled,
      this.about,
      this.appointmentSetting,
      this.status,
      this.sId,
      this.userId,
      this.createdAt,
      this.updatedAt});

  DoctorData.fromJson(Map<String, dynamic> json) {
    businessLocation = json['businessLocation'] != null
        ? new BusinessLocation.fromJson(json['businessLocation'])
        : null;
    professionalTitle = json['professionalTitle'] != null
        ? new ProfessionalTitle.fromJson(json['professionalTitle'])
        : null;
    practicingSince = json['practicingSince'];
    isOfficeEnabled = json['isOfficeEnabled'];
    isVideoChatEnabled = json['isVideoChatEnabled'];
    isOnsiteEnabled = json['isOnsiteEnabled'];
    about = json['about'];
    appointmentSetting = json['appointmentSetting'];
    status = json['status'];
    sId = json['_id'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.businessLocation != null) {
      data['businessLocation'] = this.businessLocation.toJson();
    }
    if (this.professionalTitle != null) {
      data['professionalTitle'] = this.professionalTitle.toJson();
    }
    data['practicingSince'] = this.practicingSince;
    data['isOfficeEnabled'] = this.isOfficeEnabled;
    data['isVideoChatEnabled'] = this.isVideoChatEnabled;
    data['isOnsiteEnabled'] = this.isOnsiteEnabled;
    data['about'] = this.about;
    data['appointmentSetting'] = this.appointmentSetting;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class BusinessLocation {
  String address;
  String street;
  String city;
  States state;
  String zipCode;
  String type;
  List<double> coordinates;

  BusinessLocation(
      {this.address,
      this.street,
      this.city,
      this.state,
      this.zipCode,
      this.type,
      this.coordinates});

  BusinessLocation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    street = json['street'];
    city = json['city'];
    state = json['state'] != null ? new States.fromJson(json['state']) : null;
    zipCode = json['zipCode'];
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['street'] = this.street;
    data['city'] = this.city;
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    data['zipCode'] = this.zipCode;
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class States {
  String title;
  String stateCode;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  States(
      {this.title,
      this.stateCode,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  States.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    stateCode = json['stateCode'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['stateCode'] = this.stateCode;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ProfessionalTitle {
  String title;
  String image;
  int status;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  ProfessionalTitle(
      {this.title,
      this.image,
      this.status,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ProfessionalTitle.fromJson(Map<String, dynamic> json) {
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
