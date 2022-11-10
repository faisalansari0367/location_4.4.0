class WitholdingPeriodModel {
  String? productNumber;
  String? aPVMARegisteredProductName;
  String? wHPDays;
  String? eSIDays;
  String? rate;
  String? unit;

  WitholdingPeriodModel({
    this.productNumber,
    this.aPVMARegisteredProductName,
    this.wHPDays,
    this.eSIDays,
  });

  WitholdingPeriodModel.fromJson(Map<String, dynamic> json) {
    productNumber = json['Product number'];
    aPVMARegisteredProductName = json['APVMA registered product name'];
    wHPDays = json['WHP (days)'];
    eSIDays = json['ESI (days)'];
    rate = json['Rate'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Product number'] = this.productNumber;
    data['APVMA registered product name'] = this.aPVMARegisteredProductName;
    data['WHP (days)'] = this.wHPDays;
    data['ESI (days)'] = this.eSIDays;
    return data;
  }
}
