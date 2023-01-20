class PlanDetailsModel {
  String? status;
  List<Plan>? data;

  PlanDetailsModel({this.status, this.data});

  PlanDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Plan>[];
      json['data'].forEach((v) {
        data!.add(Plan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<Plan>? getPlanByRole(String role) {
    if (data != null) {
      final Iterable<Plan>? plans = data!.where(
          (element) => element.role?.toLowerCase() == role.toLowerCase());
      if (plans?.isNotEmpty ?? false) {
        // final Plan? plan = plans?.first;
        // if (plan != null) {
        // data.addAll(plan.toJson());
        return plans!.toList();
        // }
      }
    }
    return null;
  }
}

enum Subscriptions { monthly, yearly, none }

extension SubscriptionsExt on Subscriptions {
  bool get isMonthly => Subscriptions.monthly == this;
  bool get isYearly => Subscriptions.yearly == this;
}

class Plan {
  int? id;
  Subscriptions paymentType = Subscriptions.none;
  String? paymentMode;
  int? amount;
  String? priceId;
  String? role;
  int? pic;
  int? geofence;
  bool? isFreeGateSign;
  bool? isEmergencyWarning;
  bool? isVisitorLogbook;
  bool? isEcvd;
  bool? isElwd;
  bool? isWorkSaftey;
  bool? isDesktopAccess;
  String? createdAt;
  String? updatedAt;

  Plan(
      {this.id,
      this.paymentType = Subscriptions.none,
      this.paymentMode,
      this.amount,
      this.priceId,
      this.role,
      this.pic,
      this.geofence,
      this.isFreeGateSign,
      this.isEmergencyWarning,
      this.isVisitorLogbook,
      this.isEcvd,
      this.isElwd,
      this.isWorkSaftey,
      this.isDesktopAccess,
      this.createdAt,
      this.updatedAt});

  Subscriptions fromPaymentType(String? paymentType) {
    final type = paymentType?.toLowerCase();
    if (type == 'monthly') {
      return Subscriptions.monthly;
    } else if (type == 'yearly') {
      return Subscriptions.yearly;
    }
    return Subscriptions.none;
  }

  String? toPaymentType(Subscriptions paymentType) {
    if (paymentType.isMonthly) {
      return 'Monthly';
    } else if (paymentType.isYearly) {
      return 'Yearly';
    }
    return null;
  }

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentType = fromPaymentType(json['paymentType']);
    paymentMode = json['paymentMode'];
    amount = json['amount'];
    priceId = json['priceId'];
    role = json['role'];
    pic = json['pic'];
    geofence = json['geofence'];
    isFreeGateSign = json['isFreeGateSign'];
    isEmergencyWarning = json['isEmergencyWarning'];
    isVisitorLogbook = json['isVisitorLogbook'];
    isEcvd = json['isEcvd'];
    isElwd = json['isElwd'];
    isWorkSaftey = json['isWorkSaftey'];
    isDesktopAccess = json['isDesktopAccess'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['paymentType'] = toPaymentType(paymentType);
    data['paymentMode'] = paymentMode;
    data['amount'] = amount;
    data['priceId'] = priceId;
    data['role'] = role;
    data['pic'] = pic;
    data['geofence'] = geofence;
    data['isFreeGateSign'] = isFreeGateSign;
    data['isEmergencyWarning'] = isEmergencyWarning;
    data['isVisitorLogbook'] = isVisitorLogbook;
    data['isEcvd'] = isEcvd;
    data['isElwd'] = isElwd;
    data['isWorkSaftey'] = isWorkSaftey;
    data['isDesktopAccess'] = isDesktopAccess;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
