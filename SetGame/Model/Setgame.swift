//
//  Setgame.swift
//  SetGame
//
//  Created by Vu Quoc An on 28/10/2018.
//  Copyright © 2018 Vu Quoc An. All rights reserved.
//

import Foundation
struct SetGame{
    static let numberStartingDraw = 4
    private var deck:[Card] = Card.all.shuffled()
    
    private(set) var score = 0
    private(set) var selectedCards = [Card]()
    private(set) var matchedCards  = [Card]()
    private(set) var scoredCards  = [Card]()
    private(set) var showingCards   = [Card]()
    private(set) var deckIsEmpty = false

    // pick a card and return if it's a matched and need to replace cards.
    mutating func pickCard(at index: Int) -> [Int]?{
        var indexOfReplaceCards:[Int]? = nil
        let pickedCard = showingCards[index]
        guard !selectedCards.contains(pickedCard) else {
            return indexOfReplaceCards
        }
        print("touched card at \(index)")
        assert(selectedCards.count<=3)
        selectedCards.append(pickedCard)
        
        if selectedCards.count == 3{
            if SetGame.isSet(cards: selectedCards){
                // set game after check is set
                matchedCards += selectedCards
                indexOfReplaceCards = replace3Cards()
            }
            selectedCards = []
        }
        return indexOfReplaceCards
    }
    // remove matching cards and draw 3 new cards
    mutating func replace3Cards() -> [Int]?{
        if deck.isEmpty {
            return nil
        }
        guard matchedCards.count>0 else {
            fatalError()
        }
        var removingCards = [Int]()
        for (index,card) in showingCards.enumerated() {
            if matchedCards.contains(card) {
                // if the cards is the matched card replace them.
                showingCards[index] = deck.removeFirst()
                removingCards.append(index)
            }
        }
        score += 4
        
        matchedCards = []
        return removingCards

    }
    mutating func removeMatchedCard() {
        guard matchedCards.count>0 else {
            fatalError()
        }
        for (index,card) in showingCards.enumerated().reversed() {
            if matchedCards.contains(card) {
                showingCards.remove(at: index)
            }
        }
        score += 4
        
        matchedCards = []
        
        
    }
    static func isSet(cards: [Card]) -> Bool{
        return true
        
//        let matchedShade = Value.thirdMatched(firstValue: cards[0].shade, secondValue: cards[1].shade)
//        let matchedColor = Value.thirdMatched(firstValue: cards[0].color, secondValue: cards[1].color)
//        let matchedSymbol = Value.thirdMatched(firstValue: cards[0].symbol, secondValue: cards[1].symbol)
//        let matchedAmount = Value.thirdMatched(firstValue: cards[0].amount, secondValue: cards[1].amount)
//
//        let matchedCard = Card(shade:matchedShade,color:matchedColor,symbol:matchedSymbol,amount:matchedAmount)
//
//        return cards[2] == matchedCard
//
    }
    
    mutating func drawCard() -> Card{
        return deck.removeFirst()
    }
    mutating func draw3Card() -> [Card]{
        var newCards = [Card]()
        score += matchedCards.count
        scoredCards += matchedCards
        matchedCards = []
        
        if deck.isEmpty {
            deckIsEmpty = true
        } else{
            for _ in 0..<3 {
                let card = deck.removeFirst()
                showingCards.append(card)
                newCards.append(card)
            }
        }
        return newCards
    }
    init(){
        for _ in 0..<SetGame.numberStartingDraw*3 {
            showingCards.append(deck.removeFirst())
        }
    }
}
