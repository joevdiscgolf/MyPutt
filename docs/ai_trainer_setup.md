# AI Putting Trainer Setup Guide

## Overview
The AI Putting Trainer feature uses Google's Gemini AI to analyze your putting history and create personalized training sessions with specific goals and real-time coaching feedback.

## Setup Instructions

### 1. Obtain a Gemini API Key
1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated API key

### 2. Configure the API Key

#### For Development:
Add the API key to your Flutter run configuration:
```bash
flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```

Or in VS Code, add to `.vscode/launch.json`:
```json
{
  "configurations": [
    {
      "name": "myputt",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=GEMINI_API_KEY=your_api_key_here"]
    }
  ]
}
```

#### For Production:
- Store the API key in your CI/CD environment variables
- Use a secure key management service
- Never commit API keys to version control

### 3. Running the App
Once configured, the AI Coach feature will be available in the bottom navigation bar.

## Feature Components

### Models
- `TrainingSessionInstructions` - AI-generated training plans
- `TrainingSession` - Active training session tracking
- `TrainingGoal` - Specific measurable goals
- `CoachingFeedback` - Real-time AI feedback

### Services
- `AICoachService` - Abstract interface for AI providers
- `GeminiAICoachService` - Gemini implementation
- `TrainingCubit` - State management for training sessions

### Screens
- `AICoachScreen` - Main screen with stats and session options
- `TrainingSessionScreen` - Active training session UI

## Usage

1. **Navigate to AI Coach**: Tap the robot icon in the bottom navigation
2. **Start AI Training**: Choose difficulty level (Beginner/Intermediate/Advanced/Expert)
3. **Follow the Session**: Complete putts at specified distances
4. **Track Goals**: Monitor progress on 3 session-specific goals
5. **Get Feedback**: Receive real-time coaching based on performance

## API Key Security

⚠️ **Important Security Notes:**
- Never hardcode API keys in your source code
- Add `*.env` and API key files to `.gitignore`
- Rotate keys regularly
- Monitor usage in Google Cloud Console
- Set up usage limits and alerts

## Troubleshooting

### No API Key Error
If you see "No response from Gemini", ensure:
1. API key is properly set in environment
2. Key has proper permissions
3. You have internet connectivity

### Rate Limiting
The service includes built-in rate limiting:
- Max 10 requests per minute
- 6-second cooldown between requests

### Fallback Behavior
If AI service fails, the app provides:
- Pre-configured training sessions
- Basic progress tracking
- Simple encouragement messages