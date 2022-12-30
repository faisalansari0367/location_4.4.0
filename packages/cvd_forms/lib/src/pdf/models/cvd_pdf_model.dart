import 'package:flutter/foundation.dart';

import '../../../models/src/chemical_use.dart';
import '../helpers/cvd_file_creator.dart';
import 'buyer_details.dart';
import 'commodity_details.dart';
import 'product_integrity/product_integrity.dart';
import 'transporter_details.dart';
import 'vendor_details.dart';

class CvdPdfModel {
  final String? vendorName,
      vendorAddress,
      vendorTown,
      vendorContact,
      vendorFax,
      vendorEmail,
      vendorNGR,
      vendorPIC,
      vendorReference,
      buyerName,
      buyerAddress,
      buyerTown,
      buyerContact,
      buyerFax,
      buyerEmail,
      buyerNGR,
      buyerPIC,
      buyerReference,
      driverName,
      driverEmail,
      driverContact,
      companyName,
      registration,
      commodity,
      period,
      variety1,
      variety2,
      sourceCheck,
      materialCheck,
      gmoCheck,
      chemicalCheck,
      qaCheck,
      qaProgram,
      certificateNumber,
      cvdCheck,
      organisationName,
      riskAssesment,
      testResult,
      riskCheck,
      nataCheck,
      signature;

  final int quantity1, quantity2;

  final List<ChemicalTable> chemicals;
  final List<String> cropList;

  CvdPdfModel({
    this.vendorName,
    this.vendorAddress,
    this.vendorTown,
    this.vendorContact,
    this.vendorFax,
    this.vendorEmail,
    this.vendorNGR,
    this.vendorPIC,
    this.vendorReference,
    this.buyerName,
    this.buyerAddress,
    this.buyerTown,
    this.buyerContact,
    this.buyerFax,
    this.buyerEmail,
    this.buyerNGR,
    this.buyerPIC,
    this.buyerReference,
    this.driverName,
    this.driverEmail,
    this.driverContact,
    this.companyName,
    this.registration,
    this.commodity,
    this.period,
    this.variety1,
    this.variety2,
    this.quantity1 = 0,
    this.quantity2 = 0,
    this.sourceCheck,
    this.materialCheck,
    this.gmoCheck,
    this.chemicalCheck,
    this.chemicals = const [],
    this.cropList = const [],
    this.qaCheck,
    this.qaProgram,
    this.certificateNumber,
    this.cvdCheck,
    this.organisationName,
    this.riskAssesment,
    this.testResult,
    this.riskCheck,
    this.nataCheck,
    this.signature,
  });

  // fromJson
  CvdPdfModel.fromJson(Map<String, dynamic> json)
      : vendorName = json['vendorName'],
        vendorAddress = json['vendorAddress'],
        vendorTown = json['vendorTown'],
        vendorContact = json['vendorContact'],
        vendorFax = json['vendorFax'],
        vendorEmail = json['vendorEmail'],
        vendorNGR = json['vendorNGR'],
        vendorPIC = json['vendorPIC'],
        vendorReference = json['vendorReference'],
        buyerName = json['buyerName'],
        buyerAddress = json['buyerAddress'],
        buyerTown = json['buyerTown'],
        buyerContact = json['buyerContact'],
        buyerFax = json['buyerFax'],
        buyerEmail = json['buyerEmail'],
        buyerNGR = json['buyerNGR'],
        buyerPIC = json['buyerPIC'],
        buyerReference = json['buyerReference'],
        driverName = json['driverName'],
        driverEmail = json['driverEmail'],
        driverContact = json['driverContact'],
        companyName = json['companyName'],
        registration = json['registration'],
        commodity = json['commodity'],
        period = json['period'],
        variety1 = json['variety1'],
        variety2 = json['variety2'],
        quantity1 = getQuantity(json['quantity1']),
        quantity2 = getQuantity(json['quantity2']),
        sourceCheck = json['sourceCheck'],
        materialCheck = json['materialCheck'],
        gmoCheck = json['gmoCheck'],
        chemicalCheck = json['chemicalCheck'],
        chemicals = (json['chemicals'] ?? []).map<ChemicalTable>((e) => ChemicalTable.fromJson(e)).toList(),
        cropList = List<String>.from(json['cropList'] ?? []),
        qaCheck = json['qaCheck'],
        qaProgram = json['qaProgram'],
        certificateNumber = json['certificateNumber'],
        cvdCheck = json['cvdCheck'],
        organisationName = json['organisationName'],
        riskAssesment = json['riskAssesment'],
        testResult = json['testResult'],
        riskCheck = json['riskCheck'],
        nataCheck = json['nataCheck'],
        signature = json['signature'];

  static int getQuantity(dynamic quantity) {
    if (quantity == null) {
      return 0;
    }
    if (quantity is int) {
      return quantity;
    } else {
      return int.parse(quantity);
    }
  }

  VendorDetails _getVendor() {
    final vendorDetails = VendorDetails(
      name: vendorName ?? '',
      address: vendorAddress ?? '',
      tel: vendorContact ?? '',
      email: vendorEmail ?? '',
      fax: vendorFax ?? '',
      ngr: vendorNGR ?? '',
      pic: vendorPIC ?? '',
      contractNo: vendorReference ?? '',
      town: vendorTown ?? '',
    );
    return vendorDetails;
  }

  BuyerDetails _getBuyer() {
    final buyerDetails = BuyerDetails(
      name: buyerName ?? '',
      address: buyerAddress ?? '',
      tel: buyerContact ?? '',
      email: buyerEmail ?? '',
      fax: buyerFax ?? '',
      ngr: buyerNGR ?? '',
      pic: buyerPIC ?? '',
      refrence: buyerReference ?? '',
      town: vendorTown ?? '',
    );
    return buyerDetails;
  }

  Future<Uint8List> generatePdf() async {
    final generator = CvdFileGenerator(
      buyerDetails: _getBuyer(),
      vendorDetails: _getVendor(),
      transporterDetails: _getTransporter(),
      productIntegrityPartA: _getProductIntegrityPartA(),
      productIntegrityPartB: _getProductIntegrityPartB(),
      productIntegrityPartC: _getProductIntegrityPartC(),
      commodityDetails: _getCommodityDetails(),
    );

    return await generator.generatePdf();
  }

  TransporterDetails _getTransporter() {
    final transporterDetails = TransporterDetails(
      name: driverName ?? '',
      email: driverEmail ?? '',
      company: companyName ?? '',
      registration: registration ?? '',
      tel: driverContact ?? '',
    );
    return transporterDetails;
  }

  ProductIntegrityPartA _getProductIntegrityPartA() {
    final ProductIntegrityPartA partA = ProductIntegrityPartA(
      sourceCheck: int.parse(sourceCheck ?? '0'),
      materialCheck: int.parse(materialCheck ?? '0'),
      gmoCheck: int.parse(gmoCheck ?? ''),
    );
    return partA;
  }

  ProductIntegrityPartB _getProductIntegrityPartB() {
    final ProductIntegrityPartB partA = ProductIntegrityPartB(
      chemicalCheck: int.parse(chemicalCheck ?? '0'),
      certificateNumber: certificateNumber ?? '',
      materialCheck: int.parse(materialCheck ?? '0'),
      chemicals: chemicals,
      qaCheck: int.parse(qaCheck ?? '0'),
      cropList: cropList,
      cvdCheck: int.parse(cvdCheck ?? '0'),
      nataCheck: int.parse(nataCheck ?? '0'),
      qaName: qaProgram ?? '',
      riskAssesment: riskAssesment ?? '',
      riskCheck: int.parse(riskCheck ?? '0'),
      testResults: testResult ?? '',
    );
    return partA;
  }

  ProductIntegrityPartC _getProductIntegrityPartC() {
    final ProductIntegrityPartC partA = ProductIntegrityPartC(
      name: vendorName ?? '',
      organisationName: organisationName ?? '',
      signature: signature ?? '',
    );
    return partA;
  }

  CommodityDetails _getCommodityDetails() {
    final commodityDetails = CommodityDetails(
      commodity: commodity ?? '',
      variety: variety1 ?? '',
      variety2: variety2 ?? '',
      delivery: period ?? '',
      quantity: quantity1,
      quantity2: quantity2,
      totalQuantity: (quantity1 + quantity2).toString(),
    );
    return commodityDetails;
  }
}
