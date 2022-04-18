import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognitionService {
  final SpeechToText _speechToText = SpeechToText();
  bool initialized = false;

  Future<bool> init() async {
    initialized = await _speechToText.initialize();
    return initialized;
  }

  void startListening() async {
    await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) =>
            print(result.finalResult));
  }

  void stopListening() async {
    await _speechToText.stop();
  }
}
