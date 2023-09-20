class HcRevenue {
  int? status;
  RevenueListData? data;
  String? message;
  Error? error;
  int? dataCount;

  HcRevenue({this.status, this.data, this.message, this.error, this.dataCount});

  HcRevenue.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? RevenueListData.fromJson(json['data']) : null;
    message = json['message'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
    dataCount = json['dataCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }
    data['dataCount'] = this.dataCount;
    return data;
  }
}

class RevenueListData {
  List<RevenuesData>? revenuesData;
  String? totalPayout;

  RevenueListData({this.revenuesData, this.totalPayout});

  RevenueListData.fromJson(Map<String, dynamic> json) {
    if (json['revenuesData'] != null) {
      revenuesData = <RevenuesData>[];
      json['revenuesData'].forEach((v) {
        revenuesData!.add(new RevenuesData.fromJson(v));
      });
    }
    totalPayout = json['totalPayout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.revenuesData != null) {
      data['revenuesData'] = this.revenuesData!.map((v) => v.toJson()).toList();
    }
    data['totalPayout'] = this.totalPayout;
    return data;
  }
}

class RevenuesData {
  String? sId;
  HcConsultationId? hcConsultationId;
  UserId? specialExpertId;
  int? iV;
  String? commission;
  String? createdAt;
  String? payout;
  int? serviceTax;
  String? sessionCost;
  String? updatedAt;
  String? id;

  RevenuesData(
      {this.sId,
      this.hcConsultationId,
      this.specialExpertId,
      this.iV,
      this.commission,
      this.createdAt,
      this.payout,
      this.serviceTax,
      this.sessionCost,
      this.updatedAt,
      this.id});

  RevenuesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    hcConsultationId = json['hcConsultationId'] != null
        ? new HcConsultationId.fromJson(json['hcConsultationId'])
        : null;
    specialExpertId = json['specialExpertId'] != null
        ? new UserId.fromJson(json['specialExpertId'])
        : null;
    iV = json['__v'];
    commission = json['commission'];
    createdAt = json['created_at'];
    payout = json['payout'];
    serviceTax = json['serviceTax'];
    sessionCost = json['sessionCost'];
    updatedAt = json['updated_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.hcConsultationId != null) {
      data['hcConsultationId'] = this.hcConsultationId!.toJson();
    }
    if (this.specialExpertId != null) {
      data['specialExpertId'] = this.specialExpertId!.toJson();
    }
    data['__v'] = this.iV;
    data['commission'] = this.commission;
    data['created_at'] = this.createdAt;
    data['payout'] = this.payout;
    data['serviceTax'] = this.serviceTax;
    data['sessionCost'] = this.sessionCost;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}

class HcConsultationId {
  List<UserId>? userId;
  String? sId;
  String? startDate;
  String? startTime;

  HcConsultationId({this.userId, this.sId, this.startDate, this.startTime});

  HcConsultationId.fromJson(Map<String, dynamic> json) {
    if (json['userId'] != null) {
      userId = <UserId>[];
      json['userId'].forEach((v) {
        userId!.add(new UserId.fromJson(v));
      });
    }
    sId = json['_id'];
    startDate = json['startDate'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userId != null) {
      data['userId'] = this.userId!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['startDate'] = this.startDate;
    data['startTime'] = this.startTime;
    return data;
  }
}

class UserId {
  String? sId;
  String? mobileNo;
  String? email;
  String? firstName;
  String? lastName;
  String? imageUrl;

  UserId(
      {this.sId,
      this.mobileNo,
      this.email,
      this.firstName,
      this.lastName,
      this.imageUrl});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobileNo'] = this.mobileNo;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}

class Error {
  String? data;

  Error({this.data});

  Error.fromJson(Map<String, dynamic> json) {
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    return data;
  }
}
