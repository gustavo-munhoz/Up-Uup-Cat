//
//  FirestoreService.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 29/04/24.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveSettings(data: AppSettings, for documentId: String, completion: @escaping (Bool) -> Void) {
        db.collection("upuupcat_database").document(documentId).setData(data.dictionary) { error in
            completion(error == nil)
        }
    }
    
    func loadSettings(for documentId: String, completion: @escaping (AppSettings?) -> Void) {
        db.collection("upuupcat_database").document(documentId).getDocument { (document, error) in
            guard let document = document, document.exists, let data = document.data() else {
                completion(nil)
                return
            }
            completion(AppSettings(dictionary: data))
        }
    }
    
    func save<T: FirestoreSerializable>(data: T, collection: String, documentId: String? = nil, completion: @escaping (Bool) -> Void) {
        let docId = documentId ?? Auth.auth().currentUser?.uid ?? UUID().uuidString
        db.collection(collection).document(docId).setData(data.dictionary) { error in
            completion(error == nil)
        }
    }
    
    func load<T: FirestoreSerializable>(collection: String, documentId: String, completion: @escaping (T?) -> Void) {
        db.collection(collection).document(documentId).getDocument { (document, error) in
            guard let document = document, document.exists, let data = document.data() else {
                completion(nil)
                return
            }
            completion(T(dictionary: data))
        }
    }
    
    func delete(collection: String, documentId: String, completion: @escaping (Bool) -> Void) {
        db.collection(collection).document(documentId).delete { error in
            completion(error == nil)
        }
    }
    
    func observe<T: FirestoreSerializable>(collection: String, documentId: String, completion: @escaping (T?) -> Void) {
        db.collection(collection).document(documentId).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data(), document.exists else {
                completion(nil)
                return
            }
            completion(T(dictionary: data))
        }
    }
}
