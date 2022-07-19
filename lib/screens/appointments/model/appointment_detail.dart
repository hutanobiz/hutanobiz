class AppointmentData {
  List<Medications>? medications;
  PreferredPhramacy? pharmacy;
  List<AppointmentProblems>? appointmentProblems;
  List<DoctorFeedback>? doctorFeedback;

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
      medications = [];
      json['medications'].forEach((v) {
        if (v != null) medications!.add(new Medications.fromJson(v));
      });
    }
    if (json['appointmentProblems'] != null) {
      appointmentProblems = [];
      json['appointmentProblems'].forEach((v) {
        if (v != null)
          appointmentProblems!.add(new AppointmentProblems.fromJson(v));
      });
    }
    if (json['doctorFeedBack'] != null) {
      doctorFeedback = <DoctorFeedback>[];
      json['doctorFeedBack'].forEach((v) {
        if (v != null) doctorFeedback!.add(new DoctorFeedback.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.pharmacy != null) {
      data['pharmacy'] = this.pharmacy!.toJson();
    }

    if (this.medications != null) {
      data['medications'] = this.medications!.map((v) => v.toJson()).toList();
    }
    if (this.appointmentProblems != null) {
      data['appointmentProblems'] =
          this.appointmentProblems!.map((v) => v.toJson()).toList();
    }
    // if (this.doctorFeedback != null) {
    //   data['doctorFeedback'] = this.doctorFeedback.toJson();
    // }

    return data;
  }
}

class Medications {
  String? prescriptionId;
  String? name;
  String? dose;
  String? frequency;
  String? sId;

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
  String? address;
  String? city;
  String? phone;
  String? state;
  String? zipCode;

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
  String? sId;
  String? name;
  String? image;
  List<String>? symptoms;
  // List<Null> problemBetter;
  // List<Null> problemWorst;
  int? problemRating;
  String? dailyActivity;
  // Null isProblemImproving;
  // Null isTreatmentReceived;
  String? description;
  String? problemId;
  List<BodyPart>? bodyPart;
  ProblemFacingTimeSpan? problemFacingTimeSpan;
  TreatmentReceived? treatmentReceived;
  String? userId;
  String? appointmentId;
  String? createdAt;
  String? updatedAt;
  int? iV;

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
      bodyPart = <BodyPart>[];
      json['bodyPart'].forEach((v) {
        if (v != null) bodyPart!.add(new BodyPart.fromJson(v));
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
      data['bodyPart'] = this.bodyPart!.map((v) => v.toJson()).toList();
    }
    if (this.problemFacingTimeSpan != null) {
      data['problemFacingTimeSpan'] = this.problemFacingTimeSpan!.toJson();
    }
    if (this.treatmentReceived != null) {
      data['treatmentReceived'] = this.treatmentReceived!.toJson();
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
  String? name;
  List<int>? sides;
  String? sId;

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
  String? type;
  String? period;

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
  String? type;
  String? period;
  String? typeOfCare;

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
  String? sId;
  ImagingDetails? imagingDetails;
  LabDetails? labDetails;
  PrescriptionDetails? prescriptionDetails;
  Vitals? vitals;
  HeartAndLungs? heartAndLungs;
  Neurological? neurological;
  Musculoskeletal? musculoskeletal;
  SpecialTests? specialTests;
  AnthropometricMeasurements? anthropometricMeasurements;
  TherapeuticIntervention? therapeuticIntervention;
  String? otherComments;
  String? appointmentId;
  String? doctorId;
  ExerciseDetails? exerciseDetails;
  List<Education>? education;
  Integumentary? integumentary;
  Gait? gait;
  String? createdAt;
  String? updatedAt;
  int? iV;

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
      this.integumentary,
      this.gait,
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
      education = <Education>[];
      json['education'].forEach((v) {
        if (v != null) education!.add(new Education.fromJson(v));
      });
    }
    integumentary = json['integumentary'] != null
        ? new Integumentary.fromJson(json['integumentary'])
        : null;
    gait = json['gait'] != null ? new Gait.fromJson(json['gait']) : null;

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.imagingDetails != null) {
      data['imagingDetails'] = this.imagingDetails!.toJson();
    }
    if (this.labDetails != null) {
      data['labDetails'] = this.labDetails!.toJson();
    }
    if (this.prescriptionDetails != null) {
      data['prescriptionDetails'] = this.prescriptionDetails!.toJson();
    }
    if (this.vitals != null) {
      data['vitals'] = this.vitals!.toJson();
    }
    if (this.heartAndLungs != null) {
      data['heartAndLungs'] = this.heartAndLungs!.toJson();
    }
    if (this.neurological != null) {
      data['neurological'] = this.neurological!.toJson();
    }
    if (this.musculoskeletal != null) {
      data['musculoskeletal'] = this.musculoskeletal!.toJson();
    }
    if (this.specialTests != null) {
      data['specialTests'] = this.specialTests!.toJson();
    }
    if (this.anthropometricMeasurements != null) {
      data['anthropometricMeasurements'] =
          this.anthropometricMeasurements!.toJson();
    }
    if (this.therapeuticIntervention != null) {
      data['therapeuticIntervention'] = this.therapeuticIntervention!.toJson();
    }
    data['otherComments'] = this.otherComments;
    data['appointmentId'] = this.appointmentId;
    data['doctorId'] = this.doctorId;
    if (this.exerciseDetails != null) {
      data['exerciseDetails'] = this.exerciseDetails!.toJson();
    }

    if (this.education != null) {
      data['education'] = this.education!.map((v) => v.toJson()).toList();
    }
    if (this.integumentary != null) {
      data['integumentary'] = this.integumentary!.toJson();
    }
    if (this.gait != null) {
      data['gait'] = this.gait!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ImagingDetails {
  PreferredImagingCenters? preferredImagingCenters;
  String? imagingInstructions;
  List<Imagings>? imagings;

  ImagingDetails(
      {this.preferredImagingCenters, this.imagingInstructions, this.imagings});

  ImagingDetails.fromJson(Map<String, dynamic> json) {
    preferredImagingCenters = json['preferredImagingCenters'] != null
        ? new PreferredImagingCenters.fromJson(json['preferredImagingCenters'])
        : null;
    imagingInstructions = json['imagingInstructions'];
    if (json['imagings'] != null) {
      imagings = <Imagings>[];
      json['imagings'].forEach((v) {
        if (v != null) {
          imagings!.add(new Imagings.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferredImagingCenters != null) {
      data['preferredImagingCenters'] = this.preferredImagingCenters!.toJson();
    }
    data['imagingInstructions'] = this.imagingInstructions;
    if (this.imagings != null) {
      data['imagings'] = this.imagings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PreferredImagingCenters {
  PreferredImagingCentersAddress? address;
  String? name;

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
      data['address'] = this.address!.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class PreferredImagingCentersAddress {
  String? address;
  String? city;
  String? phone;
  String? state;
  String? zipCode;

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
  String? name;
  String? sId;

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
  PreferredLabs? preferredLabs;
  String? labTestInstructions;
  List<LabTests>? labTests;

  LabDetails({this.preferredLabs, this.labTestInstructions, this.labTests});

  LabDetails.fromJson(Map<String, dynamic> json) {
    preferredLabs = json['preferredLabs'] != null
        ? new PreferredLabs.fromJson(json['preferredLabs'])
        : null;
    labTestInstructions = json['labTestInstructions'];
    if (json['labTests'] != null) {
      labTests = <LabTests>[];
      json['labTests'].forEach((v) {
        if (v != null) {
          labTests!.add(new LabTests.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferredLabs != null) {
      data['preferredLabs'] = this.preferredLabs!.toJson();
    }
    data['labTestInstructions'] = this.labTestInstructions;
    if (this.labTests != null) {
      data['labTests'] = this.labTests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabTests {
  String? name;
  String? sId;

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
  Address? address;
  String? labId;
  String? name;

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
      data['address'] = this.address!.toJson();
    }
    data['labId'] = this.labId;
    data['name'] = this.name;
    return data;
  }
}

class PrescriptionDetails {
  Pharmacy? preferredPharmacy;
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
      data['preferredPharmacy'] = this.preferredPharmacy!.toJson();
    }
    // if (this.prescriptionDetails != null) {
    //   data['prescriptionDetails'] =
    //       this.prescriptionDetails.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Pharmacy {
  PharmacyAddress? address;
  String? name;

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
      data['address'] = this.address!.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class PharmacyAddress {
  String? address;
  String? city;
  String? phone;
  String? state;
  String? zipCode;

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
  BloodPressureSummaryCompleted? bloodPressureSummary;
  BloodPressureSummaryCompleted? heartRateSummary;
  BloodPressureSummaryCompleted? oxygenSaturationSummary;
  BloodPressureSummaryCompleted? temperatureSummary;
  BloodPressureSummaryCompleted? painSummary;
  String? bloodPressureDbp;
  String? bloodPressureSbp;
  String? date;
  String? heartRate;
  String? oxygenSaturation;
  String? temperature;
  String? height;
  String? weight;
  String? bmi;
  String? bloodGlucose;
  String? time;
  String? pain;

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
      data['bloodPressureSummary'] = this.bloodPressureSummary!.toJson();
    }
    if (this.heartRateSummary != null) {
      data['heartRateSummary'] = this.heartRateSummary!.toJson();
    }
    if (this.oxygenSaturationSummary != null) {
      data['oxygenSaturationSummary'] = this.oxygenSaturationSummary!.toJson();
    }
    if (this.temperatureSummary != null) {
      data['temperatureSummary'] = this.temperatureSummary!.toJson();
    }
    if (this.painSummary != null) {
      data['painSummary'] = this.painSummary!.toJson();
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
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;

  BloodPressureSummaryCompleted(
      {this.clinicalConcern, this.treatment, this.icd});

  BloodPressureSummaryCompleted.fromJson(Map<String, dynamic> json) {
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
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
  Heart? heart;
  Lung? lung;
  String? discomfort;

  HeartAndLungs({this.heart, this.lung, this.discomfort});

  HeartAndLungs.fromJson(Map<String, dynamic> json) {
    heart = json['heart'] != null ? new Heart.fromJson(json['heart']) : null;
    lung = json['lung'] != null ? new Lung.fromJson(json['lung']) : null;
    discomfort = json['discomfort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.heart != null) {
      data['heart'] = this.heart!.toJson();
    }
    if (this.lung != null) {
      data['lung'] = this.lung!.toJson();
    }
    data['discomfort'] = this.discomfort;
    return data;
  }
}

class Heart {
  List<String>? sound;
  String? type;
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;

  Heart(
      {this.sound, this.type, this.clinicalConcern, this.treatment, this.icd});

  Heart.fromJson(Map<String, dynamic> json) {
    sound = [];
    if (json['sound'] != null) {
      json['sound'].forEach((v) {
        if (v != null) sound!.add(v);
      });
    }

    type = json['type'];
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
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
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;
  List<Summary>? summary;

  Lung({this.clinicalConcern, this.treatment, this.icd, this.summary});

  Lung.fromJson(Map<String, dynamic> json) {
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
    if (json['summary'] != null) {
      summary = <Summary>[];
      json['summary'].forEach((v) {
        summary!.add(new Summary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    if (this.summary != null) {
      data['summary'] = this.summary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  String? sound;
  String? type;
  String? sId;

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
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;
  List<SensoryDeficits>? sensoryDeficits;
  List<SensoryDeficits>? dtrDeficits;
  List<SensoryDeficits>? strengthDeficits;
  List<SensoryDeficits>? romDeficits;
  List<SensoryDeficits>? positiveTests;

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
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
    if (json['sensoryDeficits'] != null) {
      sensoryDeficits = <SensoryDeficits>[];
      json['sensoryDeficits'].forEach((v) {
        if (v != null) sensoryDeficits!.add(SensoryDeficits.fromJson(v));
      });
    }
    if (json['dtrDeficits'] != null) {
      dtrDeficits = <SensoryDeficits>[];
      json['dtrDeficits'].forEach((v) {
        if (v != null) dtrDeficits!.add(new SensoryDeficits.fromJson(v));
      });
    }
    if (json['strengthDeficits'] != null) {
      strengthDeficits = <SensoryDeficits>[];
      json['strengthDeficits'].forEach((v) {
        if (v != null) strengthDeficits!.add(new SensoryDeficits.fromJson(v));
      });
    }
    if (json['romDeficits'] != null) {
      romDeficits = <SensoryDeficits>[];
      json['romDeficits'].forEach((v) {
        if (v != null) romDeficits!.add(new SensoryDeficits.fromJson(v));
      });
    }
    if (json['positiveTests'] != null) {
      positiveTests = <SensoryDeficits>[];
      json['positiveTests'].forEach((v) {
        if (v != null) positiveTests!.add(new SensoryDeficits.fromJson(v));
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
          this.sensoryDeficits!.map((v) => v.toJson()).toList();
    }
    if (this.dtrDeficits != null) {
      data['dtrDeficits'] = this.dtrDeficits!.map((v) => v.toJson()).toList();
    }
    if (this.strengthDeficits != null) {
      data['strengthDeficits'] =
          this.strengthDeficits!.map((v) => v.toJson()).toList();
    }
    if (this.romDeficits != null) {
      data['romDeficits'] = this.romDeficits!.map((v) => v.toJson()).toList();
    }
    if (this.positiveTests != null) {
      data['positiveTests'] =
          this.positiveTests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SensoryDeficits {
  String? type;
  String? deficits;
  String? sId;

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
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;
  List<Muscle>? muscle;
  List<Joint>? joint;

  Musculoskeletal(
      {this.clinicalConcern,
      this.treatment,
      this.icd,
      this.muscle,
      this.joint});

  Musculoskeletal.fromJson(Map<String, dynamic> json) {
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
    if (json['muscle'] != null) {
      muscle = <Muscle>[];
      json['muscle'].forEach((v) {
        if (v != null) muscle!.add(new Muscle.fromJson(v));
      });
    }
    if (json['joint'] != null) {
      joint = <Joint>[];
      json['joint'].forEach((v) {
        if (v != null) joint!.add(new Joint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    if (this.muscle != null) {
      data['muscle'] = this.muscle!.map((v) => v.toJson()).toList();
    }
    if (this.joint != null) {
      data['joint'] = this.joint!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Muscle {
  String? name;
  String? type;
  String? strength;
  String? functionalStrength;
  String? sId;

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
  String? name;
  String? type;
  String? rangeOfMotion;
  String? functionalRangeOfMotion;
  String? sId;

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
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;
  List<TestsCompleted>? tests;

  SpecialTests({this.clinicalConcern, this.treatment, this.icd, this.tests});

  SpecialTests.fromJson(Map<String, dynamic> json) {
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
    if (json['tests'] != null) {
      tests = <TestsCompleted>[];
      json['tests'].forEach((v) {
        tests!.add(new TestsCompleted.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    if (this.tests != null) {
      data['tests'] = this.tests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TestsCompleted {
  String? name;
  String? type;
  String? sId;

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
  Weight? weight;
  Height? height;
  Weight? hip;
  Weight? waist;
  Weight? calf;
  Weight? arm;
  String? bmi;

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
      data['weight'] = this.weight!.toJson();
    }
    if (this.height != null) {
      data['height'] = this.height!.toJson();
    }
    if (this.hip != null) {
      data['hip'] = this.hip!.toJson();
    }
    if (this.waist != null) {
      data['waist'] = this.waist!.toJson();
    }
    if (this.calf != null) {
      data['calf'] = this.calf!.toJson();
    }
    if (this.arm != null) {
      data['arm'] = this.arm!.toJson();
    }
    data['bmi'] = this.bmi;
    return data;
  }
}

class Weight {
  Goal? goal;
  String? current;

  Weight({this.goal, this.current});

  Weight.fromJson(Map<String, dynamic> json) {
    goal = json['goal'] != null ? new Goal.fromJson(json['goal']) : null;
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.goal != null) {
      data['goal'] = this.goal!.toJson();
    }
    data['current'] = this.current;
    return data;
  }
}

class Goal {
  String? achieve;
  String? unit;
  String? timeFrame;
  String? timeUnit;
  List<String>? improvements = [];

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
    if (json['improvements'] != null) {
      improvements = json['improvements'].cast<String>();
    }
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
  String? feet;
  String? inches;

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
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;
  List<Intervention>? intervention;

  TherapeuticIntervention(
      {this.clinicalConcern, this.treatment, this.icd, this.intervention});

  TherapeuticIntervention.fromJson(Map<String, dynamic> json) {
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
    if (json['intervention'] != null) {
      intervention = <Intervention>[];
      json['intervention'].forEach((v) {
        intervention!.add(new Intervention.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    if (this.intervention != null) {
      data['intervention'] = this.intervention!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Intervention {
  String? name;
  String? reason;
  String? time;
  String? patientResponse;
  String? bodyPart;
  String? sId;

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
  List<Exercises>? exercises;

  ExerciseDetails({this.exercises});

  ExerciseDetails.fromJson(Map<String, dynamic> json) {
    if (json['exercises'] != null) {
      exercises = <Exercises>[];
      json['exercises'].forEach((v) {
        if (v != null) exercises!.add(new Exercises.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.exercises != null) {
      data['exercises'] = this.exercises!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Exercises {
  String? frequency;
  String? name;
  String? sets;
  String? times;
  String? instructions;
  String? video;
  List<String>? images;
  String? sId;

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
    images = json['images']?.cast<String>();
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
  String? id;
  String? category;
  String? name;
  String? reference;
  String? comments;
  String? sId;

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
  String? sId;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<PhaAddress>? address;
  String? pharmacyId;

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
      address = <PhaAddress>[];
      if (json['address'] is List) {
        json['address'].forEach((v) {
          address!.add(new PhaAddress.fromJson(v));
        });
      } else {
        address!.add(new PhaAddress.fromJson(json['address']));
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
      data['address'] = this.address!.map((v) => v.toJson()).toList();
    }
    data['pharmacyId'] = this.pharmacyId;
    return data;
  }
}

class PhaAddress {
  String? address;
  String? city;
  String? phone;
  String? phoneNumber;
  String? state;
  String? zipCode;
  String? sId;
  String? pharmacyId;
  String? name;

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

class Integumentary {
  WoundCareSummary? woundCareSummary;
  PainSummary? painSummary;
  List<IntegumentarySummary>? summary;

  Integumentary({this.woundCareSummary, this.painSummary, this.summary});

  Integumentary.fromJson(Map<String, dynamic> json) {
    woundCareSummary = json['woundCareSummary'] != null
        ? new WoundCareSummary.fromJson(json['woundCareSummary'])
        : null;
    painSummary = json['painSummary'] != null
        ? new PainSummary.fromJson(json['painSummary'])
        : null;
    if (json['summary'] != null) {
      summary = <IntegumentarySummary>[];
      json['summary'].forEach((v) {
        if (v != null) summary!.add(new IntegumentarySummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.woundCareSummary != null) {
      data['woundCareSummary'] = this.woundCareSummary!.toJson();
    }
    if (this.painSummary != null) {
      data['painSummary'] = this.painSummary!.toJson();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WoundCareSummary {
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;

  WoundCareSummary({this.clinicalConcern, this.treatment, this.icd});

  WoundCareSummary.fromJson(Map<String, dynamic> json) {
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    return data;
  }
}

class PainSummary {
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;

  PainSummary({this.clinicalConcern, this.treatment, this.icd});

  PainSummary.fromJson(Map<String, dynamic> json) {
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    return data;
  }
}

class IntegumentarySummary {
  String? location;
  String? type;
  String? staging;
  String? mechanismOfInjury;
  String? pain;
  String? notes;
  String? image;
  List<String>? periwound;
  String? sId;
  Weight? length;
  Weight? width;
  Weight? depth;
  Weight? granulation;
  Weight? slough;
  Weight? necrosis;
  Weight? drainageType;
  Weight? drainageAmount;
  Weight? odor;

  IntegumentarySummary(
      {this.location,
      this.type,
      this.staging,
      this.mechanismOfInjury,
      this.pain,
      this.notes,
      this.image,
      this.periwound,
      this.sId,
      this.length,
      this.width,
      this.depth,
      this.granulation,
      this.slough,
      this.necrosis,
      this.drainageType,
      this.drainageAmount,
      this.odor});

  IntegumentarySummary.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    type = json['type'];
    staging = json['staging'];
    mechanismOfInjury = json['mechanismOfInjury'];
    pain = json['pain'];
    notes = json['notes'];
    image = json['image'];
    periwound = json['periwound']?.cast<String>();
    sId = json['_id'];
    length =
        json['length'] != null ? new Weight.fromJson(json['length']) : null;
    width = json['width'] != null ? new Weight.fromJson(json['width']) : null;
    depth = json['depth'] != null ? new Weight.fromJson(json['depth']) : null;
    granulation = json['granulation'] != null
        ? new Weight.fromJson(json['granulation'])
        : null;
    slough =
        json['slough'] != null ? new Weight.fromJson(json['slough']) : null;
    necrosis =
        json['necrosis'] != null ? new Weight.fromJson(json['necrosis']) : null;
    drainageType = json['drainageType'] != null
        ? new Weight.fromJson(json['drainageType'])
        : null;
    drainageAmount = json['drainageAmount'] != null
        ? new Weight.fromJson(json['drainageAmount'])
        : null;
    odor = json['odor'] != null ? new Weight.fromJson(json['odor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['type'] = this.type;
    data['staging'] = this.staging;
    data['mechanismOfInjury'] = this.mechanismOfInjury;
    data['pain'] = this.pain;
    data['notes'] = this.notes;
    data['image'] = this.image;
    data['periwound'] = this.periwound;
    data['_id'] = this.sId;
    if (this.length != null) {
      data['length'] = this.length!.toJson();
    }
    if (this.width != null) {
      data['width'] = this.width!.toJson();
    }
    if (this.depth != null) {
      data['depth'] = this.depth!.toJson();
    }
    if (this.granulation != null) {
      data['granulation'] = this.granulation!.toJson();
    }
    if (this.slough != null) {
      data['slough'] = this.slough!.toJson();
    }
    if (this.necrosis != null) {
      data['necrosis'] = this.necrosis!.toJson();
    }
    if (this.drainageType != null) {
      data['drainageType'] = this.drainageType!.toJson();
    }
    if (this.drainageAmount != null) {
      data['drainageAmount'] = this.drainageAmount!.toJson();
    }
    if (this.odor != null) {
      data['odor'] = this.odor!.toJson();
    }
    return data;
  }
}

class Gait {
  GaitSummary? gaitSummary;
  List<GaitData>? summary;

  Gait({this.gaitSummary, this.summary});

  Gait.fromJson(Map<String, dynamic> json) {
    gaitSummary = json['gaitSummary'] != null
        ? new GaitSummary.fromJson(json['gaitSummary'])
        : null;
    if (json['summary'] != null) {
      summary = <GaitData>[];
      json['summary'].forEach((v) {
        if (v != null) summary!.add(new GaitData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gaitSummary != null) {
      data['gaitSummary'] = this.gaitSummary!.toJson();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GaitSummary {
  List<String>? clinicalConcern;
  List<String>? treatment;
  List<String>? icd;

  GaitSummary({this.clinicalConcern, this.treatment, this.icd});

  GaitSummary.fromJson(Map<String, dynamic> json) {
    clinicalConcern = [];
    if (json['clinicalConcern'] != null) {
      json['clinicalConcern'].forEach((v) {
        if (v != null) {
          clinicalConcern!.add(v);
        }
      });
    }
    treatment = [];
    if (json['treatment'] != null) {
      json['treatment'].forEach((v) {
        if (v != null) {
          treatment!.add(v);
        }
      });
    }
    icd = [];
    if (json['icd'] != null) {
      json['icd'].forEach((v) {
        if (v != null) {
          icd!.add(v);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinicalConcern'] = this.clinicalConcern;
    data['treatment'] = this.treatment;
    data['icd'] = this.icd;
    return data;
  }
}

class GaitData {
  Weight? gaitType;
  Weight? distance;
  Weight? assistance;
  Weight? assistiveDevice;
  Weight? cuing;
  String? terraine;
  String? ambulationTrainer;
  String? time;
  String? patientResponse;
  String? notes;
  String? sId;

  GaitData(
      {this.gaitType,
      this.distance,
      this.assistance,
      this.assistiveDevice,
      this.cuing,
      this.terraine,
      this.ambulationTrainer,
      this.time,
      this.patientResponse,
      this.notes,
      this.sId});

  GaitData.fromJson(Map<String, dynamic> json) {
    gaitType =
        json['gaitType'] != null ? new Weight.fromJson(json['gaitType']) : null;
    distance =
        json['distance'] != null ? new Weight.fromJson(json['distance']) : null;
    assistance = json['assistance'] != null
        ? new Weight.fromJson(json['assistance'])
        : null;
    assistiveDevice = json['assistiveDevice'] != null
        ? new Weight.fromJson(json['assistiveDevice'])
        : null;
    cuing = json['cuing'] != null ? new Weight.fromJson(json['cuing']) : null;
    // gaitType = json['gaitType'];
    // distance = json['distance'];
    // assistance = json['assistance'];
    // assistiveDevice = json['assistiveDevice'];
    // cuing = json['cuing'];
    terraine = json['terraine'];
    ambulationTrainer = json['ambulationTrainer'];
    time = json['time'];
    patientResponse = json['patientResponse'];
    notes = json['notes'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gaitType != null) {
      data['gaitType'] = this.gaitType!.toJson();
    }
    if (this.distance != null) {
      data['distance'] = this.distance!.toJson();
    }
    if (this.assistance != null) {
      data['assistance'] = this.assistance!.toJson();
    }
    if (this.assistiveDevice != null) {
      data['assistiveDevice'] = this.assistiveDevice!.toJson();
    }
    if (this.cuing != null) {
      data['cuing'] = this.cuing!.toJson();
    }
    // data['gaitType'] = this.gaitType;
    // data['distance'] = this.distance;
    // data['assistance'] = this.assistance;
    // data['assistiveDevice'] = this.assistiveDevice;
    // data['cuing'] = this.cuing;
    data['terraine'] = this.terraine;
    data['ambulationTrainer'] = this.ambulationTrainer;
    data['time'] = this.time;
    data['patientResponse'] = this.patientResponse;
    data['notes'] = this.notes;
    data['_id'] = this.sId;
    return data;
  }
}
