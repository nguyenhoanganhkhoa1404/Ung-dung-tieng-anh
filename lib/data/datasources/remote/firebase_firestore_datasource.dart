import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseFirestoreDataSource {
  Future<DocumentSnapshot> getDocument(String collection, String docId);
  Future<QuerySnapshot> getCollection(String collection);
  Future<QuerySnapshot> queryCollection(String collection, {
    String? field,
    dynamic isEqualTo,
    dynamic isGreaterThan,
    dynamic isLessThan,
    int? limit,
  });
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data);
  Future<String> addDocument(String collection, Map<String, dynamic> data);
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data);
  Future<void> deleteDocument(String collection, String docId);
}

class FirebaseFirestoreDataSourceImpl implements FirebaseFirestoreDataSource {
  final FirebaseFirestore _firestore;
  
  FirebaseFirestoreDataSourceImpl(this._firestore);
  
  @override
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    return await _firestore.collection(collection).doc(docId).get();
  }
  
  @override
  Future<QuerySnapshot> getCollection(String collection) async {
    return await _firestore.collection(collection).get();
  }
  
  @override
  Future<QuerySnapshot> queryCollection(
    String collection, {
    String? field,
    dynamic isEqualTo,
    dynamic isGreaterThan,
    dynamic isLessThan,
    int? limit,
  }) async {
    Query query = _firestore.collection(collection);
    
    if (field != null) {
      if (isEqualTo != null) {
        query = query.where(field, isEqualTo: isEqualTo);
      }
      if (isGreaterThan != null) {
        query = query.where(field, isGreaterThan: isGreaterThan);
      }
      if (isLessThan != null) {
        query = query.where(field, isLessThan: isLessThan);
      }
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return await query.get();
  }
  
  @override
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(docId).set(data);
  }
  
  @override
  Future<String> addDocument(String collection, Map<String, dynamic> data) async {
    final docRef = await _firestore.collection(collection).add(data);
    return docRef.id;
  }
  
  @override
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }
  
  @override
  Future<void> deleteDocument(String collection, String docId) async {
    await _firestore.collection(collection).doc(docId).delete();
  }
}

