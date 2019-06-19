//
//  Card.swift
//  SetGame
//
//  Created by Vu Quoc An on 28/10/2018.
//  Copyright © 2018 Vu Quoc An. All rights reserved.
//

import Foundation
struct Card:CustomStringConvertible,Hashable{
    var shortDescription: String {
        return "\(shade.rawValue) \(color.rawValue) \(symbol.rawValue) \(amount.rawValue)"
    }
    var description: String {
        return "Card: Color: \(color), Symbol: \(color), Amount: \(amount)"
    }
    var hashValue: Int {
        return shade.rawValue +  color.rawValue*3 + symbol.rawValue*9 + amount.rawValue*27
    }
    let shade:Value
    let color:Value
    let symbol:Value
    let amount:Value
    
    static let all:[Card] = {
        var allcard = [Card]()
        for sha in Value.allCases {
            for sym in Value.allCases{
                for col in Value.allCases{
                    for amo in Value.allCases{
                        allcard.append(Card(shade: sha, color: col, symbol: sym, amount: amo))
                    }
                }
            }
        }
        return allcard
    }()
}


enum Value:Int, CaseIterable{
    case first = 1
    case second
    case third
    static let all:Set = [Value.first,.second,.third]
}


extension Card:Equatable {
    static func ==(lhs:Card ,rhs:Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
extension Value {
    static func thirdMatched(firstValue: Value,secondValue: Value)->Value{
        if firstValue == secondValue {
            return firstValue
        } else {
            var tempAll = all
            tempAll.remove(firstValue)
            tempAll.remove(secondValue)
            return tempAll.first!
        }
        
    }
}
