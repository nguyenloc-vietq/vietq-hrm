class UserModels {
  int? id;
  String? companyCode;
  String? userCode;
  String? email;
  String? phone;
  String? fullName;
  String? address;
  String? avatar;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  Company? company;
  UserProfessionals? userProfessionals;

  UserModels(
      {this.id,
        this.companyCode,
        this.userCode,
        this.email,
        this.phone,
        this.fullName,
        this.address,
        this.avatar,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.company,
        this.userProfessionals});

  UserModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyCode = json['companyCode'];
    userCode = json['userCode'];
    email = json['email'];
    phone = json['phone'];
    fullName = json['fullName'];
    address = json['address'];
    avatar = json['avatar'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
    userProfessionals = json['userProfessionals'] != null
        ? new UserProfessionals.fromJson(json['userProfessionals'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyCode'] = this.companyCode;
    data['userCode'] = this.userCode;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['fullName'] = this.fullName;
    data['address'] = this.address;
    data['avatar'] = this.avatar;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    if (this.userProfessionals != null) {
      data['userProfessionals'] = this.userProfessionals!.toJson();
    }
    return data;
  }
}

class Company {
  Null? address;
  String? companyName;

  Company({this.address, this.companyName});

  Company.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['companyName'] = this.companyName;
    return data;
  }
}

class UserProfessionals {
  String? position;
  String? employeeType;

  UserProfessionals({this.position, this.employeeType});

  UserProfessionals.fromJson(Map<String, dynamic> json) {
    position = json['position'];
    employeeType = json['employeeType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.position;
    data['employeeType'] = this.employeeType;
    return data;
  }
}
