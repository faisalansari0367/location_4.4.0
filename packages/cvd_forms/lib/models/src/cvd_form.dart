// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cvd_forms/src/cvd_form_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

// import 'package:intl/intl.dart';

import '../models.dart';

class CvdForm {
  VendorDetailsModel? vendorDetails;
  BuyerDetailsModel? buyerDetailsModel;
  TransporterDetailsModel? transporterDetails;
  CommodityDetailsModel? commodityDetails;
  ChemicalUseDetailsModel? chemicalUseDetailsModel;
  ProductIntegrityDetailsModel? productIntegrityDetailsModel;
  DateTime? createdAt = DateTime.now();
  String? riskAssesment;
  String? testResult;
  String? signature;
  String? organisationName;

  CvdForm({
    this.createdAt,
    this.vendorDetails,
    this.buyerDetailsModel,
    this.transporterDetails,
    this.commodityDetails,
    this.chemicalUseDetailsModel,
    this.productIntegrityDetailsModel,
    this.organisationName,
    this.riskAssesment,
    this.testResult,
    this.signature,
  });

  static Future<CvdForm> init(BuildContext context) async {
    final helper = CvdFormUtils(context: context);
    return await helper.initForm();
  }

  Map<String, dynamic> toJson() {
    final json = {
      'createdAt': createdAt?.toIso8601String(),
      'vendorDetails': vendorDetails?.toJson(),
      'buyerDetailsModel': buyerDetailsModel?.toJson(),
      'transporterDetails': transporterDetails?.toJson(),
      'commodityDetails': commodityDetails?.toJson(),
      'chemicalUseDetailsModel': chemicalUseDetailsModel?.toJson(),
      'productIntegrityDetailsModel': productIntegrityDetailsModel?.toJson(),
      'organisationName': organisationName,
      'riskAssesment': riskAssesment,
      'testResult': testResult,
      'signature': signature,
    };
    return json;
  }

  CvdForm copyWith({
    VendorDetailsModel? vendorDetails,
    BuyerDetailsModel? buyerDetailsModel,
    TransporterDetailsModel? transporterDetails,
    CommodityDetailsModel? commodityDetails,
    ChemicalUseDetailsModel? chemicalUseDetailsModel,
    ProductIntegrityDetailsModel? productIntegrityDetailsModel,
    String? riskAssesment,
    String? testResult,
    String? signature,
    String? organisationName,
  }) {
    return CvdForm(
      vendorDetails: vendorDetails ?? this.vendorDetails,
      buyerDetailsModel: buyerDetailsModel ?? this.buyerDetailsModel,
      transporterDetails: transporterDetails ?? this.transporterDetails,
      commodityDetails: commodityDetails ?? this.commodityDetails,
      chemicalUseDetailsModel: chemicalUseDetailsModel ?? this.chemicalUseDetailsModel,
      productIntegrityDetailsModel: productIntegrityDetailsModel ?? this.productIntegrityDetailsModel,
      riskAssesment: riskAssesment ?? this.riskAssesment,
      testResult: testResult ?? this.testResult,
      signature: signature ?? this.signature,
      organisationName: organisationName ?? this.organisationName,
    );
  }

  Map<String, dynamic> toFormJson() {
    final vendor = vendorDetails!;
    final buyerDetailsModel = this.buyerDetailsModel!;
    final transporterDetails = this.transporterDetails!;
    final commodityDetails = this.commodityDetails!;
    final chemicalUseDetailsModel = this.chemicalUseDetailsModel!;
    final productIntegrityDetailsModel = this.productIntegrityDetailsModel!;

    return {
      'vendorName': vendor.name!.value,
      'vendorAddress': vendor.address!.value,
      'vendorTown': vendor.town!.value,
      'vendorContact': vendor.tel!.value,
      'vendorFax': vendor.fax!.value,
      'vendorEmail': vendor.email!.value,
      'vendorNGR': vendor.ngr!.value,
      'vendorPIC': vendor.pic!.value,
      'vendorReference': vendor.refrenceNo!.value,
      'buyerName': buyerDetailsModel.name!.value,
      'buyerAddress': buyerDetailsModel.address!.value,
      'buyerTown': buyerDetailsModel.town!.value,
      'buyerContact': buyerDetailsModel.tel!.value,
      'buyerFax': buyerDetailsModel.fax!.value,
      'buyerEmail': buyerDetailsModel.email!.value,
      'buyerNGR': buyerDetailsModel.ngr!.value,
      'buyerPIC': buyerDetailsModel.pic!.value,
      'buyerReference': buyerDetailsModel.contractNo!.value,
      'driverName': transporterDetails.name?.value,
      'driverEmail': transporterDetails.email?.value,
      'driverContact': transporterDetails.mobile?.value,
      'companyName': transporterDetails.company?.value,
      'registration': transporterDetails.registration?.value,
      'commodity': commodityDetails.commodity!.value,
      'period': MyDateFormat.formatDate(DateTime.tryParse(commodityDetails.deliveryPeriod!.value!)),
      'variety1': commodityDetails.variety1!.value,
      'variety2': commodityDetails.variety2!.value,
      'quantity1': commodityDetails.quantity1!.value,
      'quantity2': commodityDetails.quantity2!.value,
      'sourceCheck': productIntegrityDetailsModel.sourceCheck?.value,
      'materialCheck': productIntegrityDetailsModel.materialCheck?.value,
      'gmoCheck': productIntegrityDetailsModel.gmoCheck?.value,
      'chemicalCheck': chemicalUseDetailsModel.chemicalCheck?.value,
      'chemicals': chemicalUseDetailsModel.chemicalTable.map((e) => e.toJson()).toList(),
      'qaCheck': chemicalUseDetailsModel.qaCheck?.value,
      'qaProgram': chemicalUseDetailsModel.qaProgram?.value,
      'certificateNumber': chemicalUseDetailsModel.certificateNumber?.value,
      'cvdCheck': chemicalUseDetailsModel.cvdCheck?.value,
      'organisationName': organisationName,
      'riskAssesment': riskAssesment,
      'testResult': testResult,
      'cropList':
          chemicalUseDetailsModel.cropList?.value == null || (chemicalUseDetailsModel.cropList?.value?.isEmpty ?? true)
              ? []
              : chemicalUseDetailsModel.cropList?.value!.split(',').map((e) => e).toList(),
      'riskCheck': chemicalUseDetailsModel.riskCheck?.value,
      'nataCheck': chemicalUseDetailsModel.nataCheck?.value,
      'signature': signature,
    };
  }

  factory CvdForm.fromJson(Map<String, dynamic> map) {
    return CvdForm(
      organisationName: map['organisationName'] as String?,
      riskAssesment: map['riskAssesment'] as String?,
      testResult: map['testResult'] as String?,
      signature: map['signature'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'] as String)?.toLocal() : null,
      vendorDetails: map['vendorDetails'] == null ? null : VendorDetailsModel.fromJson(map['vendorDetails']),
      buyerDetailsModel: map['buyerDetailsModel'] == null ? null : BuyerDetailsModel.fromJson(map['buyerDetailsModel']),
      transporterDetails:
          map['transporterDetails'] == null ? null : TransporterDetailsModel.fromJson(map['transporterDetails']),
      commodityDetails:
          map['commodityDetails'] == null ? null : CommodityDetailsModel.fromJson(map['commodityDetails']),
      chemicalUseDetailsModel: map['chemicalUseDetailsModel'] == null
          ? null
          : ChemicalUseDetailsModel.fromJson(map['chemicalUseDetailsModel']),
      productIntegrityDetailsModel: map['productIntegrityDetailsModel'] == null
          ? null
          : ProductIntegrityDetailsModel.fromJson(map['productIntegrityDetailsModel']),
    );
  }

  @override
  String toString() {
    return 'CvdForm(vendorDetails: $vendorDetails, buyerDetailsModel: $buyerDetailsModel, transporterDetails: $transporterDetails, commodityDetails: $commodityDetails, chemicalUseDetailsModel: $chemicalUseDetailsModel, productIntegrityDetailsModel: $productIntegrityDetailsModel)';
  }

  @override
  bool operator ==(covariant CvdForm other) {
    if (identical(this, other)) return true;

    return other.vendorDetails == vendorDetails &&
        other.buyerDetailsModel == buyerDetailsModel &&
        other.transporterDetails == transporterDetails &&
        other.commodityDetails == commodityDetails &&
        other.chemicalUseDetailsModel == chemicalUseDetailsModel &&
        other.riskAssesment == riskAssesment &&
        other.testResult == testResult &&
        other.organisationName == organisationName &&
        other.signature == signature &&
        other.productIntegrityDetailsModel == productIntegrityDetailsModel;
  }

  @override
  int get hashCode {
    return vendorDetails.hashCode ^
        buyerDetailsModel.hashCode ^
        transporterDetails.hashCode ^
        commodityDetails.hashCode ^
        chemicalUseDetailsModel.hashCode ^
        riskAssesment.hashCode ^
        testResult.hashCode ^
        organisationName.hashCode ^
        signature.hashCode ^
        productIntegrityDetailsModel.hashCode;
  }
}
