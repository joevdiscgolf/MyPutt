import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/user_service.dart';
import 'package:myputt/utils/colors.dart';

class ConfirmDeleteUserPanel extends StatefulWidget {
  const ConfirmDeleteUserPanel({Key? key}) : super(key: key);

  @override
  State<ConfirmDeleteUserPanel> createState() => _ConfirmDeleteUserPanelState();
}

class _ConfirmDeleteUserPanelState extends State<ConfirmDeleteUserPanel> {
  final UserService _userService = locator.get<UserService>();
  final UserRepository _userRepository = locator.get<UserRepository>();

  ButtonState _buttonState = ButtonState.normal;

  @override
  Widget build(BuildContext context) {
    return BottomSheetPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delete account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  color: MyPuttColors.darkGray,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'All data including your sessions and challenges will be removed from our records.',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16,
                  color: MyPuttColors.gray[400],
                ),
          ),
          const SizedBox(height: 32),
          MyPuttButton(
            buttonState: _buttonState,
            width: double.infinity,
            title: 'Delete',
            backgroundColor: MyPuttColors.red,
            iconData: FlutterRemix.delete_bin_line,
            onPressed: () {
              switch (_buttonState) {
                case ButtonState.normal:
                  _attemptDelete();
                  break;
                case ButtonState.retry:
                  _attemptDelete();
                  break;
                case ButtonState.loading:
                  break;
                case ButtonState.success:
                  break;
              }
              if (_buttonState == ButtonState.normal) {}
            },
          )
        ],
      ),
    );
  }

  Future<void> _attemptDelete() async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      setState(() {
        _buttonState = ButtonState.retry;
      });
      return;
    }
    setState(() {
      _buttonState = ButtonState.loading;
    });
    final bool deleteSuccess = await _userService.deleteUser(currentUser);
    setState(() {
      _buttonState = deleteSuccess ? ButtonState.success : ButtonState.retry;
    });
    if (deleteSuccess) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) {
        return;
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
