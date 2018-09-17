//
//  ViewController.swift
//  Pentominoes Game
//
//  Created by Samuel Fox on 9/3/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit


extension UIImageView {
    convenience init(piece id:String) {
        let image = UIImage(named: id)
        self.init(image: image)
        self.contentMode = .scaleAspectFit
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var mainBoardView: UIImageView!
    @IBOutlet var piecesHomeView: UIView!
    
    let pentominoModel = Model()
    let pieceViews : [String:UIImageView]
    let kScaleX : CGFloat = 1.2
    let kScaleY : CGFloat = 1.2
    let kScalePieceForBoard : CGFloat = 30.0
    var solved = false
    var mainTap : UITapGestureRecognizer!
    var countPerRow = 6
    var horizontalSpacing = 40
    var horizontalStart = 40
    var verticalStart = 50
    
    func solvePieces(_ image: UIImage){
        solved = true
        let index : Int
        switch image {
        case #imageLiteral(resourceName: "Board0") :
            return
        case #imageLiteral(resourceName: "Board1") :
            index = 0
        case #imageLiteral(resourceName: "Board2"):
            index = 1
        case #imageLiteral(resourceName: "Board3"):
            index = 2
        case #imageLiteral(resourceName: "Board4"):
            index = 3
        case #imageLiteral(resourceName: "Board5"):
            index = 4
        default:
            return
        }
        
        // Move the pieces to their appropiate positions on the appropiate board, with an animation.
        for (key, piece) in pieceViews {
            
            // Get solution for single piece for specific board.
            let solution = pentominoModel.getSolution(index, key)
            
            let newX = CGFloat((solution?.x)!)*kScalePieceForBoard
            let newY = CGFloat((solution?.y)!)*kScalePieceForBoard
            let radians = (CGFloat((solution?.rotations)!)*CGFloat.pi*CGFloat(90))/CGFloat(180)
            piece.center = mainBoardView.convert(piece.center, from: piece.superview)
            
            UIView.animate(withDuration: 1, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            piece.transform = CGAffineTransform(rotationAngle: radians)
            if ((solution?.isFlipped)!) {
                piece.transform = piece.transform.scaledBy(x: -1, y: 1)
            }
            self.mainBoardView.addSubview(piece)
            self.view.sendSubview(toBack: self.piecesHomeView)
            piece.frame = CGRect(x: newX, y: newY, width: piece.frame.size.width, height: piece.frame.size.height)
            })
        }
    }
    
    
    func resetPieces(){
        var xStart = horizontalStart
        var yStart = verticalStart
        solved = false
        var secondRow = false
        var count = 1
        for (_, gamePiece) in pieceViews {
            gamePiece.transform = CGAffineTransform.identity
            
            if secondRow {
                yStart = yStart + 135
                xStart = horizontalStart
                secondRow = false
            }
            if count == countPerRow {
                secondRow = true
            }
            count = count + 1
            
            // Remember where the piece started for future reference.
            if pentominoModel.tranforms[gamePiece.tag] != nil {
                pentominoModel.tranforms[gamePiece.tag]?.xPos = xStart
                pentominoModel.tranforms[gamePiece.tag]?.yPos = yStart
            }
            else {
                pentominoModel.tranforms[gamePiece.tag] = Transformations(rotatedTimes: 0, xPos: xStart, yPos: yStart)
            }
            gamePiece.center = piecesHomeView.convert(gamePiece.center, from: gamePiece.superview)
            UIView.animate(withDuration: 1, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.piecesHomeView.addSubview(gamePiece)
            self.view.sendSubview(toBack: self.mainBoardView)
            gamePiece.frame = CGRect(x: CGFloat(xStart), y: CGFloat(yStart), width: gamePiece.bounds.size.width, height: gamePiece.bounds.size.height)
            })
            xStart = xStart + Int(gamePiece.bounds.size.width)+horizontalSpacing
            
        }
    }
    
    @IBAction func changeBoard(sender: UIButton) {
        switch sender.tag{
            case 0:
                mainBoardView.image = #imageLiteral(resourceName: "Board0")
                resetPieces()
            case 1:
                mainBoardView.image = #imageLiteral(resourceName: "Board1")
            case 2:
                mainBoardView.image = #imageLiteral(resourceName: "Board2")
            case 3:
                mainBoardView.image = #imageLiteral(resourceName: "Board3")
            case 4:
                mainBoardView.image = #imageLiteral(resourceName: "Board4")
            case 5:
                mainBoardView.image = #imageLiteral(resourceName: "Board5")
            default:
                return
        }
        if solved && mainBoardView.image != #imageLiteral(resourceName: "Board0") {
            solvePieces(mainBoardView.image!)
        }
    }
    
    
    
    @IBAction func solve(_ sender: Any) {
        solvePieces(mainBoardView.image!)
    }
    
    @IBAction func reset(_ sender: Any) {
        resetPieces()
    }
    

    required init?(coder aDecoder: NSCoder) {
        
        var _pieceViews = [String:UIImageView]()
        var count = 0
        for (key, gamePiece) in pentominoModel.pieces{
            let aView = UIImageView(piece: gamePiece)
            aView.tag = count
            count = count + 1
            _pieceViews[key] = aView
        }
        pieceViews = _pieceViews
        super.init(coder: aDecoder)
        addGestures()
    }
    
    func snapPiece(_ piece: UIView){
        let x = piece.frame.origin.x.truncatingRemainder(dividingBy: 30)
        let y = piece.frame.origin.y.truncatingRemainder(dividingBy: 30)
        piece.frame.origin.x = piece.frame.origin.x - x
        piece.frame.origin.y = piece.frame.origin.y - y
    }
    
    func getAndSetTranslation(_ piece: UIView, _ sender: UIPanGestureRecognizer){
        self.view.bringSubview(toFront: piece)
        let translation = sender.translation(in: self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func movePieceToBoard(_ piece: UIView, _ sender: UIPanGestureRecognizer){
        piece.transform = CGAffineTransform.identity
        
        rotateHelper(piece)
        
        mainBoardView.addSubview(piece)
        let newCenter = mainBoardView.convert(piece.center, from: piece.superview)
        piece.center = newCenter
        piece.center = sender.location(in: mainBoardView)
        
        snapPiece(piece)
        
        mainBoardView.isUserInteractionEnabled = true
    }
    
    func movePieceToHome(_ piece: UIView){
        piecesHomeView.addSubview(piece)
        piece.transform = CGAffineTransform.identity
        let newCenter = piecesHomeView.convert(piece.center, from: piece.superview)
        piece.center = newCenter
        let origX = pentominoModel.tranforms[piece.tag]?.xPos
        let origY = pentominoModel.tranforms[piece.tag]?.yPos
        piece.frame = CGRect(x: CGFloat(origX!), y: CGFloat(origY!), width: piece.bounds.size.width, height: piece.bounds.size.height)
    }
    
    @objc func movePiece(_ sender: UIPanGestureRecognizer) {
        let piece = sender.view!

        switch sender.state {
        case .began:
            piece.transform = piece.transform.scaledBy(x: kScaleX, y: kScaleY)
            
            // figure out how much the sender has moved in the main view from it's center, and update it accordingly.
            getAndSetTranslation(piece, sender)
        case .changed:
            getAndSetTranslation(piece, sender)
        case .ended:
            let newCenter = self.view.convert(piece.center, from: piece.superview)
            piece.center = newCenter
            if mainBoardView.frame.contains(piece.frame.origin){
                movePieceToBoard(piece, sender)
            }
            else {
                movePieceToHome(piece)
            }
        default:
            break
        }
    }
    
    func rotateHelper(_ piece: UIView){
        let radians = (CGFloat((pentominoModel.tranforms[piece.tag]?.rotatedTimes)!) * CGFloat.pi*CGFloat(90))/CGFloat(180)
        piece.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    @objc func rotatePiece(_ sender: UITapGestureRecognizer){
        let piece = sender.view!
        pentominoModel.tranforms[piece.tag]?.rotatedTimes += 1
        rotateHelper(piece)
        snapPiece(piece)
    }
    
    @objc func flipPiece(_ sender: UITapGestureRecognizer){
        let piece = sender.view!
        piece.transform = piece.transform.scaledBy(x: -1, y: 1)
        snapPiece(piece)
    }
    
    func addGestures(){
        for (_, piece) in pieceViews{
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.movePiece(_:)))
            piece.isUserInteractionEnabled = true
            piece.addGestureRecognizer(panGesture)
            
            let flipGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.flipPiece(_:)))
            flipGesture.numberOfTapsRequired = 2
            piece.addGestureRecognizer(flipGesture)
            
            let rotateGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.rotatePiece(_:)))
            rotateGesture.numberOfTapsRequired = 1
            piece.addGestureRecognizer(rotateGesture)
            rotateGesture.require(toFail: flipGesture)
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        switch toInterfaceOrientation {
        case .portrait:
            countPerRow = 6
            horizontalSpacing = 40
            horizontalStart = 40
        case .landscapeLeft:
            countPerRow = 12
            horizontalSpacing = 10
            horizontalStart = 20
        case .landscapeRight:
            countPerRow = 12
            horizontalSpacing = 10
            horizontalStart = 20
        default:
            break
        }
        //resetPieces()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (_, piece) in pieceViews {
            piecesHomeView.addSubview(piece)
        }

        resetPieces()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

