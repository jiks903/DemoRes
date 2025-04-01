//
//  Models.swift
//  DemoRes
//
//  Created by Jeegnesh Solanki on 01/04/25.
//

import Foundation

// MARK: - Restaurant Model
struct Restaurant: Decodable {
    let id: Int
    let name: String
    let location: String
    let lat: Double
    let long: Double
    let menus: [Menu]
}

// MARK: - Menu Model
struct Menu: Decodable {
    let id: Int
    let menuName: String
    let menuStatus: Bool
    let menuItems: [MenuItem]
}

// MARK: - MenuItem Model
struct MenuItem: Decodable {
    let id: Int
    let mainItemName: String
    let childItems: [ChildItem]
}

// MARK: - ChildItem Model
struct ChildItem: Decodable {
    let id: Int
    let name: String
    let extraIngredients: [String]
    let selectionType: String
    let defaultSelection: Bool
}

// MARK: - Root Model
struct Root: Decodable {
    let restaurants: [Restaurant]
}
