class SmartSavingModel {
  final String status; // e.g., "active", "completed"
  final String source; // e.g., "bank", "wallet"
  final String principalAmount; // original amount saved
  final String interestRate; // in percentage, e.g., 5.5
  final String interestAmount; // calculated interest
  final String startDate; // when saving started
  final String endDate; // when saving ends

  SmartSavingModel({
    required this.status,
    required this.source,
    required this.principalAmount,
    required this.interestRate,
    required this.interestAmount,
    required this.startDate,
    required this.endDate,
  });

  factory SmartSavingModel.fromArray(List<String> array) {
    return SmartSavingModel(
        status: array[0],
        source: array[1],
        principalAmount: array[8],
        interestRate: array[2],
        interestAmount: array[7],
        startDate: array[3],
        endDate: array[5]);
  }

  factory SmartSavingModel.fromJson(Map<String, dynamic> json) {
    return SmartSavingModel(
      status: json['status'],
      source: json['source'],
      principalAmount: json['principalAmount'],
      interestRate: json['interestRate'],
      interestAmount: json['interestAmount'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'source': source,
      'principalAmount': principalAmount,
      'interestRate': interestRate,
      'interestAmount': interestAmount,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
