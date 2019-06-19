//
//  ViewController.swift
//  SetGame
//
//  Created by Vu Quoc An on 28/10/2018.
//  Copyright © 2018 Vu Quoc An. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController,UIDynamicAnimatorDelegate {
    lazy var grid = Grid(layout: Grid.Layout.aspectRatio(GameInfo.aspectRatioForCard))
    
    
    @IBOutlet weak var discardPileView: UIView!
    @IBOutlet weak var drawCardPileView: UIView!
    @IBOutlet weak var gridCardView: UIView!
    private var showedButton = [UIButton]()
    private var game = SetGame()
    private let symbolToUISymbol = [Value.first:Symbol.diamond,Value.second:Symbol.oval,Value.third:Symbol.squiggle]
    private let colorForUIColor = [Value.first:UIColor.green,Value.second:UIColor.red,Value.third:UIColor.blue]
    private let shadeForUIShade = [Value.first:Shade.outline,Value.second:Shade.solid,Value.third:Shade.stripped]
    @IBOutlet weak var drawMoreCardButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    lazy var animator = UIDynamicAnimator(referenceView: gridCardView)
    var positioningAnimator : UIViewPropertyAnimator?
    var setCardButtons = [SetCardView]()
    
    @IBOutlet weak var disCardDrawCardStackView: UIStackView!
    var discardFrame: CGRect {
        get {
        let x = discardPileView.frame.origin.x + disCardDrawCardStackView.frame.origin.x - gridCardView.frame.origin.x
        let y = discardPileView.frame.origin.y + disCardDrawCardStackView.frame.origin.y - gridCardView.frame.origin.y
        let width = discardPileView.frame.width
        let height = discardPileView.frame.height
        return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    var drawcardFrame: CGRect {
        get {
            let x = drawCardPileView.frame.origin.x + disCardDrawCardStackView.frame.origin.x - gridCardView.frame.origin.x
            let y = drawCardPileView.frame.origin.y + disCardDrawCardStackView.frame.origin.y - gridCardView.frame.origin.y
            let width = drawCardPileView.frame.width
            let height = drawCardPileView.frame.height
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
//    grid.frame = gridCardView.frame
//    moveCardsToUpdatePositions(animated: false)
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        grid.frame = gridCardView.frame
//        moveCardsToUpdatePositions(animated: false)
//    }
    //    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        grid.frame = gridCardView.frame
//        moveCardsToUpdatePositions(animated: false)
//    }
    func removeCardsAtIndices(indices: [Int]){

            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: GameInfo.drawCardAnimationTime,
                delay: 0.0, options: .curveEaseIn,
                animations: {
                    for index in indices {
                        
                        //care
                        self.setCardButtons[index].frame = self.discardFrame
                    }
            },
                completion: {position in
                    
                    for index in indices{
                        self.setUpCardViewWith(self.game.showingCards[index],self.setCardButtons[index])
                        self.setCardButtons[index].frame = self.drawcardFrame
                    }
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: GameInfo.drawCardAnimationTime,
                    delay: 0.0, options: .curveEaseIn,
                    animations: {
                        for index in indices {
                            self.setCardButtons[index].frame = self.grid[index]!
                        }
                    })
            })
    }
    
    
    @objc func setCardTouch(sender: UITapGestureRecognizer? = nil) {
        // handling code
        let cardView = sender?.view! as! SetCardView
        let indexOfCard = setCardButtons.firstIndex(of: cardView)!
        
        let indicesOfReplacementCards =  game.pickCard(at: indexOfCard)
        if let indexs = indicesOfReplacementCards {
            replace3CardAt(indexs)
        }
        
        
        print("touch button at \(setCardButtons.firstIndex(of: cardView)!)")
        updateFromModel()
    }
    // when animator finished remove all behaviors
    
    
    // set up card view, add a TapGuesture for click action too
    func setUpCardViewWith(_ card:Card, _ cardView: SetCardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(setCardTouch))
        cardView.addGestureRecognizer(tap)
        cardView.color = colorForUIColor[card.color]!
        cardView.shade = shadeForUIShade[card.shade]!
        cardView.symbolType = symbolToUISymbol[card.symbol]!
        cardView.numberOfSymbol = card.amount.rawValue
        
    }
    
    func replace3CardAt(_ indices:[Int]) {
        removeCardsAtIndices(indices: indices)
        
    }
    
    func updateFromModel(){
        // update gridView
        
        // checking If somehow there are more cell count than showing cards,
        //which is impossible consider the logic of the game
        guard grid.cellCount <= game.showingCards.count else {
            fatalError()
        }
        // checking if there is new Card, if there is new Card deal it.
        if setCardButtons.count < game.showingCards.count {
            
            //updating the grid
            
            
            //setting new cards, the 3 drawing cards, or 12 card at the start
            //update position of old cards
            
            
            
            for (index,card) in game.showingCards.enumerated() {
                var setCardView:SetCardView!
                if (index < setCardButtons.count) {
                    setCardView = setCardButtons[index]
                    
                } else {
                    //initially the card start from draw card pile
                    setCardView = SetCardView()
                    setCardView.frame = drawcardFrame
                    gridCardView.addSubview(setCardView)
                    setUpCardViewWith(card, setCardView)
                    setCardButtons.append(setCardView)
                }
                
                
                
            }
            moveCardsToUpdatePositions(animated: true )
        }
        
        for (index,card) in game.showingCards.enumerated(){
            let currentCard = setCardButtons[index]
            //            currentCard.frame = grid[index]!
            
            
            //     setting Up the Card View displaying property, adding gesture, if it's selected, hightlight it.
            if game.selectedCards.contains(card) {
                currentCard.backgroundColor = UIColor.gray
            }
            else {
                currentCard.backgroundColor = UIColor.clear
            }
        }
        
        
        //update score label
        scoreLabel.text = "Score: \(game.score)"
    }
    func moveCardsToUpdatePositions(animated: Bool) {
        grid.cellCount = game.showingCards.count
        grid.frame = gridCardView.bounds
        if animated {
            for (index, setCardView) in setCardButtons.enumerated() {
                let snapBehavior = UISnapBehavior(item: setCardView, snapTo: CGPoint(x: grid[index]!.midX,y: grid[index]!.midY))
                snapBehavior.damping = 0.5
                animator.addBehavior(snapBehavior)
            }
            
            positioningAnimator = UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: GameInfo.drawCardAnimationTime,
                delay: 0.0, options: .curveEaseInOut,
                animations: repositionAllButtonViews){
                    _ in self.animator.removeAllBehaviors()
            }
            
        } else {
            repositionAllButtonViews()
        }
        //        let snapBehavior = UISnapBehavior(item: cardView, snapTo: CGPoint(x: toFrame.midX,y: toFrame.midY))
        //        snapBehavior.damping = 0.5
        
        //        animator.addBehavior(snapBehavior)
        
    }
    //
    //    let snapBehavior = UISnapBehavior(item: button,
    //                                      snapTo: currentFrame.center)apple-reference-documentation://hsR9YUc-Zu
    //
    
    //    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
    //        animator.removeAllBehaviors()
    //        isPerformingDealAnimation = false
    //        scheduledDealAnimations = nil
    //    }
    
    func repositionAllButtonViews () {
        
        for (index, setCardView) in setCardButtons.enumerated() {
            setCardView.frame = grid[index]!
            
        }
        
    }
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        // animator.removeAllBehaviors()
    }
    @IBAction func touchDrawMoreCard(_ sender: Any) {
        
        game.draw3Card()
        //     animator.removeAllBehaviors()
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
        //        animator.delegate = self
        updateFromModel()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    private var buttonIndex = [Card: Int]()
    private func buttonIndex(for card:Card) -> Int {
        
        if buttonIndex[card] == nil {
            for _ in 0..<cardButtons.count{
            }
        }
        
        return buttonIndex[card]!
        
    }
}

struct GameInfo {
    static let maxButton = 81
    static let aspectRatioForCard = CGFloat(2.0)
    static let drawCardAnimationTime = 0.5
}

