import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/screens/share/share_sheet.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/panel_helpers.dart';

import 'components/preset_list_item.dart';

class SelectPresetDialog extends StatefulWidget {
  const SelectPresetDialog({Key? key}) : super(key: key);

  @override
  State<SelectPresetDialog> createState() => _SelectPresetDialogState();
}

class _SelectPresetDialogState extends State<SelectPresetDialog> {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();

  final PresetsRepository _presetsRepository = locator.get<PresetsRepository>();
  ChallengePreset _selectedPreset = ChallengePreset.none;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        child: _mainBody(context),
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Presets',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 32, color: MyPuttColors.darkGray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Select one before continuing',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 16, color: MyPuttColors.gray[400]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Flexible(
            fit: FlexFit.loose,
            child: ListView(
              children: _presetsRepository.presetStructures.entries
                  .map(
                    (entry) => PresetListItem(
                      onTap: (ChallengePreset preset) {
                        _mixpanel.track('Select Preset Dialog Preset Pressed',
                            properties: {
                              'Preset Name': preset.name,
                            });
                        setState(() {
                          if (_selectedPreset == preset) {
                            _selectedPreset = ChallengePreset.none;
                          } else {
                            _selectedPreset = preset;
                          }
                        });
                      },
                      presetType: entry.key,
                      presetInstructions:
                          _presetsRepository.presetInstructions[entry.key]!,
                      selected: _selectedPreset == entry.key,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          MyPuttButton(
            title: 'Share',
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
            textSize: 18,
            textColor: MyPuttColors.blue,
            height: 48,
            backgroundColor: MyPuttColors.white,
            borderColor: MyPuttColors.blue,
            onPressed: () {
              HapticFeedback.lightImpact();
              _mixpanel.track('Select Preset Dialog Share Button Pressed');
              if (_selectedPreset != ChallengePreset.none) {
                displayBottomSheet(
                    context,
                    ShareSheet(
                      preset: _selectedPreset,
                      onComplete: () {
                        Navigator.pop(context);
                      },
                    ),
                    onDismiss: () => Navigator.pop(context));
              }
            },
            disabled: _selectedPreset == ChallengePreset.none,
          ),
          const SizedBox(height: 8),
          MyPuttButton(
              width: 100,
              height: 50,
              title: 'Cancel',
              textSize: 18,
              textColor: Colors.grey[400]!,
              backgroundColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
