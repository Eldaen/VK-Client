//
//  FriendsSection.swift
//  VK-Client
//
//  Created by Денис Сизов on 16.10.2021.
//


struct FriendsSection: Comparable {
    var key: Character
    var data: [UserModel]
    
    static func < (lhs: FriendsSection, rhs: FriendsSection) -> Bool {
        return lhs.key < rhs.key
    }
    
    static func == (lhs: FriendsSection, rhs: FriendsSection) -> Bool {
        return lhs.key == rhs.key
    }
}
