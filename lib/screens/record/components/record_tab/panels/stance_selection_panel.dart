import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/utils/colors.dart';

class StanceSelectionPanel extends StatefulWidget {
  const StanceSelectionPanel({Key? key}) : super(key: key);

  @override
  State<StanceSelectionPanel> createState() => _StanceSelectionPanelState();
}

class _StanceSelectionPanelState extends State<StanceSelectionPanel> {
  @override
  Widget build(BuildContext context) {
    return BottomSheetPanel(
      child: Column(
        children: PuttingStance.values
            .map((puttingStance) =>
                StanceSelectionRow(puttingStance: puttingStance))
            .toList(),
      ),
    );
  }
}

class StanceSelectionRow extends StatelessWidget {
  const StanceSelectionRow({Key? key, required this.puttingStance})
      : super(key: key);

  final PuttingStance puttingStance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          StanceIcon(puttingStance: puttingStance),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class StanceIcon extends StatelessWidget {
  const StanceIcon({Key? key, required this.puttingStance}) : super(key: key);

  final PuttingStance puttingStance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration:
          BoxDecoration(color: MyPuttColors.gray[100], shape: BoxShape.circle),
      child: const Center(
        child: Icon(FlutterRemix.user_location_line),
      ),
    );
  }
}
