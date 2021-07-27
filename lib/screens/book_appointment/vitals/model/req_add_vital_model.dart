class ReqAddVitalsModel {
  String date;
  String time;
  String sbp;
  String dbp;
  String heartRate;
  String oxygenSaturation;
  String temperature;

  ReqAddVitalsModel(
      {this.date,
      this.time,
      this.sbp,
      this.dbp,
      this.heartRate,
      this.oxygenSaturation,
      this.temperature});

  ReqAddVitalsModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    sbp = json['sbp'];
    dbp = json['dbp'];
    heartRate = json['heartRate'];
    oxygenSaturation = json['oxygenSaturation'];
    temperature = json['temperature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['sbp'] = this.sbp;
    data['dbp'] = this.dbp;
    data['heartRate'] = this.heartRate;
    data['oxygenSaturation'] = this.oxygenSaturation;
    data['temperature'] = this.temperature;
    return data;
  }
}
