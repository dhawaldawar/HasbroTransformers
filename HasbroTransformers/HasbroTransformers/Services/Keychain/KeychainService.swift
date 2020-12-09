//
//  KeychainService.swift
//  HasbroTransformers
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

class KeyChainService {

    static func save(key: String, value: String) -> Bool {
        guard let value = value.data(using: .utf8) else {
            return false
        }
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrService as String : key,
            kSecValueData as String   :  value] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    static func load(key: String) -> String? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == noErr, let data = dataTypeRef as? Data, let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    static func delete(key: String) {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrService as String : key] as [String : Any]

        SecItemDelete(query as CFDictionary)
    }
}
