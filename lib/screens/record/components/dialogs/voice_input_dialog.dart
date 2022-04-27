import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VoiceInputDialog extends StatefulWidget {
  const VoiceInputDialog({Key? key, required this.onNumberDetected})
      : super(key: key);

  final Function onNumberDetected;

  @override
  State<VoiceInputDialog> createState() => _VoiceInputDialogState();
}

class _VoiceInputDialogState extends State<VoiceInputDialog> {
  final SpeechToText _speechToText = SpeechToText();
  bool _listening = false;
  String speechRecognitionText = '';
  int? detectedNumber;

  @override
  void dispose() {
    _speechToText.stop();
    _speechToText.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _onVoiceListen();
    super.initState();
  }

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  'Input result',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: MyPuttColors.darkGray, fontSize: 32),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: speechRecognitionText.isEmpty
                          ? const SpinKitWave(
                              color: MyPuttColors.blue,
                              duration: Duration(seconds: 2),
                            )
                          : Text(
                              speechRecognitionText,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                      color: MyPuttColors.darkGray,
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold),
                            ),
                    )),
                const SizedBox(height: 16),
                Bounceable(
                  onTap: () => _onVoiceListen(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _listening
                            ? MyPuttColors.skyBlue
                            : MyPuttColors.gray[100]),
                    child: const Icon(
                      FlutterRemix.mic_line,
                      color: MyPuttColors.darkGray,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                MyPuttButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                  title: '',
                  textSize: 18,
                  height: 40,
                  borderColor: MyPuttColors.blue,
                  color: MyPuttColors.white,
                  iconData: FlutterRemix.check_line,
                  iconColor: MyPuttColors.darkGray,
                  shadowColor: MyPuttColors.gray[300]!,
                  onPressed: () {
                    if (detectedNumber != null) {
                      widget.onNumberDetected(detectedNumber!);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                MyPuttButton(
                  width: 100,
                  height: 40,
                  title: '',
                  textSize: 12,
                  textColor: Colors.grey[600]!,
                  color: Colors.transparent,
                  onPressed: () {
                    if (detectedNumber != null) {
                      widget.onNumberDetected(detectedNumber!);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            )));
  }

  Future<void> _onVoiceListen() async {
    if (_listening) {
      _speechToText.stop();
      setState(() {
        _listening = false;
      });
      return;
    }
    final bool _speechEnabled = await _speechToText.initialize();
    if (!_speechEnabled) {
      return;
    }
    _speechToText.listen(onResult: (SpeechRecognitionResult result) async {
      if (!mounted) {
        return;
      }
      final double? inputNumber =
          double.tryParse(result.recognizedWords.split(' ')[0].toLowerCase());
      if (inputNumber != null) {
        Vibrate.feedback(FeedbackType.light);
        setState(() {
          _listening = false;
          speechRecognitionText = result.recognizedWords;
        });
        speechRecognitionText = '';
        _speechToText.stop();
        widget.onNumberDetected(inputNumber.toInt());
        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 200), () {
            Navigator.of(context).pop();
          });
        }
      } else if (kWordToNumber[result.recognizedWords.toLowerCase()] != null) {
        Vibrate.feedback(FeedbackType.light);
        setState(() {
          _listening = false;
          speechRecognitionText =
              kWordToNumber[result.recognizedWords.toLowerCase()]!.toString();
        });
        speechRecognitionText = '';
        _speechToText.stop();
        widget.onNumberDetected(
            kWordToNumber[result.recognizedWords.toLowerCase()]!);
        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 200), () {
            Navigator.of(context).pop();
          });
        }
      }
    });
    await Future.delayed(const Duration(milliseconds: 500),
        () => setState(() => _listening = true));
    await Future.delayed(const Duration(seconds: 4), () {
      _speechToText.stop();
      setState(() {
        _listening = false;
        speechRecognitionText = '';
      });
    });
  }
}
