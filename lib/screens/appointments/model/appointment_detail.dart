class AppointmentData {
  List<Medications> medications;
  PreferredPhramacy pharmacy;
  List<AppointmentProblems> appointmentProblems;
  List<DoctorFeedback> doctorFeedback;

  AppointmentData(
      {this.pharmacy,
      this.medications,
      this.appointmentProblems,
      this.doctorFeedback});

  AppointmentData.fromJson(Map<String, dynamic> json) {
    pharmacy = json['pharmacy'] != null && json['pharmacy']['name'] != null
        ? new PreferredPhramacy.fromJson(json['pharmacy'])
        : null;

    if (json['medications'] != null) {
      medications = new List<Medications>();
      json['medications'].forEach((v) {
        medications.add(new Medications.fromJson(v));
      });
    }
    if (json['appointmentProblems'] != null) {
      appointmentProblems = new List<AppointmentProblems>();
      json['appointmentProblems'].forEach((v) {
        appointmentProblems.add(new AppointmentProblems.fromJson(v));
      });
    }
    if (json['doctorFeedBack'] != null) {
      doctorFeedback = new List<DoctorFeedback>();
      json['doctorFeedBack'].forEach((v) {
        doctorFeedback.add(new DoctorFeedback.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.pharmacy != null) {
      data['pharmacy'] = this.pharmacy.toJson();
    }

    if (this.medications != null) {
      data['medications'] = this.medications.map((v) => v.toJson()).toList();
    }
    if (this.appointmentProblems != null) {
      data['appointmentProblems'] =
          this.appointmentProblems.map((v) => v.toJson()).toList();
    }
    // if (this.doctorFeedback != null) {
    //   data['doctorFeedback'] = this.doctorFeedback.toJson();
    // }

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

class AppointmentProblems {
  String sId;
  String name;
  String image;
  List<String> symptoms;
  // List<Null> problemBetter;
  // List<Null> problemWorst;
  int problemRating;
  String dailyActivity;
  // Null isProblemImproving;
  // Null isTreatmentReceived;
  String description;
  String problemId;
  List<BodyPart> bodyPart;
  ProblemFacingTimeSpan problemFacingTimeSpan;
  TreatmentReceived treatmentReceived;
  String userId;
  String appointmentId;
  String createdAt;
  String updatedAt;
  int iV;

  AppointmentProblems(
      {this.sId,
      this.name,
      this.image,
      this.symptoms,
      // this.problemBetter,
      // this.problemWorst,
      this.problemRating,
      this.dailyActivity,
      // this.isProblemImproving,
      // this.isTreatmentReceived,
      this.description,
      this.problemId,
      this.bodyPart,
      this.problemFacingTimeSpan,
      this.treatmentReceived,
      this.userId,
      this.appointmentId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AppointmentProblems.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
    symptoms = json['symptoms'].cast<String>();
    // if (json['problemBetter'] != null) {
    //   problemBetter = new List<Null>();
    //   json['problemBetter'].forEach((v) {
    //     problemBetter.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['problemWorst'] != null) {
    //   problemWorst = new List<Null>();
    //   json['problemWorst'].forEach((v) {
    //     problemWorst.add(new Null.fromJson(v));
    //   });
    // }
    problemRating = json['problemRating'];
    dailyActivity = json['dailyActivity'];
    // isProblemImproving = json['isProblemImproving'];
    // isTreatmentReceived = json['isTreatmentReceived'];
    description = json['description'];
    problemId = json['problemId'];
    if (json['bodyPart'] != null) {
      bodyPart = new List<BodyPart>();
      json['bodyPart'].forEach((v) {
        bodyPart.add(new BodyPart.fromJson(v));
      });
    }
    problemFacingTimeSpan = json['problemFacingTimeSpan'] != null
        ? new ProblemFacingTimeSpan.fromJson(json['problemFacingTimeSpan'])
        : null;
    treatmentReceived = json['treatmentReceived'] != null
        ? new TreatmentReceived.fromJson(json['treatmentReceived'])
        : null;
    userId = json['userId'];
    appointmentId = json['appointmentId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['symptoms'] = this.symptoms;
    // if (this.problemBetter != null) {
    //   data['problemBetter'] =
    //       this.problemBetter.map((v) => v.toJson()).toList();
    // }
    // if (this.problemWorst != null) {
    //   data['problemWorst'] = this.problemWorst.map((v) => v.toJson()).toList();
    // }
    data['problemRating'] = this.problemRating;
    data['dailyActivity'] = this.dailyActivity;
    // data['isProblemImproving'] = this.isProblemImproving;
    // data['isTreatmentReceived'] = this.isTreatmentReceived;
    data['description'] = this.description;
    data['problemId'] = this.problemId;
    if (this.bodyPart != null) {
      data['bodyPart'] = this.bodyPart.map((v) => v.toJson()).toList();
    }
    if (this.problemFacingTimeSpan != null) {
      data['problemFacingTimeSpan'] = this.problemFacingTimeSpan.toJson();
    }
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

class TreatmentReceived {
  String type;
  String period;
  String typeOfCare;

  TreatmentReceived({this.type, this.period, this.typeOfCare});

  TreatmentReceived.fromJson(Map<String, dynamic> json) {
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

class DoctorFeedback {
  String sId;
  ImagingDetails imagingDetails;
  LabDetails labDetails;
  PrescriptionDetails prescriptionDetails;
  Vitals vitals;
  HeartAndLungs heartAndLungs;
  Neurological neurological;
  Musculoskeletal musculoskeletal;
  SpecialTests specialTests;
  AnthropometricMeasurements anthropometricMeasurements;
  TherapeuticIntervention therapeuticIntervention;
  String otherComments;
  String appointmentId;
  String doctorId;
  ExerciseDetails exerciseDetails;
  List<Education> education;
  String createdAt;
  String updatedAt;
  int iV;

  DoctorFeedback(
      {this.sId,
      this.imagingDetails,
      this.labDetails,
      this.prescriptionDetails,
      this.vitals,
      this.heartAndLungs,
      this.neurological,
      this.musculoskeletal,
      this.specialTests,
      this.anthropometricMeasurements,
      this.therapeuticIntervention,
      this.otherComments,
      this.appointmentId,
      this.doctorId,
      this.exerciseDetails,
      this.education,
      this.createdAt,
      this.updatedAt,
      this.iV});

  DoctorFeedback.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    imagingDetails = json['imagingDetails'] != null
        ? new ImagingDetails.fromJson(json['imagingDetails'])
        : null;
    labDetails = json['labDetails'] != null
        ? new LabDetails.fromJson(json['labDetails'])
        : null;
    prescriptionDetails = json['prescriptionDetails'] != null
        ? new PrescriptionDetails.fromJson(json['prescriptionDetails'])
        : null;
    vitals =
        json['vitals'] != null ? new Vitals.fromJson(json['vitals']) : null;
    heartAndLungs = json['heartAndLungs'] != null
        ? new HeartAndLungs.fromJson(json['heartAndLungs'])
        : null;
    neurological = json['neurological'] != null
        ? new Neurological.fromJson(json['neurological'])
        : null;
    musculoskeletal = json['musculoskeletal'] != null
        ? new Musculoskeletal.fromJson(json['musculoskeletal'])
        : null;
    specialTests = json['specialTests'] != null
        ? new SpecialTests.fromJson(json['specialTests'])
        : null;
    anthropometricMeasurements = json['anthropometricMeasurements'] != null
        ? new AnthropometricMeasurements.fromJson(
            json['anthropometricMeasurements'])
        : null;
    therapeuticIntervention = json['therapeuticIntervention'] != null
        ? new TherapeuticIntervention.fromJson(json['therapeuticIntervention'])
        : null;
    otherComments = json['otherComments'];
    appointmentId = json['appointmentId'];
    doctorId = json['doctorId'];
    exerciseDetails = json['exerciseDetails'] != null
        ? new ExerciseDetails.fromJson(json['exerciseDetails'])
        : null;

    if (json['education'] != null) {
      education = new List<Education>();
      json['education'].forEach((v) {
        education.add(new Education.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.imagingDetails != null) {
      data['imagingDetails'] = this.imagingDetails.toJson();
    }
    if (this.labDetails != null) {
      data['labDetails'] = this.labDetails.toJson();
    }
    if (this.prescriptionDetails != null) {
      data['prescriptionDetails'] = this.prescriptionDetails.toJson();
    }
    if (this.vitals != null) {
      data['vitals'] = this.vitals.toJson();
    }
    if (this.heartAndLungs != null) {
      data['heartAndLungs'] = this.heartAndLungs.toJson();
    }
    if (this.neurological != null) {
      data['neurological'] = this.neurological.toJson();
    }
    if (this.musculoskeletal != null) {
      data['musculoskeletal'] = this.musculoskeletal.toJson();
    }
    if (this.specialTests != null) {
      data['specialTests'] = this.specialTests.toJson();
    }
    if (this.anthropometricMeasurements != null) {
      data['anthropometricMeasurements'] =
          this.anthropometricMeasurements.toJson();
    }
    if (this.therapeuticIntervention != null) {
      data['therapeuticIntervention'] = this.therapeuticIntervention.toJson();
    }
    data['otherComments'] = this.otherComments;
    data['appointmentId'] = this.appointmentId;
    data['doctorId'] = this.doctorId;
    if (this.exerciseDetails != null) {
      data['exerciseDetails'] = this.exerciseDetails.toJson();
    }

    if (this.education != null) {
      data['education'] = this.education.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ImagingDetails {
  PreferredImagingCenters preferredImagingCenters;
  String imagingInstructions;
  List<Imagings> imagings;

  ImagingDetails(
      {this.preferredImagingCenters, this.imagingInstructions, this.imagings});

  ImagingDetails.fromJson(Map<String, dynamic> json) {
    preferredImagingCenters = json['preferredImagingCenters'] != null
        ? new PreferredImagingCenters.fromJson(json['preferredImagingCenters'])
        : null;
    imagingInstructions = json['imagingInstructions'];
    if (json['imagings'] != null) {
      imagings = new List<Imagings>();
      json['imagings'].forEach((v) {
        imagings.add(new Imagings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferredImagingCenters != null) {
      data['preferredImagingCenters'] = this.preferredImagingCenters.toJson();
    }
    data['imagingInstructions'] = this.imagingInstructions;
    if (this.imagings != null) {
      data['imagings'] = this.imagings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PreferredImagingCenters {
  PreferredImagingCentersAddress address;
  String name;

  PreferredImagingCenters({this.address, this.name});

  PreferredImagingCenters.fromJson(Map<String, dynamic> json) {
    address = json['address'] != null
        ? new PreferredImagingCentersAddress.fromJson(json['address'])
        : null;
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

class PreferredImagingCentersAddress {
  String address;
  String city;
  String phone;
  String state;
  String zipCode;

  PreferredImagingCentersAddress(
      {this.address, this.city, this.phone, this.state, this.zipCode});

  PreferredImagingCentersAddress.fromJson(Map<String, dynamic> json) {
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

class Imagings {
  String name;
  String sId;

  Imagings({this.name, this.sId});

  Imagings.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['_id'] = this.sId;
    return data;
  }
}

class LabDetails {
  PreferredLabs preferredLabs;
  String labTestInstructions;
  List<LabTests> labTests;

  LabDetails({this.preferredLabs, this.labTestInstructions, this.labTests});

  LabDetails.fromJson(Map<String, dynamic> json) {
    preferredLabs = json['preferredLabs'] != null
        ? new PreferredLabs.fromJson(json['preferredLabs'])
        : null;
    labTestInstructions = json['labTestInstructions'];
    if (json['labTests'] != null) {
      labTests = new List<LabTests>();
      json['labTests'].forEach((v) {
        labTests.add(new LabTests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferredLabs != null) {
      data['preferredLabs'] = this.preferredLabs.toJson();
    }
    data['labTestInstructions'] = this.labTestInstructions;
    if (this.labTests != null) {
      data['labTests'] = this.labTests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabTests {
  String name;
  String sId;

  LabTests({this.name, this.sId});

  LabTests.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['_id'] = this.sId;
    return data;
  }
}

class PreferredLabs {
  Address address;
  String labId;
  String name;

  PreferredLabs({this.address, this.labId, this.name});

  PreferredLabs.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    labId = json['labId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['labId'] = this.labId;
    data['name'] = this.name;
    return data;
  }
}

class PrescriptionDetails {
  Pharmacy preferredPharmacy;
  // List<Null> prescriptionDetails;

  PrescriptionDetails({
    this.preferredPharmacy,
    //  this.prescriptionDetails
  });

  PrescriptionDetails.fromJson(Map<String, dynamic> json) {
    preferredPharmacy = json['preferredPharmacy'] != null
        ? new Pharmacy.fromJson(json['preferredPharmacy'])
        : null;
    // if (json['prescriptionDetails'] != null) {
    //   prescriptionDetails = new List<Null>();
    //   json['prescriptionDetails'].forEach((v) {
    //     prescriptionDetails.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferredPharmacy != null) {
      data['preferredPharmacy'] = this.preferredPharmacy.toJson();
    }
    // if (this.prescriptionDetails != null) {
    //   data['prescriptionDetails'] =
    //       this.prescriptionDetails.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Pharmacy {
  PharmacyAddress address;
  String name;

  Pharmacy({this.address, this.name});

  Pharmacy.fromJson(Map<String, dynamic> json) {
    address = json['address'] != null
        ? new PharmacyAddress.fromJson(json['address'])
        : null;
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

class PharmacyAddress {
  String address;
  String city;
  String phone;
  String state;
  String zipCode;

  PharmacyAddress(
      {this.address, this.city, this.phone, this.state, this.zipCode});

  PharmacyAddress.fromJson(Map<String, dynamic> json) {
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
  BloodPressureSummaryCompleted bloodPressureSummary;
  BloodPressureSummaryCompleted heartRateSummary;
  BloodPressureSummaryCompleted oxygenSaturationSummary;
  BloodPressureSummaryCompleted temperatureSummary;
  BloodPressureSummaryCompleted painSummary;
  String bloodPressureDbp;
  String bloodPressureSbp;
  String date;
  String heartRate;
  String oxygenSaturation;
  String temperature;
  String height;
  String weight;
  String bmi;
  String bloodGlucose;
  String time;
  String pain;

  Vitals(
      {this.bloodPressureSummary,
      this.heartRateSummary,
      this.oxygenSaturationSummary,
      this.temperatureSummary,
      this.painSummary,
      this.bloodPressureDbp,
      this.bloodPressureSbp,
      this.date,
      this.heartRate,
      this.oxygenSaturation,
      this.temperature,
      this.height,
      this.weight,
      this.bmi,
      this.bloodGlucose,
      this.time,
      this.pain});

  Vitals.fromJson(Map<String, dynamic> json) {
    bloodPressureSummary = json['bloodPressureSummary'] != null
        ? new BloodPressureSummaryCompleted.fromJson(
            json['bloodPressureSummary'])
        : null;
    heartRateSummary = json['heartRateSummary'] != null
        ? new BloodPressureSummaryCompleted.fromJson(json['heartRateSummary'])
        : null;
    oxygenSaturationSummary = json['oxygenSaturationSummary'] != null
        ? new BloodPressureSummaryCompleted.fromJson(
            json['oxygenSaturationSummary'])
        : null;
    temperatureSummary = json['temperatureSummary'] != null
        ? new BloodPressureSummaryCompleted.fromJson(json['temperatureSummary'])
        : null;
    painSummary = json['painSummary'] != null
        ? new BloodPressureSummaryCompleted.fromJson(json['painSummary'])
        : null;
    bloodPressureDbp = json['bloodPressureDbp'];
    bloodPressureSbp = json['bloodPressureSbp'];
    date = json['date'];
    heartRate = json['heartRate'];
    oxygenSaturation = json['oxygenSaturation'];
    temperature = json['temperature'];
    height = json['height'];
    weight = json['weight'];
    bmi = json['bmi'];
    bloodGlucose = json['bloodGlucose'];
    time = json['time'];
    pain = json['pain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bloodPressureSummary != null) {
      data['bloodPressureSummary'] = this.bloodPressureSummary.toJson();
    }
    if (this.heartRateSummary != null) {
      data['heartRateSummary'] = this.heartRateSummary.toJson();
    }
    if (this.oxygenSaturationSummary != null) {
      data['oxygenSaturationSummary'] = this.oxygenSaturationSummary.toJson();
    }
    if (this.temperatureSummary != null) {
      data['temperatureSummary'] = this.temperatureSummary.toJson();
    }
    if (this.painSummary != null) {
      data['painSummary'] = this.painSummary.toJson();
    }
    data['bloodPressureDbp'] = this.bloodPressureDbp;
    data['bloodPressureSbp'] = this.bloodPressureSbp;
    data['date'] = this.date;
    data['heartRate'] = this.heartRate;
    data['oxygenSaturation'] = this.oxygenSaturation;
    data['temperature'] = this.temperature;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['bmi'] = this.bmi;
    data['bloodGlucose'] = this.bloodGlucose;
    data['time'] = this.time;
    data['pain'] = this.pain;
    return data;
  }
}

class BloodPressureSummaryCompleted {
  List<String> clinicalConcern;
  List<String> treatment;
  List<String> icd;

  BloodPressureSummaryCompleted(
      {this.clinicalConcern, this.treatment, this.icd});

  BloodPressureSummaryCompleted.fromJson(Map<String, dynamic> json) {
    clinicalConcern = json['clinicalConcern'].cast<String>();
    treatment = json['treatment'].cast<String>();
    icd = json['icd'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    return data;
  }
}

class HeartAndLungs {
  Heart heart;
  Lung lung;
  String discomfort;

  HeartAndLungs({this.heart, this.lung, this.discomfort});

  HeartAndLungs.fromJson(Map<String, dynamic> json) {
    heart = json['heart'] != null ? new Heart.fromJson(json['heart']) : null;
    lung = json['lung'] != null ? new Lung.fromJson(json['lung']) : null;
    discomfort = json['discomfort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.heart != null) {
      data['heart'] = this.heart.toJson();
    }
    if (this.lung != null) {
      data['lung'] = this.lung.toJson();
    }
    data['discomfort'] = this.discomfort;
    return data;
  }
}

class Heart {
  List<String> sound;
  String type;
  List<String> clinicalConcern;
  List<String> treatment;
  List<String> icd;

  Heart(
      {this.sound, this.type, this.clinicalConcern, this.treatment, this.icd});

  Heart.fromJson(Map<String, dynamic> json) {
    sound = json['sound'].cast<String>();
    type = json['type'];
    clinicalConcern = json['clinicalConcern'].cast<String>();
    treatment = json['treatment'].cast<String>();
    icd = json['icd'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sound'] = this.sound;
    data['type'] = this.type;
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    return data;
  }
}

class Lung {
  List<String> clinicalConcern;
  List<String> treatment;
  List<String> icd;
  List<Summary> summary;

  Lung({this.clinicalConcern, this.treatment, this.icd, this.summary});

  Lung.fromJson(Map<String, dynamic> json) {
    clinicalConcern = json['clinicalConcern'].cast<String>();
    treatment = json['treatment'].cast<String>();
    icd = json['icd'].cast<String>();
    if (json['summary'] != null) {
      summary = new List<Summary>();
      json['summary'].forEach((v) {
        summary.add(new Summary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    if (this.summary != null) {
      data['summary'] = this.summary.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  String sound;
  String type;
  String sId;

  Summary({this.sound, this.type, this.sId});

  Summary.fromJson(Map<String, dynamic> json) {
    sound = json['sound'];
    type = json['type'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sound'] = this.sound;
    data['type'] = this.type;
    data['_id'] = this.sId;
    return data;
  }
}

class Neurological {
  List<String> clinicalConcern;
  List<String> treatment;
  List<String> icd;
  List<SensoryDeficits> sensoryDeficits;
  List<SensoryDeficits> dtrDeficits;
  List<SensoryDeficits> strengthDeficits;
  List<SensoryDeficits> romDeficits;
  List<SensoryDeficits> positiveTests;

  Neurological(
      {this.clinicalConcern,
      this.treatment,
      this.icd,
      this.sensoryDeficits,
      this.dtrDeficits,
      this.strengthDeficits,
      this.romDeficits,
      this.positiveTests});

  Neurological.fromJson(Map<String, dynamic> json) {
    clinicalConcern = json['clinicalConcern'].cast<String>();
    treatment = json['treatment'].cast<String>();
    icd = json['icd'].cast<String>();
    if (json['sensoryDeficits'] != null) {
      sensoryDeficits = new List<SensoryDeficits>();
      json['sensoryDeficits'].forEach((v) {
        sensoryDeficits.add(new SensoryDeficits.fromJson(v));
      });
    }
    if (json['dtrDeficits'] != null) {
      dtrDeficits = new List<SensoryDeficits>();
      json['dtrDeficits'].forEach((v) {
        dtrDeficits.add(new SensoryDeficits.fromJson(v));
      });
    }
    if (json['strengthDeficits'] != null) {
      strengthDeficits = new List<SensoryDeficits>();
      json['strengthDeficits'].forEach((v) {
        strengthDeficits.add(new SensoryDeficits.fromJson(v));
      });
    }
    if (json['romDeficits'] != null) {
      romDeficits = new List<SensoryDeficits>();
      json['romDeficits'].forEach((v) {
        romDeficits.add(new SensoryDeficits.fromJson(v));
      });
    }
    if (json['positiveTests'] != null) {
      positiveTests = new List<SensoryDeficits>();
      json['positiveTests'].forEach((v) {
        positiveTests.add(new SensoryDeficits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    if (this.sensoryDeficits != null) {
      data['sensoryDeficits'] =
          this.sensoryDeficits.map((v) => v.toJson()).toList();
    }
    if (this.dtrDeficits != null) {
      data['dtrDeficits'] = this.dtrDeficits.map((v) => v.toJson()).toList();
    }
    if (this.strengthDeficits != null) {
      data['strengthDeficits'] =
          this.strengthDeficits.map((v) => v.toJson()).toList();
    }
    if (this.romDeficits != null) {
      data['romDeficits'] = this.romDeficits.map((v) => v.toJson()).toList();
    }
    if (this.positiveTests != null) {
      data['positiveTests'] =
          this.positiveTests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SensoryDeficits {
  String type;
  String deficits;
  String sId;

  SensoryDeficits({this.type, this.deficits, this.sId});

  SensoryDeficits.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    deficits = json['deficits'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['deficits'] = this.deficits;
    data['_id'] = this.sId;
    return data;
  }
}

class Musculoskeletal {
  List<String> clinicalConcern;
  List<String> treatment;
  List<String> icd;
  List<Muscle> muscle;
  List<Joint> joint;

  Musculoskeletal(
      {this.clinicalConcern,
      this.treatment,
      this.icd,
      this.muscle,
      this.joint});

  Musculoskeletal.fromJson(Map<String, dynamic> json) {
    clinicalConcern = json['clinicalConcern'].cast<String>();
    treatment = json['treatment'].cast<String>();
    icd = json['icd'].cast<String>();
    if (json['muscle'] != null) {
      muscle = new List<Muscle>();
      json['muscle'].forEach((v) {
        muscle.add(new Muscle.fromJson(v));
      });
    }
    if (json['joint'] != null) {
      joint = new List<Joint>();
      json['joint'].forEach((v) {
        joint.add(new Joint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    if (this.muscle != null) {
      data['muscle'] = this.muscle.map((v) => v.toJson()).toList();
    }
    if (this.joint != null) {
      data['joint'] = this.joint.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Muscle {
  String name;
  String type;
  String strength;
  String functionalStrength;
  String sId;

  Muscle(
      {this.name, this.type, this.strength, this.functionalStrength, this.sId});

  Muscle.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    strength = json['strength'];
    functionalStrength = json['functionalStrength'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['strength'] = this.strength;
    data['functionalStrength'] = this.functionalStrength;
    data['_id'] = this.sId;
    return data;
  }
}

class Joint {
  String name;
  String type;
  String rangeOfMotion;
  String functionalRangeOfMotion;
  String sId;

  Joint(
      {this.name,
      this.type,
      this.rangeOfMotion,
      this.functionalRangeOfMotion,
      this.sId});

  Joint.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    rangeOfMotion = json['rangeOfMotion'];
    functionalRangeOfMotion = json['functionalRangeOfMotion'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['rangeOfMotion'] = this.rangeOfMotion;
    data['functionalRangeOfMotion'] = this.functionalRangeOfMotion;
    data['_id'] = this.sId;
    return data;
  }
}

class SpecialTests {
  List<String> clinicalConcern;
  List<String> treatment;
  List<String> icd;
  List<TestsCompleted> tests;

  SpecialTests({this.clinicalConcern, this.treatment, this.icd, this.tests});

  SpecialTests.fromJson(Map<String, dynamic> json) {
    clinicalConcern = json['clinicalConcern'].cast<String>();
    treatment = json['treatment'].cast<String>();
    icd = json['icd'].cast<String>();
    if (json['tests'] != null) {
      tests = new List<TestsCompleted>();
      json['tests'].forEach((v) {
        tests.add(new TestsCompleted.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    if (this.tests != null) {
      data['tests'] = this.tests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TestsCompleted {
  String name;
  String type;
  String sId;

  TestsCompleted({this.name, this.type, this.sId});

  TestsCompleted.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['_id'] = this.sId;
    return data;
  }
}

class AnthropometricMeasurements {
  Weight weight;
  Height height;
  Weight hip;
  Weight waist;
  Weight calf;
  Weight arm;
  String bmi;

  AnthropometricMeasurements(
      {this.weight,
      this.height,
      this.hip,
      this.waist,
      this.calf,
      this.arm,
      this.bmi});

  AnthropometricMeasurements.fromJson(Map<String, dynamic> json) {
    weight =
        json['weight'] != null ? new Weight.fromJson(json['weight']) : null;
    height =
        json['height'] != null ? new Height.fromJson(json['height']) : null;
    hip = json['hip'] != null ? new Weight.fromJson(json['hip']) : null;
    waist = json['waist'] != null ? new Weight.fromJson(json['waist']) : null;
    calf = json['calf'] != null ? new Weight.fromJson(json['calf']) : null;
    arm = json['arm'] != null ? new Weight.fromJson(json['arm']) : null;
    bmi = json['bmi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.weight != null) {
      data['weight'] = this.weight.toJson();
    }
    if (this.height != null) {
      data['height'] = this.height.toJson();
    }
    if (this.hip != null) {
      data['hip'] = this.hip.toJson();
    }
    if (this.waist != null) {
      data['waist'] = this.waist.toJson();
    }
    if (this.calf != null) {
      data['calf'] = this.calf.toJson();
    }
    if (this.arm != null) {
      data['arm'] = this.arm.toJson();
    }
    data['bmi'] = this.bmi;
    return data;
  }
}

class Weight {
  Goal goal;
  String current;

  Weight({this.goal, this.current});

  Weight.fromJson(Map<String, dynamic> json) {
    goal = json['goal'] != null ? new Goal.fromJson(json['goal']) : null;
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.goal != null) {
      data['goal'] = this.goal.toJson();
    }
    data['current'] = this.current;
    return data;
  }
}

class Goal {
  String achieve;
  String unit;
  String timeFrame;
  String timeUnit;
  List<String> improvements;

  Goal(
      {this.achieve,
      this.unit,
      this.timeFrame,
      this.timeUnit,
      this.improvements});

  Goal.fromJson(Map<String, dynamic> json) {
    achieve = json['achieve'];
    unit = json['unit'];
    timeFrame = json['timeFrame'];
    timeUnit = json['timeUnit'];
    improvements = json['improvements'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['achieve'] = this.achieve;
    data['unit'] = this.unit;
    data['timeFrame'] = this.timeFrame;
    data['timeUnit'] = this.timeUnit;
    data['improvements'] = this.improvements;
    return data;
  }
}

class Height {
  String feet;
  String inches;

  Height({this.feet, this.inches});

  Height.fromJson(Map<String, dynamic> json) {
    feet = json['feet'];
    inches = json['inches'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feet'] = this.feet;
    data['inches'] = this.inches;
    return data;
  }
}

class TherapeuticIntervention {
  List<String> clinicalConcern;
  List<String> treatment;
  List<String> icd;
  List<Intervention> intervention;

  TherapeuticIntervention(
      {this.clinicalConcern, this.treatment, this.icd, this.intervention});

  TherapeuticIntervention.fromJson(Map<String, dynamic> json) {
    clinicalConcern = json['clinicalConcern'].cast<String>();
    treatment = json['treatment'].cast<String>();
    icd = json['icd'].cast<String>();
    if (json['intervention'] != null) {
      intervention = new List<Intervention>();
      json['intervention'].forEach((v) {
        intervention.add(new Intervention.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    if (this.intervention != null) {
      data['intervention'] = this.intervention.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Intervention {
  String name;
  String reason;
  String time;
  String patientResponse;
  String bodyPart;
  String sId;

  Intervention(
      {this.name,
      this.reason,
      this.time,
      this.patientResponse,
      this.bodyPart,
      this.sId});

  Intervention.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    reason = json['reason'];
    time = json['time'];
    patientResponse = json['patientResponse'];
    bodyPart = json['bodyPart'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['reason'] = this.reason;
    data['time'] = this.time;
    data['patientResponse'] = this.patientResponse;
    data['bodyPart'] = this.bodyPart;
    data['_id'] = this.sId;
    return data;
  }
}

class ExerciseDetails {
  List<Exercises> exercises;

  ExerciseDetails({this.exercises});

  ExerciseDetails.fromJson(Map<String, dynamic> json) {
    if (json['exercises'] != null) {
      exercises = new List<Exercises>();
      json['exercises'].forEach((v) {
        exercises.add(new Exercises.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.exercises != null) {
      data['exercises'] = this.exercises.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Exercises {
  String frequency;
  String name;
  String sets;
  String times;
  String instructions;
  String video;
  List<String> images;
  String sId;

  Exercises(
      {this.frequency,
      this.name,
      this.sets,
      this.times,
      this.instructions,
      this.video,
      this.images,
      this.sId});

  Exercises.fromJson(Map<String, dynamic> json) {
    frequency = json['frequency'];
    name = json['name'];
    sets = json['sets'];
    times = json['times'];
    instructions = json['instructions'];
    video = json['video'];
    images = json['images'].cast<String>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frequency'] = this.frequency;
    data['name'] = this.name;
    data['sets'] = this.sets;
    data['times'] = this.times;
    data['instructions'] = this.instructions;
    data['video'] = this.video;
    data['images'] = this.images;
    data['_id'] = this.sId;
    return data;
  }
}

class Education {
  String id;
  String category;
  String name;
  String reference;
  String comments;
  String sId;

  Education(
      {this.id,
      this.category,
      this.name,
      this.reference,
      this.comments,
      this.sId});

  Education.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    name = json['name'];
    reference = json['reference'];
    comments = json['comments'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['name'] = this.name;
    data['reference'] = this.reference;
    data['comments'] = this.comments;
    data['_id'] = this.sId;
    return data;
  }
}

class PreferredPhramacy {
  String sId;
  String name;
  String createdAt;
  String updatedAt;
  int iV;
  List<PhaAddress> address;
  String pharmacyId;

  PreferredPhramacy(
      {this.sId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.address,
      this.pharmacyId});

  PreferredPhramacy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['address'] != null) {
      address = new List<PhaAddress>();
      if (json['address'] is List) {
        json['address'].forEach((v) {
          address.add(new PhaAddress.fromJson(v));
        });
      } else {
        address.add(new PhaAddress.fromJson(json['address']));
      }
    }
    pharmacyId = json['pharmacyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    data['pharmacyId'] = this.pharmacyId;
    return data;
  }
}

class PhaAddress {
  String address;
  String city;
  String phone;
  String phoneNumber;
  String state;
  String zipCode;
  String sId;
  String pharmacyId;
  String name;

  PhaAddress(
      {this.address,
      this.city,
      this.phone,
      this.phoneNumber,
      this.state,
      this.zipCode,
      this.sId,
      this.pharmacyId,
      this.name});

  PhaAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    phone = json['phone'];
    phoneNumber = json['phoneNumber'];
    state = json['state'];
    zipCode = json['zipCode'];
    sId = json['_id'];
    pharmacyId = json['pharmacyId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['phone'] = this.phone;
    data['phoneNumber'] = this.phoneNumber;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    data['_id'] = this.sId;
    data['pharmacyId'] = this.pharmacyId;
    data['name'] = this.name;
    return data;
  }
}
