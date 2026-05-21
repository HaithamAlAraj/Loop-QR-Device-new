import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_device/controllers/stamps_controller.dart';
import 'package:qr_device/models/stamp_model.dart';
import 'package:qr_device/constants/color_palette.dart';
import 'package:qr_device/widgets/filter_button.dart';
import 'package:qr_device/views/widgets/stamp_card.dart';

enum RewardFilter { all, discount, freeItem }

class StampsPage extends StatefulWidget {
  const StampsPage({super.key});

  @override
  State<StampsPage> createState() => _StampsPageState();
}

class _StampsPageState extends State<StampsPage> {
  RewardFilter _filter = RewardFilter.all;
  final Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StampsProvider>().fetchActiveStamps();
    });
  }

  List<StampModel> get _filteredStamps {
    final stamps = context.watch<StampsProvider>().stamps;
    switch (_filter) {
      case RewardFilter.discount:
        return stamps.where((s) => s.isDiscount).toList();
      case RewardFilter.freeItem:
        return stamps.where((s) => s.isFreeItem).toList();
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

  Future<void> _showQr(BuildContext context, StampModel stamp) async {
    final stampsProvider = context.read<StampsProvider>();
    final quantity = _getQuantity(stamp.id);

    final result = await stampsProvider.generateCollectQr(stamp.id, quantity);
    if (result == null || !context.mounted) return;

    final qrId = result['qrId'] as String? ?? '';
    final expiresAtUtc = result['expiresAtUtc'] as String?;
    final expiryDate =
        expiresAtUtc != null ? DateTime.tryParse(expiresAtUtc) : null;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _QrCountdownDialog(
        payload: qrId,
        quantity: quantity,
        stampName: stamp.itemName,
        expiryDate: expiryDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stampsProvider = context.watch<StampsProvider>();

    if (stampsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (stampsProvider.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: ${stampsProvider.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => stampsProvider.fetchActiveStamps(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

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
                onTap: () =>
                    setState(() => _filter = RewardFilter.discount),
              ),
              const SizedBox(width: 12),
              FilterButton(
                label: 'Free Item',
                selected: _filter == RewardFilter.freeItem,
                onTap: () =>
                    setState(() => _filter = RewardFilter.freeItem),
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
                onMinus: () =>
                    _updateQuantity(stamp.id, quantity - 1),
                onPlus: () =>
                    _updateQuantity(stamp.id, quantity + 1),
                onGenerate: () => _showQr(context, stamp),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QrCountdownDialog extends StatefulWidget {
  final String payload;
  final int quantity;
  final String stampName;
  final DateTime? expiryDate;

  const _QrCountdownDialog({
    required this.payload,
    required this.quantity,
    required this.stampName,
    this.expiryDate,
  });

  @override
  State<_QrCountdownDialog> createState() => _QrCountdownDialogState();
}

class _QrCountdownDialogState extends State<_QrCountdownDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.expiryDate != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {});
        if (DateTime.now().toUtc().isAfter(widget.expiryDate!)) {
          _timer?.cancel();
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration get _remaining {
    if (widget.expiryDate == null) return Duration.zero;
    final remaining = widget.expiryDate!.difference(DateTime.now().toUtc());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _remaining;
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds.remainder(60);
    final timeStr =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final isExpiring = remaining.inSeconds < 30 && remaining > Duration.zero;
    final isExpired = remaining == Duration.zero;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        _timer?.cancel();
        if (!didPop) Navigator.of(context).pop();
      },
      child: AlertDialog(
        title: const Text('Collect QR'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: widget.payload,
              size: 220,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 12),
            Text('Quantity: ${widget.quantity}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              widget.stampName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isExpired ? 'Expired' : 'Expires in $timeStr',
              style: TextStyle(
                fontSize: 14,
                color: isExpired || isExpiring ? Colors.red : Colors.grey[600],
                fontWeight:
                    isExpired || isExpiring ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(color: ColorPalette.primary),
            ),
          ),
        ],
      ),
    );
  }
}
