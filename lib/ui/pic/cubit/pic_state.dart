// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'pic_cubit.dart';

abstract class PicState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];

  // fromJson

  // toJson
}

class PicError extends PicState {
  final String error;

  PicError({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class PicLoaded extends PicState {
  final List<PicModel> pics;

  PicLoaded({required this.pics});

  @override
  List<Object?> get props => [pics];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pics': pics.map((x) => x.toJson()).toList(),
    };
  }

  factory PicLoaded.fromJson(Map<String, dynamic> map) {
    return PicLoaded(
      pics: List<PicModel>.from(
        (map['pics'] as List).map<PicModel>(
          (x) => PicModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class PicInitial extends PicState {}
