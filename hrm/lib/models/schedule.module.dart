class ScheduleModels {
  int? id;
  String? scheduleCode;
  String? payrollCode;
  String? userCode;
  String? shiftCode;
  String? workOn;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  Shift? shift;
  int? totalDay;
  int? totalWokingDay;

  ScheduleModels(
      {this.id,
        this.scheduleCode,
        this.payrollCode,
        this.userCode,
        this.shiftCode,
        this.workOn,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.shift,
        this.totalDay,
        this.totalWokingDay});

  ScheduleModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduleCode = json['scheduleCode'];
    payrollCode = json['payrollCode'];
    userCode = json['userCode'];
    shiftCode = json['shiftCode'];
    workOn = json['workOn'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    shift = json['shift'] != null ? new Shift.fromJson(json['shift']) : null;
    totalDay = json['totalDay'];
    totalWokingDay = json['totalWokingDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['scheduleCode'] = this.scheduleCode;
    data['payrollCode'] = this.payrollCode;
    data['userCode'] = this.userCode;
    data['shiftCode'] = this.shiftCode;
    data['workOn'] = this.workOn;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    data['totalDay'] = this.totalDay;
    data['totalWokingDay'] = this.totalWokingDay;
    return data;
  }
}

class Shift {
  String? shiftCode;
  String? name;
  String? startTime;
  String? endTime;

  Shift({this.shiftCode, this.name, this.startTime, this.endTime});

  Shift.fromJson(Map<String, dynamic> json) {
    shiftCode = json['shiftCode'];
    name = json['name'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftCode'] = this.shiftCode;
    data['name'] = this.name;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}
