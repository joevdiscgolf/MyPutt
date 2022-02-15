const completedSessionsCollection = 'CompletedSessions';
const sessionsCollection = 'Sessions';
const challengesCollection = 'Challenges';
const usersCollection = 'Users';

class ChallengeStatus {
  static String pending = 'pending';
  static String active = 'active';
  static String complete = 'complete';
}

enum ChallengeCategory { pending, active, complete, none }

enum LoginState { loggedIn, setup, none }
