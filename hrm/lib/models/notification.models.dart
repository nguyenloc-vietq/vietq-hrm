class NotificationModel {
  int? id;
  String? userCode;
  String? notificationCode;
  bool? isRead;
  String? readAt;
  String? receivedAt;
  String? note;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  Notification? notification;

  NotificationModel({this.id, this.userCode, this.notificationCode, this.isRead, this.readAt, this.receivedAt, this.note, this.isActive, this.createdAt, this.updatedAt, this.notification});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userCode = json['userCode'];
    notificationCode = json['notificationCode'];
    isRead = json['isRead'];
    readAt = json['readAt'];
    receivedAt = json['receivedAt'];
    note = json['note'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    notification = json['notification'] != null ? new Notification.fromJson(json['notification']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userCode'] = this.userCode;
    data['notificationCode'] = this.notificationCode;
    data['isRead'] = this.isRead;
    data['readAt'] = this.readAt;
    data['receivedAt'] = this.receivedAt;
    data['note'] = this.note;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    return data;
  }
}

class Notification {
  int? id;
  String? notificationCode;
  String? notificationType;
  String? title;
  String? body;
  String? targetType;
  String? targetValue;
  String? typeSystem;
  String? scheduleTime;
  int? openSent;
  bool? isSent;
  String? createdAt;
  String? updatedAt;
  bool? isActive;

  Notification({this.id, this.notificationCode, this.notificationType, this.title, this.body, this.targetType, this.targetValue, this.typeSystem, this.scheduleTime, this.openSent, this.isSent, this.createdAt, this.updatedAt, this.isActive});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationCode = json['notificationCode'];
    notificationType = json['notificationType'];
    title = json['title'];
    body = json['body'];
    targetType = json['targetType'];
    targetValue = json['targetValue'];
    typeSystem = json['typeSystem'];
    scheduleTime = json['scheduleTime'];
    openSent = json['openSent'];
    isSent = json['isSent'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notificationCode'] = this.notificationCode;
    data['notificationType'] = this.notificationType;
    data['title'] = this.title;
    data['body'] = this.body;
    data['targetType'] = this.targetType;
    data['targetValue'] = this.targetValue;
    data['typeSystem'] = this.typeSystem;
    data['scheduleTime'] = this.scheduleTime;
    data['openSent'] = this.openSent;
    data['isSent'] = this.isSent;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['isActive'] = this.isActive;
    return data;
  }
}
