class QuestionData<T> {
  String question;
  T? value;
  String? key;

  QuestionData({required this.question, this.value, this.key});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'field': question,
      'value': value,
    };
  }

  factory QuestionData.fromJson(Map<String, dynamic> map) {
    return QuestionData(
      question: map['field'] as String,
      value: map['value'] as dynamic,
    );
  }
}
