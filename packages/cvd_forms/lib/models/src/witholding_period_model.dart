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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Product number'] = productNumber;
    data['APVMA registered product name'] = aPVMARegisteredProductName;
    data['WHP (days)'] = wHPDays;
    data['ESI (days)'] = eSIDays;
    return data;
  }
}
