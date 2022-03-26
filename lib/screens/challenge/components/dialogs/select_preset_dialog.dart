import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/screens/challenge/components/dialogs/components/preset_structure_row.dart';
import 'package:myputt/screens/share/share_sheet.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/enums.dart';

class SelectPresetDialog extends StatefulWidget {
  const SelectPresetDialog({
    Key? key,
  }) : super(key: key);

  @override
  _SelectPresetDialogState createState() => _SelectPresetDialogState();
}

class _SelectPresetDialogState extends State<SelectPresetDialog> {
  final PresetsRepository _presetsRepository = locator.get<PresetsRepository>();
  ChallengePreset _selectedPreset = ChallengePreset.none;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            child: _mainBody(context)));
  }

  Widget _mainBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select preset type',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          ..._presetsRepository.presetStructures.entries
              .map((entry) => PresetStructureRow(
                    onTap: (ChallengePreset preset) {
                      setState(() {
                        _selectedPreset = preset;
                      });
                    },
                    presetType: entry.key,
                    structure: entry.value,
                    selected: _selectedPreset == entry.key,
                  )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryButton(
                    width: 100,
                    height: 50,
                    label: 'Cancel',
                    fontSize: 18,
                    labelColor: Colors.grey[600]!,
                    backgroundColor: Colors.grey[200]!,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                PrimaryButton(
                  disabled: _selectedPreset == ChallengePreset.none,
                  label: 'Share',
                  fontSize: 18,
                  width: 100,
                  height: 50,
                  backgroundColor: MyPuttColors.lightGreen,
                  onPressed: () {
                    Vibrate.feedback(FeedbackType.light);
                    if (_selectedPreset != ChallengePreset.none) {
                      showBarModalBottomSheet(
                          topControl: Container(),
                          bounce: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                          ),
                          context: context,
                          builder: (context) => ShareSheet(
                                preset: _selectedPreset,
                                onComplete: () {
                                  Navigator.pop(context);
                                },
                              )).then((_) => Navigator.pop(context));
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
