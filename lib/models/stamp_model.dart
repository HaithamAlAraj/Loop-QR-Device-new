class StampModel {
  final String id;
  final String itemName;
  final String? description;
  final String? imageUrl;
  final String? iconUrl;
  final int stampsRequired;
  final String rewardType;
  final DateTime? startDate;
  final DateTime? endDate;

  const StampModel({
    required this.id,
    required this.itemName,
    this.description,
    this.imageUrl,
    this.iconUrl,
    required this.stampsRequired,
    required this.rewardType,
    this.startDate,
    this.endDate,
  });

  factory StampModel.fromJson(Map<String, dynamic> json) {
    return StampModel(
      id: json['stampId'] as String? ?? '',
      itemName: json['stampName'] as String? ?? '',
      description: json['stampDescription'] as String?,
      imageUrl: json['imageUrl'] as String?,
      iconUrl: json['iconUrl'] as String?,
      stampsRequired: json['stampsRequired'] as int? ?? 0,
      rewardType: _mapRewardType(json['rewardType'] as String? ?? ''),
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
    );
  }

  bool get isDiscount => rewardType.toLowerCase() == 'discount';
  bool get isFreeItem => rewardType.toLowerCase().contains('free');

  static String _mapRewardType(String value) {
    switch (value) {
      case 'Collect':
        return 'Discount';
      case 'Reward':
        return 'FreeItem';
      default:
        return value;
    }
  }
}
