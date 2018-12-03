import Foundation
import Firebase
import RxSwift

struct FirestoreError {
    // Note: Error codes upto 16 are default error codes
    static let batchSizeExceded = NSError(domain: FirestoreErrorDomain, code: 17,
                                          userInfo: [NSLocalizedDescriptionKey: "Batch size should be less than 500"])
}

extension Reactive where Base: CollectionReference {
    func getDocuments() -> Single<QuerySnapshot> {
        return Single.create { observer in
            self.base.getDocuments(completion: { (snapshot, error) in
                if let `snapshot` = snapshot {
                    observer(.success(snapshot))
                } else if let `error` = error {
                    observer(.error(error))
                }
            })
            return Disposables.create()
        }
    }

    func add(_ document: [String: Any]) -> Single<DocumentReference> {
        return Single.create { observer in
            var ref: DocumentReference? = nil
            ref = self.base.addDocument(data: document) { error in
                if let `error` = error {
                    observer(.error(error))
                    return
                } else if let `ref` = ref {
                    observer(.success(ref))
                    return
                }
            }
            return Disposables.create()
        }
    }

    func deleteAll(_ batchLimit: Int = 100) -> Single<Void> {
        return Single.create { observer in
            if batchLimit > 500 { observer(.error(FirestoreError.batchSizeExceded)) }
            self.base.limit(to: batchLimit).getDocuments(completion: { (snapshot, error) in
                if let `error` = error {
                    observer(.error(error))
                    return
                }
                guard let `snapshot` = snapshot, !snapshot.isEmpty else {
                    observer(.success(()))
                    return
                }
                let batch = self.base.firestore.batch()
                snapshot.documents.forEach { batch.deleteDocument($0.reference) }
                batch.commit(completion: { error in
                    if let `error` = error {
                        observer(.error(error))
                        return
                    }
                    observer(.success(()))
                })
            })
            return Disposables.create()
        }
    }
}

extension Reactive where Base: Query {
    func getDocuments() -> Single<QuerySnapshot> {
        return Single.create { observer in
            self.base.getDocuments(completion: { (snapshot, error) in
                if let `snapshot` = snapshot {
                    observer(.success(snapshot))
                } else if let `error` = error {
                    observer(.error(error))
                }
            })
            return Disposables.create()
        }
    }

    func listen() -> Observable<QuerySnapshot> {
        return Observable.create { observer in
            let listener = self.base.addSnapshotListener({ (snapshot, error) in
                if let `snapshot` = snapshot {
                    observer.onNext(snapshot)
                } else if let `error` = error {
                    observer.onError(error)
                }
            })
            return Disposables.create { listener.remove() }
        }
    }
}

extension Reactive where Base: WriteBatch {
    func commit() -> Single<Void> {
        return Single.create { observer in
            self.base.commit(completion: { error in
                if let `error` = error {
                    observer(.error(error))
                    return
                }
                observer(.success(()))
            })
            return Disposables.create()
        }
    }
}

extension Reactive where Base: Firestore {
    func runTransaction(_ updateBlock: @escaping (Firebase.Transaction, NSErrorPointer) -> Any?) -> Single<Any> {
        return Single.create { observer in
            self.base.runTransaction(updateBlock, completion: { (object, error) in
                if let object = object {
                    observer(.success(object))
                } else if let `error` = error {
                    observer(.error(error))
                }
            })
            return Disposables.create()
        }
    }
}

extension Observable where Element: QuerySnapshot {
    
    func mapArray<T: Decodable>(_ type: T.Type) -> Observable<[T]> {
        return self.map({ $0.decodeObject() }).unwrap()
    }
    
    func mapToDictionary() -> Observable<[String: Any]> {
        return self.map({ $0.mapToDictionary() })
    }
}

extension Observable where Element: DocumentSnapshot {
    
    func map<T: Decodable>(_ type: T.Type) -> Observable<T?> {
        return self.map({ $0.decodeObject() })
    }
}

extension DocumentSnapshot {
    
    func decodeObject<T: Decodable>() -> T? {
        guard self.exists,
            let currentValue = self.data(),
        JSONSerialization.isValidJSONObject(currentValue) else {
                return nil
        }

        let decoder = JSONDecoder()
        
        if let data = try?  JSONSerialization.data(withJSONObject: currentValue, options: []) {
            do {
                return try decoder.decode(T.self, from: data)
            } catch let error {
                print("\n\nError parsing object: \(error.localizedDescription)")
                return nil
            }
        }
        
       return nil
    }
}

extension QuerySnapshot {
    
    func mapToDictionary() -> [String: Any] {
        return self.documents.map { [$0.documentID: $0.data()] }
            .reduce(into: [String: Any]()) { (dic, document) in
                if let key = document.first?.key, let value = document.values.first {
                    dic[key] = value
                }
        }
    }

    func decodeObject<T: Decodable>() -> [T]? {
        
        guard !self.isEmpty else {
            return nil
        }
        
        let values = self.documents.map { $0.data() }
        
        let decoder = JSONDecoder()
        
        var result: [T] = []
        
        values.forEach { value in
            if let data = try? JSONSerialization.data(withJSONObject: value,
                                                         options: [.prettyPrinted]),
                let object = try? decoder.decode(T.self, from: data) {
                    result.append(object)
            }
        }
        
        return result
    }
    
    func decodeAsMap<T: Decodable>() -> [String: T] {
        guard !self.isEmpty else {
            return [:]
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: self.mapToDictionary(),
                                                     options: JSONSerialization.WritingOptions.prettyPrinted) else {
                                                        return [:]
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode([String: T].self, from: data)
        } catch let error {
            print("\n\nError parsing object: \(error.localizedDescription)")
            return [:]
        }
        
    }
}
