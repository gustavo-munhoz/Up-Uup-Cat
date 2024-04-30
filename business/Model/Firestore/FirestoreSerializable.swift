//
//  FirestoreSerializable.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 29/04/24.
//

protocol FirestoreSerializable {
    init?(dictionary: [String: Any])
    var dictionary: [String: Any] { get }
}

