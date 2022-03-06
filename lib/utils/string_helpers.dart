import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';

int versionToNumber(String version) {
  final withoutDots = version.replaceAll(RegExp('\\.'), ''); // abc
  return int.parse(withoutDots);
}

List<String> getPrefixes(String str) {
  final String lowerCase = str.toLowerCase();
  final List<String> result = <String>[];

  if (lowerCase.isEmpty) {
    return result;
  }

  for (int i = 1; i <= lowerCase.length; i++) {
    result.add(lowerCase.substring(0, i));
  }
  return result;
}

String generateChallengeId(String uid) {
  return '$uid~${DateTime.now().millisecondsSinceEpoch}';
}

String? getSharedChallengeDocId(StoragePuttingChallenge storageChallenge) {
  if (storageChallenge.recipientUser?.uid == null) {
    return null;
  }
  List<String> uidList = [
    storageChallenge.recipientUser!.uid,
    storageChallenge.challengerUser.uid
  ];
  uidList.sort();
  return '${uidList[0]}~${uidList[1]}';
}
