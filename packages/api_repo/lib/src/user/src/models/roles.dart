enum Roles {
  internationalTraveller,
  producer,
  employee,
  contractor,
  agent,
  supplier,
  visitor,
  transporter,
  consignee,
  processor,
  feedlotter,
}

extension RolesString on String {
  Roles get getRole {
    final result =
        Roles.values.firstWhere((element) => element.name.toLowerCase() == replaceAll(' ', '').toLowerCase());
    return result;
  }
}

extension RolesExt on Roles {
  bool get isInternationalTraveller => this == Roles.internationalTraveller;
  bool get isProducer => this == Roles.producer;
  bool get isEmployee => this == Roles.employee;
  bool get isContractor => this == Roles.contractor;
  bool get isAgent => this == Roles.agent;
  bool get isSupplier => this == Roles.supplier;
  bool get isVisitor => this == Roles.visitor;
  bool get isTransporter => this == Roles.transporter;
  bool get isConsignee => this == Roles.consignee;
  bool get isProcessor => this == Roles.processor;
  bool get isFeedlotter => this == Roles.feedlotter;
}
