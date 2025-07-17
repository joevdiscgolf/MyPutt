// AI Configuration
// 
// To use the AI Coach feature, you need to obtain a Gemini API key:
// 1. Go to https://makersuite.google.com/app/apikey
// 2. Create a new API key
// 3. Add the key to your environment variables or secure storage
//
// For development:
// - Add to your run configuration: --dart-define=GEMINI_API_KEY=your_api_key_here
// 
// For production:
// - Store the API key securely (e.g., in environment variables, CI/CD secrets)
// - Never commit API keys to version control

class AIConfig {
  // The API key is loaded from environment variables at runtime
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  
  // Model configuration
  static const String defaultModel = 'gemini-1.5-flash';
  static const double temperature = 0.7;
  static const int maxOutputTokens = 2048;
  
  // Training session defaults
  static const int defaultSessionDurationMinutes = 30;
  static const int minSessionDurationMinutes = 15;
  static const int maxSessionDurationMinutes = 60;
  
  // Rate limiting
  static const int maxRequestsPerMinute = 10;
  static const Duration requestCooldown = Duration(seconds: 6);
}