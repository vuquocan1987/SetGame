//
//  ViewController.swift
//  SetGame
//
//  Created by Vu Quoc An on 28/10/2018.
//  Copyright © 2018 Vu Quoc An. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    typealias BtnCard = (Card,Int)
    private var showedButton = [UIButton]()
    private var game = SetGame()
    private let symbolForSymbolString = [Value.first:"▲",Value.second:"●",Value.third:"■"]
    private let colorForUIColor = [Value.first:UIColor.green,Value.second:UIColor.red,Value.third:UIColor.blue]
    @IBOutlet weak var drawMoreCardButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func touchCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender){
            game.pickCard(at: index)
    	}
        
        updateFromModel()
        if game.showingCards.count < GameInfo.maxButton {
            drawMoreCardButton.isEnabled = true
        }
    }
    func getNSAttributeStringFromCard(card: Card) -> NSAttributedString {
        var titleString = symbolForSymbolString[card.symbol]!
        var attribute = [NSAttributedString.Key : Any]()
        attribute[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 20)
        
        switch  card.amount {
        case .first: break
        case .second:
            titleString += titleString
        case .third:
            titleString += (titleString + titleString)
        }
        attribute[NSAttributedString.Key.strokeColor] = colorForUIColor[card.color]
        
        switch card.shade {
        //case first is outline
        case .first:
            attribute[NSAttributedString.Key.strokeWidth] = 10.0
            fallthrough
            
        //case second is solid
        case .second:
            attribute[NSAttributedString.Key.foregroundColor] = colorForUIColor[card.color]!
            
        //case third is alpha
        case .third:
            attribute[NSAttributedString.Key.foregroundColor] = colorForUIColor[card.color]!.withAlphaComponent(0.3)
        }
        let attributedString = NSAttributedString(string: titleString, attributes: attribute)
        return attributedString
    }
    func updateFromModel(){
//        for index in 0..<game.showingCards.count{
//            showedButton[index].setTitle(game.showingCards[index].shortDescription,for: UIControl.State.normal )
//        }
        
        for (index,card) in game.showingCards.enumerated(){
            cardButtons[index].isHidden = false
            let attributedTitle = getNSAttributeStringFromCard(card: card)
            cardButtons[index].setAttributedTitle(attributedTitle, for: UIControl.State.normal)
            if game.selectedCards.contains(game.showingCards[index]){
                cardButtons[index].backgroundColor = UIColor.gray
            } else {
                cardButtons[index].backgroundColor = UIColor.black
            }
        }
        for index in game.showingCards.count..<GameInfo.maxButton {
            cardButtons[index].isHidden = true
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    @IBAction func touchDrawMoreCard(_ sender: Any) {
        
        game.draw3Card()
        updateFromModel()
        // Updating  game state after touchDrawMoreCard
        if game.deckIsEmpty {
            drawMoreCardButton.isEnabled = false
        }
        if game.showingCards.count >= GameInfo.maxButton {
            drawMoreCardButton.isEnabled = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFromModel()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    private var buttonIndex = [Card: Int]()
    private func buttonIndex(for card:Card) -> Int {
        
        if buttonIndex[card] == nil {
            for i in 0..<cardButtons.count{
                
            }
        }
        
        return buttonIndex[card]!
        
    }
}

struct GameInfo {
    static let maxButton = 24
}
