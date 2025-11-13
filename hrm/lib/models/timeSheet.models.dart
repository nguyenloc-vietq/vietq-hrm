class TimeSheetModels {
  int? id;
  String? payrollCode;
  String? payrollName;
  String? companyCode;
  String? startDate;
  String? endDate;
  Null? paymentDate;
  String? isLocked;
  bool? isActive;
  Company? company;
  List<AttendanceRecs>? attendanceRecs;

  TimeSheetModels(
      {this.id,
        this.payrollCode,
        this.payrollName,
        this.companyCode,
        this.startDate,
        this.endDate,
        this.paymentDate,
        this.isLocked,
        this.isActive,
        this.company,
        this.attendanceRecs});

  TimeSheetModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    payrollCode = json['payrollCode'];
    payrollName = json['payrollName'];
    companyCode = json['companyCode'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    paymentDate = json['paymentDate'];
    isLocked = json['isLocked'];
    isActive = json['isActive'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
    if (json['attendanceRecs'] != null) {
      attendanceRecs = <AttendanceRecs>[];
      json['attendanceRecs'].forEach((v) {
        attendanceRecs!.add(new AttendanceRecs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payrollCode'] = this.payrollCode;
    data['payrollName'] = this.payrollName;
    data['companyCode'] = this.companyCode;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['paymentDate'] = this.paymentDate;
    data['isLocked'] = this.isLocked;
    data['isActive'] = this.isActive;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    if (this.attendanceRecs != null) {
      data['attendanceRecs'] =
          this.attendanceRecs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Company {
  String? companyName;

  Company({this.companyName});

  Company.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyName'] = this.companyName;
    return data;
  }
}

class AttendanceRecs {
  int? id;
  String? userCode;
  String? workDay;
  String? timeIn;
  String? timeOut;
  String? status;
  int? lateMinutes;
  int? earlyMinutes;

  AttendanceRecs(
      {this.id,
        this.userCode,
        this.workDay,
        this.timeIn,
        this.timeOut,
        this.status,
        this.lateMinutes,
        this.earlyMinutes});

  AttendanceRecs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userCode = json['userCode'];
    workDay = json['workDay'];
    timeIn = json['timeIn'];
    timeOut = json['timeOut'];
    status = json['status'];
    lateMinutes = json['lateMinutes'];
    earlyMinutes = json['earlyMinutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userCode'] = this.userCode;
    data['workDay'] = this.workDay;
    data['timeIn'] = this.timeIn;
    data['timeOut'] = this.timeOut;
    data['status'] = this.status;
    data['lateMinutes'] = this.lateMinutes;
    data['earlyMinutes'] = this.earlyMinutes;
    return data;
  }
}
