class ReqTreatedConditionTimeModel {
  String? flag;
  List<LongAgo>? longAgo;

  ReqTreatedConditionTimeModel({this.flag, this.longAgo});

  ReqTreatedConditionTimeModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    if (json['longAgo'] != null) {
      longAgo = <LongAgo>[];
      json['longAgo'].forEach((v) {
        longAgo!.add(new LongAgo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    if (this.longAgo != null) {
      data['longAgo'] = this.longAgo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LongAgo {
  String? hour;
  String? day;
  String? week;
  String? month;
  String? year;

  LongAgo({this.hour, this.day, this.month, this.week, this.year});

  LongAgo.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    month = json['month'];
    week = json['week'];
    hour = json['hour'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['month'] = this.month;
    data['week'] = this.week;
    data['hour'] = this.hour;
    data['year'] = this.year;
    return data;
  }
}
