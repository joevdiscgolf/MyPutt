import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool?> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key);
  }
  
  Future<void> setStringValue(String key, String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(key, value);
  }
  
  Future<String?> getStringValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(key);
  }

  Future<void> markUserIsSetUp(bool isSetUp) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool('userIsSetUp', isSetUp);
  }

  Future<bool?> userIsSetUp() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool('userIsSetUp');
  }
  
  Future<void> setGeminiModel(String modelName) async {
    await setStringValue('gemini_model', modelName);
  }
  
  Future<String?> getGeminiModel() async {
    return await getStringValue('gemini_model');
  }
}
