import 'package:flutter/material.dart';
import 'package:qr_device/widgets/app_styles.dart';
import '../constants/color_palette.dart';
import '../models/stamp.dart';
import 'quantity_button.dart';

class StampCard extends StatelessWidget {
  const StampCard({
    super.key,
    required this.stamp,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
    required this.onGenerate,
  });

  final Stamp stamp;
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final rewardLabel = stamp.rewardType == RewardType.discount ? 'Discount' : 'Free Item';
    final rewardColor = stamp.rewardType == RewardType.discount ? ColorPalette.info : ColorPalette.success;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stamp.itemName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: rewardColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                rewardLabel,
                style: TextStyle(
                  color: rewardColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              stamp.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: ColorPalette.secondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                QuantityButton(
                  label: '-',
                  onPressed: onMinus,
                ),
                const SizedBox(width: 12),
                Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                QuantityButton(
                  label: '+',
                  onPressed: onPlus,
                ),
                const Spacer(),
                BigButton(
                  onPressed: onGenerate,
                  child: const Text('Generate QR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
