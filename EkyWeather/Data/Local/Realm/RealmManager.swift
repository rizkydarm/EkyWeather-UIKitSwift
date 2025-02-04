//
//  RealmManager.swift
//  EkyWeather
//
//  Created by Eky on 22/01/25.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    private var realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    // MARK: - Create
    func create<T: Object>(_ object: T) throws {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            throw error
        }
    }
    
    // MARK: - Read
    func getAll<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func getObject<T: Object>(_ type: T.Type, withPrimaryKey key: Any) -> T? {
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    // MARK: - Update
    func update<T: Object>(_ object: T, with dictionary: [String: Any]) throws {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            throw error
        }
    }
    
    // MARK: - Delete
    func delete<T: Object>(_ object: T) throws {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            throw error
        }
    }
    
    func deleteAll<T: Object>(_ type: T.Type) throws {
        do {
            let objects = realm.objects(type)
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            throw error
        }
    }
    
    // MARK: - Query
    func query<T: Object>(_ type: T.Type, predicate: NSPredicate) -> Results<T> {
        return realm.objects(type).filter(predicate)
    }
}
