import 'dart:async';
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/toast/toast_data.dart';
import 'package:myputt/services/toast/toast_service.dart';

class ToastLayer extends StatefulWidget {
  const ToastLayer({Key? key}) : super(key: key);

  @override
  State<ToastLayer> createState() => _ToastLayerState();
}

class _ToastLayerState extends State<ToastLayer> {
  final ToastService _toastService = locator.get<ToastService>();

  late final StreamSubscription<ToastData> _toastDataSubscription;
  GlobalKey? _toastKey;

  void _dismissToast() {
    try {
      (_toastKey?.currentWidget as Flushbar?)?.dismiss();
    } catch (_) {
      return;
    }
  }

  @override
  void dispose() {
    _toastDataSubscription.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _toastDataSubscription =
        _toastService.toastDataStream.listen((ToastData toastData) {
      _handleToastData(toastData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  void _handleToastData(ToastData toastData) {
    _dismissToast();
    setState(() {
      _toastKey = GlobalKey();
    });

    final Flushbar toast = _toastService.getGenericToast(
      context,
      toastData.metadata,
      onTap: _dismissToast,
      key: _toastKey,
    );

    try {
      toast.show(context);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      return;
    }
  }
}
