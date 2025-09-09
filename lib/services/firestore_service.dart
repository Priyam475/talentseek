import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/certificate.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> hasUserProfile(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.exists;
  }

  // Helper to update a sub-collection for a user
  Future<void> _updateSubCollection<T>({
    required WriteBatch batch,
    required DocumentReference userDocRef,
    required String collectionName,
    required List<T> items,
    required Map<String, dynamic> Function(T) toMap,
  }) async {
    final subCollectionRef = userDocRef.collection(collectionName);
    
    // Get existing documents in the sub-collection to delete them
    // This read operation happens before the batch is committed.
    final snapshot = await subCollectionRef.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    // Add new items to the sub-collection
    for (var item in items) {
      batch.set(subCollectionRef.doc(), toMap(item));
    }
  }

  Future<void> saveFullPortfolio({
    required UserProfile userProfile,
    required List<Skill> skills,
    required List<Project> projects,
    required List<Education> education,
    required List<Experience> experience,
    required List<Certificate> certificates,
  }) async {
    final userRef = _db.collection('users').doc(userProfile.uid);
    final batch = _db.batch();

    // Save user profile directly to the user's document
    batch.set(userRef, userProfile.toMap());

    // Update sub-collections
    await _updateSubCollection(
      batch: batch,
      userDocRef: userRef,
      collectionName: 'skills',
      items: skills,
      toMap: (item) => (item as Skill).toMap(),
    );
    await _updateSubCollection(
      batch: batch,
      userDocRef: userRef,
      collectionName: 'projects',
      items: projects,
      toMap: (item) => (item as Project).toMap(),
    );
    await _updateSubCollection(
      batch: batch,
      userDocRef: userRef,
      collectionName: 'education',
      items: education,
      toMap: (item) => (item as Education).toMap(),
    );
    await _updateSubCollection(
      batch: batch,
      userDocRef: userRef,
      collectionName: 'experience',
      items: experience,
      toMap: (item) => (item as Experience).toMap(),
    );
    await _updateSubCollection(
      batch: batch,
      userDocRef: userRef,
      collectionName: 'certificates',
      items: certificates,
      toMap: (item) => (item as Certificate).toMap(),
    );

    await batch.commit();
  }

  Future<Map<String, dynamic>?> getFullPortfolio(String userId) async {
    final userRef = _db.collection('users').doc(userId);
    final userDoc = await userRef.get();

    if (!userDoc.exists) return null;

    // Helper to fetch all documents from a specific sub-collection
    Future<List<Map<String, dynamic>>> fetchSubCollectionData(String collectionName) async {
      final snapshot = await userRef.collection(collectionName).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    }

    // Fetch data from all sub-collections concurrently
    final results = await Future.wait([
      fetchSubCollectionData('skills'),
      fetchSubCollectionData('projects'),
      fetchSubCollectionData('education'),
      fetchSubCollectionData('experience'),
      fetchSubCollectionData('certificates'),
    ]);

    return {
      'profile': userDoc.data(),
      'skills': results[0],
      'projects': results[1],
      'education': results[2],
      'experience': results[3],
      'certificates': results[4],
    };
  }

  Future<List<UserProfile>> getPublicProfiles() async {
    try {
      final snapshot = await _db.collection('users').limit(20).get();
      return snapshot.docs
          .map((doc) => UserProfile.fromMap(doc.data()!, doc.id))
          .toList();
    } catch (e) {
      // It's good practice to log the error or handle it more gracefully
      print("Error fetching public profiles: $e");
      return []; // Return an empty list on error
    }
  }
}
