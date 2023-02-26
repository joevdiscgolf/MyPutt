import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/utils/colors.dart';

class SessionsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SessionsScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Center(
        child: Text(
          'Sessions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                color: MyPuttColors.blue,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
