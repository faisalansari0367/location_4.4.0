// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';

class CvdFormUtils {
  final BuildContext context;
  CvdFormUtils({
    required this.context,
  });

  Future<CvdForm> initForm() async {
    final futures = [
      _fetchVendorDetailsModel(),
      _fetchBuyerDetailsModel(),
      _fetchTransporterDetailsModel(),
      _fetchCommodityDetailsModel(),
      _fetchChemicalUseDetailsModel(),
      _fetchPartIntegrityDetailsModel(),
    ];
    final results = await Future.wait(futures);
    final cvdForm = CvdForm(
      vendorDetails: results[0] as VendorDetailsModel,
      buyerDetailsModel: results[1] as BuyerDetailsModel,
      transporterDetails: results[2] as TransporterDetailsModel,
      commodityDetails: results[3] as CommodityDetailsModel,
      chemicalUseDetailsModel: results[4] as ChemicalUseDetailsModel,
      productIntegrityDetailsModel: results[5] as ProductIntegrityDetailsModel,
    );
    return cvdForm;
  }

  Future<Map<String, dynamic>> loadJson(String path) async {
    // /assets/json/buyer_details.json
    try {
      final data = await rootBundle.loadString("packages/cvd_forms/$path");
      final map = jsonDecode(data);
      return map;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<VendorDetailsModel> _fetchVendorDetailsModel() async {
    final data = await loadJson('assets/json/vendor_details.json');
    return VendorDetailsModel.fromJson(data);
  }

  Future<BuyerDetailsModel> _fetchBuyerDetailsModel() async {
    final data = await loadJson('assets/json/buyer_details.json');
    return BuyerDetailsModel.fromJson(data);
  }

  Future<TransporterDetailsModel> _fetchTransporterDetailsModel() async {
    final data = await loadJson('assets/json/transporter_details.json');
    return TransporterDetailsModel.fromJson(data);
  }

  Future<CommodityDetailsModel> _fetchCommodityDetailsModel() async {
    final data = await loadJson('assets/json/commodity_details.json');
    return CommodityDetailsModel.fromJson(data);
  }

  Future<ChemicalUseDetailsModel> _fetchChemicalUseDetailsModel() async {
    final data = await loadJson('assets/json/chemical_use.json');
    return ChemicalUseDetailsModel.fromJson(data);
  }

  Future<ProductIntegrityDetailsModel> _fetchPartIntegrityDetailsModel() async {
    final data = await loadJson('assets/json/part_integrity_form.json');
    final productIntegrityDetailsModel = ProductIntegrityDetailsModel.fromJson(data['data']);
    return productIntegrityDetailsModel;
  }
}
