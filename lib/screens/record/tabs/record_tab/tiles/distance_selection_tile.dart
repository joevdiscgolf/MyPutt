import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter/services.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/adjust_distance_button.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/selection_tile.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/helpers.dart';
import 'package:myputt/utils/panel_helpers.dart';

class DistanceSelectionTile extends StatelessWidget {
  const DistanceSelectionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        return Column(
          children: [
            Bounceable(
              onTap: () {
                HapticFeedback.lightImpact();
                displayBottomSheet(
                  context,
                  const DistanceSelectionPanel(),
                );
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Distance',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: MyPuttColors.gray[400],
                          ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(FlutterRemix.pencil_line, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SelectionTile(
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: AdjustDistanceButton(increment: false),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: MyPuttColors.gray[200]!,
                      thickness: 1,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        '${state.distance}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: MyPuttColors.darkGray,
                                ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: MyPuttColors.gray[200]!,
                      thickness: 1,
                    ),
                    const Expanded(
                      child: AdjustDistanceButton(increment: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DistanceSelectionPanel extends StatefulWidget {
  const DistanceSelectionPanel({super.key});

  @override
  State<DistanceSelectionPanel> createState() => _DistanceSelectionPanelState();
}

class _DistanceSelectionPanelState extends State<DistanceSelectionPanel> {
  int? _distanceInput;

  @override
  void initState() {
    _distanceInput =
        tryCast<RecordActive>(BlocProvider.of<RecordCubit>(context).state)
                ?.distance ??
            10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: bottomInsets > 0 ? bottomInsets : 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter distance',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          _inputField(),
          const SizedBox(height: 48),
          _buttonsRow(),
        ],
      ),
    );
  }

  Widget _buttonsRow() {
    return Row(
      children: [
        Expanded(
          child: MyPuttButton(
            height: 56,
            borderRadius: 48,
            title: 'Cancel',
            onPressed: () {
              Navigator.of(context).pop();
            },
            backgroundColor: MyPuttColors.white,
            textColor: MyPuttColors.darkGray,
            fontWeight: FontWeight.w600,
            borderColor: MyPuttColors.gray[400],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MyPuttButton(
            height: 56,
            borderRadius: 48,
            title: 'Submit',
            onPressed: () {
              if (_distanceInput == null) {
                return;
              }
              BlocProvider.of<RecordCubit>(context)
                  .setExactDistance(_distanceInput!);
              Navigator.of(context).pop();
            },
            disabled: _distanceInput == null,
            backgroundColor: MyPuttColors.darkGray,
            textColor: MyPuttColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _inputField() {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(),
      onChanged: (String value) {
        final int? tryInput = int.tryParse(value);

        if (tryInput != null && tryInput <= 100 && tryInput > 0) {
          setState(() {
            _distanceInput = tryInput;
          });
        } else if (_distanceInput != null) {
          setState(() {
            _distanceInput = null;
          });
        }
      },
      initialValue: _distanceInput.toString(),
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(fontWeight: FontWeight.w500),
    );
  }
}
