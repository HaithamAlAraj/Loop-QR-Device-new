import '../../models/stamp.dart';

RewardType rewardTypeFromString(String raw) {
  switch (raw.toLowerCase()) {
    case 'discount':
      return RewardType.discount;
    case 'freeitem':
    case 'free_item':
    case 'free-item':
      return RewardType.freeItem;
    default:
      throw StateError('Unknown reward_type: $raw');
  }
}
