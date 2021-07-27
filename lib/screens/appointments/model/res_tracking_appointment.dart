class ResTrackingAppointment {
  String status;
  Response response;

  ResTrackingAppointment({this.status, this.response});

  ResTrackingAppointment.fromJson(Map<String, dynamic> json) {
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
  ProviderData providerData;
  String appointmentDate;
  String appointmentFromTime;
  AppointmentTrackData appointmentTrackData;

  Response(
      {this.providerData,
      this.appointmentDate,
      this.appointmentFromTime,
      this.appointmentTrackData});

  Response.fromJson(Map<String, dynamic> json) {
    providerData = json['providerData'] != null
        ? new ProviderData.fromJson(json['providerData'])
        : null;
    appointmentDate = json['appointmentDate'];
    appointmentFromTime = json['appointmentFromTime'];
    appointmentTrackData = json['appointmentTrackData'] != null
        ? new AppointmentTrackData.fromJson(json['appointmentTrackData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.providerData != null) {
      data['providerData'] = this.providerData.toJson();
    }
    data['appointmentDate'] = this.appointmentDate;
    data['appointmentFromTime'] = this.appointmentFromTime;
    if (this.appointmentTrackData != null) {
      data['appointmentTrackData'] = this.appointmentTrackData.toJson();
    }
    return data;
  }
}

class ProviderData {
  String sId;
  String firstName;
  String lastName;
  String avatar;
  List<DoctorDegree> doctorDegree;
  List<double> doctorLocation;
  String averageRating;

  ProviderData(
      {this.sId,
      this.firstName,
      this.lastName,
      this.avatar,
      this.doctorDegree,
      this.doctorLocation,
      this.averageRating = "0.0"});

  ProviderData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    avatar = json['avatar'];
    if (json['doctorDegree'] != null) {
      doctorDegree = new List<DoctorDegree>();
      json['doctorDegree'].forEach((v) {
        doctorDegree.add(new DoctorDegree.fromJson(v));
      });
    }
    doctorLocation = json['doctorLocation'].cast<double>();
    averageRating = json['averageRating'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['avatar'] = this.avatar;
    if (this.doctorDegree != null) {
      data['doctorDegree'] = this.doctorDegree.map((v) => v.toJson()).toList();
    }
    data['doctorLocation'] = this.doctorLocation;
    data['averageRating'] = this.averageRating;
    return data;
  }
}

class DoctorDegree {
  String degree;
  String year;
  String institute;
  String nId;

  DoctorDegree({this.degree, this.year, this.institute, this.nId});

  DoctorDegree.fromJson(Map<String, dynamic> json) {
    degree = json['degree'];
    year = json['year'];
    institute = json['institute'];
    nId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['degree'] = this.degree;
    data['year'] = this.year;
    data['institute'] = this.institute;
    data['_id'] = this.nId;
    return data;
  }
}

class AppointmentTrackData {
  String appointmentAccepted;
  String providerOfficeReady;
  String patientStartDriving;
  String patientArrived;
  String treatmentStarted;
  String providerTreatmentEnded;
  String patientTreatmentEnded;
  String feedback;

  AppointmentTrackData(
      {this.appointmentAccepted,
      this.providerOfficeReady,
      this.patientStartDriving,
      this.patientArrived,
      this.treatmentStarted,
      this.providerTreatmentEnded,
      this.patientTreatmentEnded,
      this.feedback});

  AppointmentTrackData.fromJson(Map<String, dynamic> json) {
    appointmentAccepted = json['appointmentAccepted'];
    providerOfficeReady = json['providerOfficeReady'];
    patientStartDriving = json['patientStartDriving'];
    patientArrived = json['patientArrived'];
    treatmentStarted = json['treatmentStarted'];
    providerTreatmentEnded = json['providerTreatmentEnded'];
    patientTreatmentEnded = json['patientTreatmentEnded'];
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentAccepted'] = this.appointmentAccepted;
    data['providerOfficeReady'] = this.providerOfficeReady;
    data['patientStartDriving'] = this.patientStartDriving;
    data['patientArrived'] = this.patientArrived;
    data['treatmentStarted'] = this.treatmentStarted;
    data['providerTreatmentEnded'] = this.providerTreatmentEnded;
    data['patientTreatmentEnded'] = this.patientTreatmentEnded;
    data['feedback'] = this.feedback;
    return data;
  }
}
