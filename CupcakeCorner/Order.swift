//
//  Order.swift
//  CupcakeCorner
//
//  Created by Aleksandr Zhazhoyan on 03.08.2025.
//

import SwiftUI

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Chocolate", "Strawberry", "Red Velvet", "Carrot Cake"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = "" {
        didSet { saveAddress() }
    }
    var streetAddress = "" {
        didSet { saveAddress() }
    }
    var city = ""{
        didSet { saveAddress() }
    }
    var zip = ""{
        didSet { saveAddress() }
    }
    
    var hasValidAddress: Bool {
        let fields = [name, streetAddress, city, zip]
        return fields.allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty}
        
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        //complicated cakes cost more
        cost += Decimal(type) / 2
        
        //$1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    init() {
        loadAddress()
    }
    
    func saveAddress() {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "name")
        defaults.set(streetAddress, forKey: "streetAddress")
        defaults.set(city, forKey: "city")
        defaults.set(zip, forKey: "zip")
    }
    
    func loadAddress() {
        let defaults = UserDefaults.standard
        name = defaults.string(forKey: "name") ?? ""
        streetAddress = defaults.string(forKey: "streetAddress") ?? ""
        city = defaults.string(forKey: "city") ?? ""
        zip = defaults.string(forKey: "zip") ?? ""
    }
}
