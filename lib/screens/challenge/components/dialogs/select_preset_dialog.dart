import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/screens/challenge/components/dialogs/preset_structure_row.dart';
import 'package:myputt/theme/theme_data.dart';
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
                  backgroundColor: ThemeColors.green,
                  onPressed: () {
                    BlocProvider.of<ChallengesCubit>(context)
                        .getShareMessageFromPreset(_selectedPreset);
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
