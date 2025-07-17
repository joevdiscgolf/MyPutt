import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter/services.dart';
import 'package:myputt/components/buttons/exit_button.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/models/data/challenges/generated_challenge_item.dart';
import 'package:myputt/components/custom_fields/custom_text_fields.dart';
import 'package:myputt/screens/challenge/components/dialogs/components/structure_description_row.dart';
import 'package:myputt/utils/colors.dart';

class CreateChallengeStructurePanel extends StatefulWidget {
  const CreateChallengeStructurePanel({
    Key? key,
    required this.initialInstructions,
    required this.updateInstructions,
  }) : super(key: key);

  final List<GeneratedChallengeInstruction> initialInstructions;
  final Function(List<GeneratedChallengeInstruction> instructions)
      updateInstructions;

  @override
  State<CreateChallengeStructurePanel> createState() =>
      _CreateChallengeStructurePanelState();
}

class _CreateChallengeStructurePanelState
    extends State<CreateChallengeStructurePanel> {
  late final List<GeneratedChallengeInstruction> _challengeInstructions;

  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _setLengthController = TextEditingController();
  final TextEditingController _setCountController = TextEditingController();

  String? _errorText;

  @override
  void initState() {
    _challengeInstructions = widget.initialInstructions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
          bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 32 : 24,
        ),
        child: Stack(
          children: [
            NestedScrollView(
                headerSliverBuilder: (BuildContext context, _) => [
                      SliverAppBar(
                        actions: const [ExitButton()],
                        pinned: true,
                        floating: true,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        title: Text(
                          'Enter layout',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: MyPuttColors.darkGray,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        toolbarHeight: 80,
                        bottom: _appBarBottom(context),
                      )
                    ],
                body: _mainBody(context)),
            Align(
              alignment: Alignment.bottomCenter,
              child: PrimaryButton(
                width: double.infinity,
                label: 'Done',
                icon: FlutterRemix.check_line,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBarBottom(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _descriptionRow(context),
            _inputRow(context),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _addButton(context)),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _undo();
                  },
                  icon: const Icon(FlutterRemix.arrow_go_back_line),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 30,
              child: _errorText == null
                  ? null
                  : Text(
                      _errorText!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: MyPuttColors.red),
                    ),
            ),
          ],
        ));
  }

  Widget _mainBody(BuildContext context) {
    return Column(
      children: _challengeInstructions
          .map(
            (instruction) => StructureDescriptionRow(
                generatedChallengeInstruction: instruction),
          )
          .toList(),
    );
  }

  Widget _descriptionRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Feet',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyPuttColors.darkGray),
          ),
        ),
        Expanded(
          child: Text(
            'Attempts',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyPuttColors.darkGray),
          ),
        ),
        Expanded(
          child: Text(
            'Sets',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyPuttColors.darkGray),
          ),
        ),
      ],
    );
  }

  Widget _addButton(BuildContext context) {
    return MyPuttButton(
      title: 'Add',
      onPressed: () {
        final int? dist = int.tryParse(_distanceController.text);
        final int? setLength = int.tryParse(_setLengthController.text);
        final int? setCount = int.tryParse(_setCountController.text);

        if (dist == null || setLength == null || setCount == null) {
          setState(() => _errorText = 'Enter all fields');
          return;
        }
        setState(
          () => _challengeInstructions.add(
            GeneratedChallengeInstruction(
              distance: dist,
              setCount: setCount,
              setLength: setLength,
            ),
          ),
        );
        widget.updateInstructions(_challengeInstructions);
      },
      iconData: FlutterRemix.add_line,
    );
  }

  Widget _inputRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomField(
            controller: _distanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            innerPadding:
                const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 20),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomField(
            controller: _setLengthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            innerPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomField(
            controller: _setCountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            innerPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          ),
        ),
      ],
    );
  }

  void _undo() {
    if (_challengeInstructions.isEmpty) {
      return;
    }
    setState(() => _challengeInstructions.removeLast());
    widget.updateInstructions(_challengeInstructions);
  }
}
