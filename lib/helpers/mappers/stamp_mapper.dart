import 'package:qr_device/constants/store_data.dart';

import '../../models/stamp.dart';
import 'reward_type_mapper.dart';

class QrStampMapper {
  static Stamp fromGraphqlNode(Map<String, dynamic> node) {
    return Stamp(
      id: node['stamp_id'] as String,
      storeId: StoreData.storeId,
      itemName: node['name'] as String,
      description: node['description'] as String,
      slots: node['stamps_required'] as int,
      rewardType: rewardTypeFromString(node['reward_type'] as String),
    );
  }

  static List<Stamp> listFromGraphqlData(Map<String, dynamic> data) {
    final edges = (data['stampsCollection']?['edges'] as List<dynamic>? ?? const []);

    return edges.map((e) => e['node'] as Map<String, dynamic>).map(fromGraphqlNode).toList(growable: false);
  }
}
