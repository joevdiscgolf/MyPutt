import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<String?> getMinimumAppVersion() async {
  DocumentSnapshot<dynamic> snapshot = await FirebaseFirestore.instance
      .doc('$appInfoCollection/$minimumVersionDoc')
      .get();

  if (snapshot.exists && snapshot.data()['minimumVersion'] != null) {
    return snapshot.data()['minimumVersion'];
  } else {
    return null;
  }
}
