//
//  SetCardView.swift
//  SetGame
//
//  Created by Vu Quoc An on 11/06/2019.
//  Copyright © 2019 Vu Quoc An. All rights reserved.
//

import UIKit
@IBDesignable
class SetCardView: UIButton {
    @IBInspectable
    var numberOfSymbol: Int = 1 {didSet {setNeedsDisplay(); setNeedsLayout()}}
    var symbolType = Symbol.oval {didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var color: UIColor = UIColor.red {didSet {setNeedsDisplay(); setNeedsLayout()}}
    var shade = Shade.stripped {didSet {setNeedsDisplay(); setNeedsLayout()}}
    lazy var drawShapeFunc: (CGPoint, CGFloat, CGFloat) -> UIBezierPath = drawSquiggle
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        UIColor.blue.setStroke()
        roundedRect.stroke()
        switch symbolType {
        case .squiggle:
            drawShapeFunc = drawSquiggle
        case .oval:
            drawShapeFunc = drawOval
        case .diamond:
            drawShapeFunc = drawDiamond
        }
        color.setStroke()
        
        drawMultiple(numberOfSymbol)
    }
    private func drawMultiple(_ number: Int){
        let height = bounds.height * CardSizeRatio.symbolHeightToBoundHeight
        let verticalPadding = ( bounds.height - height ) / 2
        
        let width = bounds.width * CardSizeRatio.symbolWidthToBoundWidth
        let horizontalPadding = (bounds.width - ( CGFloat(number) * width )) / CGFloat( number + 1 )
        
        var startX = horizontalPadding
        let startY = verticalPadding
        for _ in 0..<number {
            let path = drawShapeFunc(CGPoint(x:startX,y:startY),width,height)
            drawShade(path,CGPoint(x:startX,y:startY),width,height)
            startX += horizontalPadding + width
        }
        print("something")
        
    }
    private func drawShade(_ path:UIBezierPath, _ startingPoint: CGPoint, _ width: CGFloat, _ height: CGFloat) {
        switch shade {
        case .outline:
            break
        case .solid:
            color.setFill()
            path.fill()
            break
        case .stripped:
            let context = UIGraphicsGetCurrentContext()!
            //this is to remove the affect of addClip on subsequent drawing
            context.saveGState()
            path.addClip()
            for y in stride(from: path.bounds.minY, to: path.bounds.maxY, by: 4) {
                path.move(to: CGPoint(x:path.bounds.minX, y:y))
                path.addLine(to: CGPoint(x: path.bounds.maxX, y: y))
            }
            path.lineWidth = CardSizeRatio.stripeLineWidth
            path.stroke()
            context.restoreGState()
            
        }
    }
    private func drawSquiggle(at startPoint:CGPoint,_ width:CGFloat, _ height:CGFloat)->UIBezierPath{
        let path = UIBezierPath()
        path.move(to: startPoint)
        let secondPoint = CGPoint(x: startPoint.x, y: startPoint.y+height)
        let thirdPoint = CGPoint(x: startPoint.x + width, y: startPoint.y+height)
        let forthPoint = CGPoint(x: startPoint.x + width, y: startPoint.y)
        path.addCurve(to: secondPoint, controlPoint1: startPoint.offsetBy(dx: -width, dy: height/3), controlPoint2: startPoint.offsetBy(dx: width, dy: height*2/3))
        path.addLine(to: thirdPoint)
        path.addCurve(to: forthPoint, controlPoint1: thirdPoint.offsetBy(dx: width, dy: -height/3), controlPoint2: thirdPoint.offsetBy(dx: -width, dy: -height*2/3))
        path.close()
        path.stroke()
        return path
    }
    
    private func drawOval(at startPoint:CGPoint,_ width:CGFloat, _ height:CGFloat)->UIBezierPath{
        let path = UIBezierPath(roundedRect: CGRect(x: startPoint.x, y: startPoint.y, width: width, height: height), cornerRadius: width)
        path.stroke()
        return path
    }
    private func drawDiamond(at startPoint:CGPoint,_ width:CGFloat, _ height:CGFloat)->UIBezierPath{
        let path =  UIBezierPath()
        path.move(to: startPoint.offsetBy(dx: width/2, dy: 0))
        path.addLine(to: startPoint.offsetBy(dx: 0, dy: height/2))
        path.addLine(to: startPoint.offsetBy(dx: width/2, dy: height))
        path.addLine(to: startPoint.offsetBy(dx: width, dy: height/2))
        path.close()
        path.stroke()
        return path
    }

}
enum Symbol {
    case squiggle
    case oval
    case diamond
}
enum Shade {
    case outline
    case solid
    case stripped
}

extension SetCardView {
    struct CardSizeRatio {

        static let symbolHeightToBoundHeight = CGFloat(0.75)
        static let symbolWidthToBoundWidth = CGFloat(0.20)
        static let spaceForThreeCardToSymbolWidth = CGFloat(0.5)
        static let numberOfStripe = 4
        static let stripeLineWidth = CGFloat(1.0)
    }
}
extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
