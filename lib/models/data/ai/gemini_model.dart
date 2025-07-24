/// Available Gemini models for AI Coach functionality
enum GeminiModel {
  /// Standard Flash model - Balanced performance and quality
  flash('gemini-1.5-flash', 'Balanced Performance', 
    'Good balance of speed and quality for most tasks'),
  
  /// Flash 8B model - Fastest performance
  flash8b('gemini-1.5-flash-8b', 'Fastest Response', 
    'Optimized for speed, best for simple tasks'),
  
  /// Latest Flash model - Latest improvements
  flashLatest('gemini-1.5-flash-latest', 'Latest Flash', 
    'Latest improvements to Flash model'),
  
  /// Experimental 2.0 Flash - Next generation
  flash2Experimental('gemini-2.0-flash-exp-20250115', 'Experimental 2.0', 
    'Next-gen model with enhanced capabilities');

  final String modelName;
  final String displayName;
  final String description;

  const GeminiModel(this.modelName, this.displayName, this.description);

  /// Get model from stored preference string
  static GeminiModel fromString(String? value) {
    if (value == null) return GeminiModel.flash;
    
    return GeminiModel.values.firstWhere(
      (model) => model.modelName == value,
      orElse: () => GeminiModel.flash,
    );
  }

  /// Get optimal generation config for each model
  Map<String, dynamic> get generationConfig {
    switch (this) {
      case GeminiModel.flash8b:
        // Ultra-fast settings for 8B model
        return {
          'temperature': 0.2,
          'topK': 10,
          'topP': 0.7,
          'maxOutputTokens': 512,
        };
      case GeminiModel.flash2Experimental:
        // Balanced settings for experimental model
        return {
          'temperature': 0.4,
          'topK': 30,
          'topP': 0.85,
          'maxOutputTokens': 1024,
        };
      case GeminiModel.flash:
      case GeminiModel.flashLatest:
      default:
        // Standard optimized settings
        return {
          'temperature': 0.3,
          'topK': 20,
          'topP': 0.8,
          'maxOutputTokens': 1024,
        };
    }
  }
}