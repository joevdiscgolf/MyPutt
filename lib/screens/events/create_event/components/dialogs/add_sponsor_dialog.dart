import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/screens/auth/components/custom_field.dart';
import 'package:myputt/utils/colors.dart';

class AddSponsorDialog extends StatefulWidget {
  const AddSponsorDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AddSponsorDialogState createState() => _AddSponsorDialogState();
}

class _AddSponsorDialogState extends State<AddSponsorDialog> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final TextEditingController _sponsorNameController = TextEditingController();
  final TextEditingController _sponsorUrlController = TextEditingController();

  String? _dialogErrorText;

  @override
  void dispose() {
    _sponsorUrlController.dispose();
    _sponsorUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
            padding:
                const EdgeInsets.only(top: 24, bottom: 16, left: 24, right: 24),
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
          AutoSizeText(
            'Add sponsor',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 32),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          CustomField(
            controller: _sponsorNameController,
            hint: 'Name',
            iconData: FlutterRemix.user_line,
            onChanged: () {},
          ),
          const SizedBox(height: 16),
          CustomField(
            controller: _sponsorUrlController,
            hint: 'Website (optional)',
            iconData: FlutterRemix.global_line,
            onChanged: () {},
          ),
          // AutoSizeText(
          //   'Add presenting sponsors to your event',
          //   style: Theme.of(context)
          //       .textTheme
          //       .headline6
          //       ?.copyWith(color: MyPuttColors.gray[400], fontSize: 16),
          //   textAlign: TextAlign.center,
          // ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 24,
            child: Text(
              _dialogErrorText ?? '',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: MyPuttColors.red,
                  ),
            ),
          ),
          _imageFile == null
              ? MyPuttButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                  title: 'Image',
                  textSize: 18,
                  height: 40,
                  width: double.infinity,
                  iconData: FlutterRemix.camera_3_fill,
                  iconColor: MyPuttColors.blue,
                  borderColor: MyPuttColors.blue,
                  color: MyPuttColors.white,
                  textColor: MyPuttColors.blue,
                  shadowColor: MyPuttColors.gray[300]!,
                  onPressed: () => _imagePickerPressed(),
                )
              : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: MyPuttColors.blue)),
                  child: Row(
                    children: [
                      Expanded(child: Text(_imageFile!.name)),
                    ],
                  ),
                ),
          const SizedBox(height: 32),
          MyPuttButton(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            title: 'Add',
            textSize: 18,
            height: 40,
            borderColor: MyPuttColors.blue,
            color: MyPuttColors.white,
            textColor: MyPuttColors.blue,
            shadowColor: MyPuttColors.gray[300]!,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          MyPuttButton(
              width: 100,
              height: 40,
              title: 'Cancel',
              textSize: 12,
              textColor: Colors.grey[600]!,
              color: Colors.transparent,
              onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Future<void> _imagePickerPressed() async {
    if (_imageFile != null) {
      return;
    }
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (_imageFile == null) {
      return;
    }
    print('not null');
    setState(() => _imageFile = img);
  }
}
