import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/stamp.dart';
import '../widgets/stamp_card.dart';
import '../widgets/app_styles.dart';
import '../widgets/filter_button.dart';

class StampsPage extends StatefulWidget {
  const StampsPage({
    super.key,
    required this.currentUserId,
  });

  final String currentUserId;

  @override
  State<StampsPage> createState() => _StampsPageState();
}

enum RewardFilter { all, discount, freeItem }

class _StampsPageState extends State<StampsPage> {
  RewardFilter _filter = RewardFilter.all;
  final Map<String, int> _quantities = {};

  List<Stamp> get _filteredStamps {
    switch (_filter) {
      case RewardFilter.discount:
        return stamps.where((stamp) => stamp.rewardType == RewardType.discount).toList();
      case RewardFilter.freeItem:
        return stamps.where((stamp) => stamp.rewardType == RewardType.freeItem).toList();
      case RewardFilter.all:
        return stamps;
    }
  }

  int _getQuantity(String stampId) => _quantities[stampId] ?? 1;

  void _updateQuantity(String stampId, int next) {
    if (next < 1) return;
    setState(() {
      _quantities[stampId] = next;
    });
  }

  void _showQr(BuildContext context, Stamp stamp) {
    final quantity = _getQuantity(stamp.id);
    final payload = 'stamp_${stamp.id}_${stamp.storeId}_${widget.currentUserId}';

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generated QR'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: payload,
              size: 220,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 12),
            Text('Quantity: $quantity', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              payload,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          BigButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              FilterButton(
                label: 'All',
                selected: _filter == RewardFilter.all,
                onTap: () => setState(() => _filter = RewardFilter.all),
              ),
              const SizedBox(width: 12),
              FilterButton(
                label: 'Discount',
                selected: _filter == RewardFilter.discount,
                onTap: () => setState(() => _filter = RewardFilter.discount),
              ),
              const SizedBox(width: 12),
              FilterButton(
                label: 'Free Item',
                selected: _filter == RewardFilter.freeItem,
                onTap: () => setState(() => _filter = RewardFilter.freeItem),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: _filteredStamps.length,
            itemBuilder: (context, index) {
              final stamp = _filteredStamps[index];
              final quantity = _getQuantity(stamp.id);
              return StampCard(
                stamp: stamp,
                quantity: quantity,
                onMinus: () => _updateQuantity(stamp.id, quantity - 1),
                onPlus: () => _updateQuantity(stamp.id, quantity + 1),
                onGenerate: () => _showQr(context, stamp),
              );
            },
          ),
        ),
      ],
    );
  }
}