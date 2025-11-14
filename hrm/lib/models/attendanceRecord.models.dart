class AttendanceRecordModels {
  int? id;
  String? userCode;
  String? payrollCode;
  String? workDay;
  String? timeIn;
  String? timeOut;
  String? status;
  int? lateMinutes;
  int? earlyMinutes;
  String? createdAt;
  String? updatedAt;

  AttendanceRecordModels(
      {this.id,
        this.userCode,
        this.payrollCode,
        this.workDay,
        this.timeIn,
        this.timeOut,
        this.status,
        this.lateMinutes,
        this.earlyMinutes,
        this.createdAt,
        this.updatedAt});

  AttendanceRecordModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userCode = json['userCode'];
    payrollCode = json['payrollCode'];
    workDay = json['workDay'];
    timeIn = json['timeIn'];
    timeOut = json['timeOut'];
    status = json['status'];
    lateMinutes = json['lateMinutes'];
    earlyMinutes = json['earlyMinutes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userCode'] = this.userCode;
    data['payrollCode'] = this.payrollCode;
    data['workDay'] = this.workDay;
    data['timeIn'] = this.timeIn;
    data['timeOut'] = this.timeOut;
    data['status'] = this.status;
    data['lateMinutes'] = this.lateMinutes;
    data['earlyMinutes'] = this.earlyMinutes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
