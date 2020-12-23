import '../../provider_add_network/model/provider_network.dart';
import '../../provider_search/model/doctor_data_model.dart';

class ResMyProviderNetwork {
  String status;
  Response response;

  ResMyProviderNetwork({this.status, this.response});

  ResMyProviderNetwork.fromJson(Map<String, dynamic> json) {
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
  List<ProviderGroupList> data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProviderGroupList>();
      json['data'].forEach((v) {
        data.add(new ProviderGroupList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProviderGroupList {
  String sId;
  int type;
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
  int gender;
  ProviderNetwork providerNetwork;
  List<Doctor> doctor;
  List<DoctorData> docInfo;

  ProviderGroupList(
      {this.sId,
      this.type,
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
      this.gender,
      this.providerNetwork,
      this.doctor,
      this.docInfo});

  ProviderGroupList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
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
    gender = json['gender'];
    providerNetwork = json['providerNetwork'] != null
        ? new ProviderNetwork.fromJson(json['providerNetwork'])
        : null;
    if (json['Doctor'] != null) {
      doctor = new List<Doctor>();
      json['Doctor'].forEach((v) {
        doctor.add(new Doctor.fromJson(v));
      });
    }
    if (json['docInfo'] != null) {
      docInfo = new List<DoctorData>();
      json['docInfo'].forEach((v) {
        docInfo.add(new DoctorData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
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
    data['gender'] = this.gender;
    if (this.providerNetwork != null) {
      data['providerNetwork'] = this.providerNetwork.toJson();
    }
    if (this.doctor != null) {
      data['Doctor'] = this.doctor.map((v) => v.toJson()).toList();
    }
    if (this.docInfo != null) {
      data['docInfo'] = this.docInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Doctor {
  String sId;
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
  int gender;
  List<String> language;
  int type;

  Doctor(
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
      this.type});

  Doctor.fromJson(Map<String, dynamic> json) {
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
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    language = json['language'].cast<String>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
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
    data['gender'] = this.gender;
    data['language'] = this.language;
    data['type'] = this.type;
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
