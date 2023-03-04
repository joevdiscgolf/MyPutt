import 'package:flutter/material.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/distance_selection_tile.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/stance_selection_tile.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/wind_direction_tile.dart';

class SelectionTilesRow extends StatelessWidget {
  const SelectionTilesRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Expanded(child: DistanceSelectionTile()),
          SizedBox(width: 12),
          Expanded(child: StanceSelectionTile()),
          SizedBox(width: 12),
          Expanded(child: WindDirectionTile()),
        ],
      ),
    );
  }
}
