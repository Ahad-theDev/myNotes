import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';

class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });
  CloudNote.fromSnapShot(QueryDocumentSnapshot<Map<String, dynamic>> snapShot)
    : documentId = snapShot.id,
      ownerUserId = snapShot.data()[ownerUserIdFieldName],
      text = snapShot.data()[textFieldName];
}
