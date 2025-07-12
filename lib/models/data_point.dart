class DataPoint {
  final String stateId;
  final String state;
  final String seriesId;
  final String energyType;
  final int year;
  final double value;

  DataPoint({
    required this.stateId,
    required this.state,
    required this.seriesId,
    required this.energyType,
    required this.year,
    required this.value,
  });

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    return DataPoint(
      stateId: json['stateId'] ?? '',
      state: json['stateDescription'] ?? '',
      seriesId: json['seriesId'] ?? '',
      energyType: json['seriesDescription'] ?? '',
      year: int.tryParse(json['period'].toString()) ?? 0,
      value: double.tryParse(json['value'].toString()) ?? 0.0,
    );
  }
}
