import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/data/types/users/frisbee_avatar.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/screens/my_profile/components/color_marker.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class EditProfileFrisbeePanel extends StatefulWidget {
  const EditProfileFrisbeePanel(
      {Key? key,
      required this.initialBackgroundColor,
      this.initialFrisbeeIconColor})
      : super(key: key);

  final Color initialBackgroundColor;
  final FrisbeeIconColor? initialFrisbeeIconColor;

  @override
  State<EditProfileFrisbeePanel> createState() =>
      _EditProfileFrisbeePanelState();
}

class _EditProfileFrisbeePanelState extends State<EditProfileFrisbeePanel> {
  final UserRepository _userRepository = locator.get<UserRepository>();

  late String _selectedBackgroundColorHex;
  late Color _selectedBackgroundColor;
  late FrisbeeIconColor _frisbeeIconColor;

  @override
  void initState() {
    _selectedBackgroundColor = widget.initialBackgroundColor;
    _selectedBackgroundColorHex =
        myPuttColorToHex[_selectedBackgroundColor] ?? '2196F3';
    _frisbeeIconColor = widget.initialFrisbeeIconColor ?? FrisbeeIconColor.blue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetPanel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Edit icon',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontSize: 32, color: MyPuttColors.gray[800]!),
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      Container(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FrisbeeCircleIcon(
              frisbeeAvatar: FrisbeeAvatar(
                  backgroundColorHex: _selectedBackgroundColorHex,
                  frisbeeIconColor: _frisbeeIconColor),
              iconSize: 64,
              size: 100,
            ),
            const SizedBox(
              width: 16,
            ),
            _colorPickers(context),
          ],
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: MyPuttButton(
            title: 'Done',
            iconColor: MyPuttColors.white,
            iconData: FlutterRemix.check_line,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            onPressed: () {
              _userRepository.currentUser?.frisbeeAvatar = FrisbeeAvatar(
                  backgroundColorHex: _selectedBackgroundColorHex.toString(),
                  frisbeeIconColor: _frisbeeIconColor);
              _userRepository.updateUserAvatar(FrisbeeAvatar(
                  backgroundColorHex: _selectedBackgroundColorHex,
                  frisbeeIconColor: _frisbeeIconColor));
              BlocProvider.of<MyProfileCubit>(context).reload();
              Navigator.pop(context);
            }),
      )
    ]));
  }

  Widget _colorPickers(BuildContext context) {
    return FittedBox(
      child: Column(
        children: [
          Row(
              children: frisbeeIconColorToSrc.entries
                  .map((entry) => ColorMarker(
                      onTap: () =>
                          setState(() => _frisbeeIconColor = entry.key),
                      isSelected: _frisbeeIconColor == entry.key,
                      size: 24,
                      color: frisbeeIconColorToColor[entry.key] ??
                          MyPuttColors.blue))
                  .toList()),
          const SizedBox(
            width: 16,
          ),
          Row(
              children: backgroundAvatarColors
                  .map(
                    (Color color) => ColorMarker(
                        isSelected: _selectedBackgroundColorHex ==
                            (myPuttColorToHex[color] ?? '2196F3'),
                        size: 24,
                        color: color,
                        margin: const EdgeInsets.all(4),
                        onTap: () => setState(() =>
                            _selectedBackgroundColorHex =
                                myPuttColorToHex[color]!)),
                  )
                  .toList())
        ],
      ),
    );
  }
}
