import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/constants/app_constants.dart';
import 'package:itrip/core/errors/failures.dart';
import 'package:itrip/core/utils/result.dart';

/// Firestore remote datasource for trips and community posts.
class FirestoreTravelDataSource {
  FirestoreTravelDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _trips =>
      _firestore.collection(AppConstants.tripsCollection);

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection(AppConstants.postsCollection);

  Future<Result<List<Map<String, dynamic>>>> getTripsForUser(String userId) async {
    try {
      final snapshot = await _trips
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(AppConstants.paginationLimit)
          .get();
      return Success(snapshot.docs.map((d) => {'id': d.id, ...d.data()}).toList());
    } on FirebaseException catch (e) {
      return Error(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  Future<Result<String>> createTrip(Map<String, dynamic> tripData) async {
    try {
      final doc = await _trips.add({
        ...tripData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return Success(doc.id);
    } on FirebaseException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to create trip'));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getRecentPosts() async {
    try {
      final snapshot = await _posts
          .orderBy('createdAt', descending: true)
          .limit(AppConstants.paginationLimit)
          .get();
      return Success(snapshot.docs.map((d) => {'id': d.id, ...d.data()}).toList());
    } on FirebaseException catch (e) {
      return Error(ServerFailure(e.message ?? 'Firestore error'));
    }
  }
}

final firestoreTravelDataSourceProvider =
    Provider<FirestoreTravelDataSource>((ref) {
  return FirestoreTravelDataSource(FirebaseFirestore.instance);
});
