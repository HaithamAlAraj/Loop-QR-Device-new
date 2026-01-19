import 'package:qr_device/constants/store_data.dart';

enum RewardType { discount, freeItem }

class Stamp {
  final String id;
  final String storeId;
  final String itemName;
  final String description;
  final int slots;
  final RewardType rewardType;

  const Stamp({
    required this.id,
    this.storeId = StoreData.storeId,
    required this.itemName,
    required this.description,
    required this.slots,
    required this.rewardType,
  });
}

List<Stamp> stamps = [];
