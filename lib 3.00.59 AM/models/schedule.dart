class Schedule {
  int day;
  dynamic date;
  dynamic startTime;
  dynamic endTime;
  bool isBlock;
  dynamic isSelected = false;

  Schedule(
      {this.day,
      this.date,
      this.startTime,
      this.endTime,
      this.isBlock});

  Schedule.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    isBlock = json['is_block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['is_block'] = this.isBlock;
    return data;
  }
}
