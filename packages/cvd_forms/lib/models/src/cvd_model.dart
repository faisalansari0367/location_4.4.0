// ignore_for_file: public_member_api_docs, sort_constructors_first
class CvdModel {
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String buyerName;
  final String? pic;
  final String transporter;
  final String cvdName;
  final String? pdfUrl;
  final int? id;

  CvdModel({
    this.createdAt,
    this.updatedAt,
    required this.buyerName,
    this.pic,
    required this.transporter,
    required this.cvdName,
    this.pdfUrl,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'id': id,
      'buyerName': buyerName,
      'pic': pic,
      'transporter': transporter,
      'cvdName': cvdName,
      'pdfUrl': pdfUrl,
    };
  }

  // List<MapEntry<String, String>> toForm() {
  //   return <MapEntry<String, String>>[
  //     MapEntry('buyerName', buyerName),
  //     MapEntry('pic', pic ?? ''),
  //     MapEntry('transporter', transporter),
  //     MapEntry('cvdName', cvdName),
  //     MapEntry('pdfUrl', pdfUrl),
  //   ];
  // }

  factory CvdModel.fromJson(Map<String, dynamic> map) {
    return CvdModel(
      createdAt: _parseDate(map['createdAt'] as String?),
      updatedAt: _parseDate(map['updatedAt'] as String?),
      buyerName: map['buyerName'] as String? ?? '',
      pic: map['pic'] as String?,
      transporter: map['transporter'] as String? ?? '',
      cvdName: map['cvdName'] as String? ?? '',
      pdfUrl: map['pdfUrl'] as String? ?? '',
      id: map['id'] as int,
    );
  }

  static DateTime? _parseDate(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date)?.toLocal();
  }
}
