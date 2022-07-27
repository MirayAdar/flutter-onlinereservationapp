import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignController {
  Future<List<QueryDocumentSnapshot>> getCampaigns() async {
    var docs;
    await FirebaseFirestore.instance
        .collection('campaigns')
        .get()
        .then((value) {
      docs = value.docs;
    });
    return docs;
  }
}
