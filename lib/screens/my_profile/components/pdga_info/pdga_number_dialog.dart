import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/shadow_icon.dart';
import 'package:myputt/utils/colors.dart';

class PdgaNumberDialog extends StatefulWidget {
  const PdgaNumberDialog({Key? key, required this.onSubmit}) : super(key: key);

  final Function onSubmit;

  @override
  _PdgaNumberDialogState createState() => _PdgaNumberDialogState();
}

class _PdgaNumberDialogState extends State<PdgaNumberDialog> {
  final TextEditingController _pdgaNumFieldController = TextEditingController();
  bool _loading = false;
  String _pdgaNum = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              child: _mainBody(context))),
    );
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
          AutoSizeText(
            'Enter PDGA number',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 32),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          const ShadowIcon(
            icon: Icon(
              FlutterRemix.user_3_fill,
              size: 80,
              color: MyPuttColors.blue,
            ),
          ),
          const SizedBox(height: 16),
          _pdgaNumField(context),
          const SizedBox(height: 16),
          MyPuttButton(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            title: 'Submit',
            textSize: 18,
            height: 40,
            borderColor: MyPuttColors.blue,
            color: MyPuttColors.white,
            textColor: MyPuttColors.blue,
            shadowColor: MyPuttColors.gray[300]!,
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
            buttonState: _loading ? ButtonState.loading : ButtonState.normal,
          ),
          MyPuttButton(
              width: 100,
              height: 40,
              title: 'Cancel',
              textSize: 12,
              textColor: Colors.grey[600]!,
              color: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              }),
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
        hintText: 'PDGA number',
        contentPadding:
            const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
        isDense: true,
        hintStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: MyPuttColors.gray[300], fontSize: 18),
        enabledBorder: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.border,
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
