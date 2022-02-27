import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class SubmitTextDialog extends StatefulWidget {
  const SubmitTextDialog(
      {Key? key, required this.onSubmit, required this.title})
      : super(key: key);

  final String title;
  final Function onSubmit;

  @override
  _SubmitTextDialogState createState() => _SubmitTextDialogState();
}

class _SubmitTextDialogState extends State<SubmitTextDialog> {
  final TextEditingController _pdgaNumFieldController = TextEditingController();
  bool _loading = false;
  String _pdgaNum = '';
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
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          _pdgaNumField(context),
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
                  label: 'Submit',
                  fontSize: 18,
                  loading: _loading,
                  width: 100,
                  height: 50,
                  backgroundColor: ThemeColors.green,
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    if (await widget.onSubmit(_pdgaNum)) {
                      Navigator.pop(context);
                    }
                    setState(() {
                      _loading = false;
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pdgaNumField(BuildContext context) {
    return TextFormField(
      controller: _pdgaNumFieldController,
      autocorrect: false,
      maxLines: 1,
      maxLength: 24,
      style: Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter PDGA number',
        contentPadding:
            const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
        isDense: true,
        hintStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: TWUIColors.gray[400], fontSize: 18),
        enabledBorder: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.border,
        prefixIcon: const Icon(
          FlutterRemix.edit_line,
          color: TWUIColors.gray,
          size: 22,
        ),
        counter: const Offstage(),
      ),
      onChanged: (String text) async {
        setState(() {
          _pdgaNum = text;
        });
      },
    );
  }
}
