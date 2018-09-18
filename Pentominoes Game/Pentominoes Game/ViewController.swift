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

class ViewController: UIViewController, UIGestureRecognizerDelegate, HintDelegate {
    
    //MARK: - Declarations
    
    @IBOutlet var mainBoardView: UIImageView!
    @IBOutlet var piecesHomeView: UIView!
    @IBOutlet var hintButton: UIButton!
    @IBOutlet var solveButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var boardButtons: [UIButton]!
    
    let pentominoModel = Model()
    let pieceViews : [String:UIImageView]
    let kScaleX : CGFloat = 1.1
    let kScaleY : CGFloat = 1.1
    let kScalePieceForBoard : CGFloat = 30.0
    let kVerticalOffset = 120
    let hintViews : [String:UIImageView]
    let boards : [Int:UIImageView]
    var solved = false
    var mainTap : UITapGestureRecognizer!
    var countPerRow = 8
    var horizontalSpacing = 20
    var horizontalStart = 40
    var verticalStart = 10
    var hintCount = 0
    var hintIndex = 0
    
    required init?(coder aDecoder: NSCoder) {

        var _pieceViews = [String:UIImageView]()
        var _hintViews = [String:UIImageView]()
        var _boards = [Int:UIImageView]()
        var count = 0
        for (key, gamePiece) in pentominoModel.pieces{
            let aView = UIImageView(piece: gamePiece)
            aView.tag = count
            let aHintView = UIImageView(piece: gamePiece)
            aHintView.tag = count
            count = count + 1
            _pieceViews[key] = aView
            _hintViews[key] = aHintView
        }
        for tag in 0..<6{
            _boards[tag] = UIImageView(piece: "Board\(tag)")
            _boards[tag]?.tag = tag
        }
        pieceViews = _pieceViews
        hintViews = _hintViews
        boards = _boards
        super.init(coder: aDecoder)
        addGestures()
    }
    
    //MARK: - Actions
    
    @IBAction func hintRequested(_ sender: Any) {
        hintCount = hintCount + 1
    }
    
    @IBAction func solve(_ sender: Any) {
        hintButton.isEnabled = false
        solvePieces(mainBoardView.image!)
    }
    
    @IBAction func reset(_ sender: Any) {
        resetPieces()
    }
    
    //MARK: - Reset/Solve
    
    func solvePieces(_ image: UIImage, _ hint: Bool = false){
        solveButton.isEnabled = false
        solved = true
        hintCount = 0
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
        for boardButton in boardButtons {
            boardButton.isEnabled = false
        }
        hintIndex = index
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
    
    
    func resetPieces(_ fullReset: Bool = true){
        
        hintButton.isEnabled = true
        for boardButton in boardButtons {
            boardButton.isEnabled = true
        }
        solveButton.isEnabled = true
        var xStart = horizontalStart
        var yStart = verticalStart
        solved = false
        var secondRow = false
        var count = 1
        for (_, gamePiece) in pieceViews {
            
            if piecesHomeView.subviews.contains(gamePiece) || fullReset {
            gamePiece.transform = CGAffineTransform.identity
            
            if secondRow {
                yStart = yStart + kVerticalOffset
                xStart = horizontalStart
                secondRow = false
            }
            if count == countPerRow {
                secondRow = true
            }
            count = count + 1
            
            // Remember where the piece started for future reference.
            if pentominoModel.tranforms[gamePiece.tag] != nil {
                pentominoModel.setXPos(gamePiece.tag, xStart)
                pentominoModel.setYPos(gamePiece.tag, yStart)
            }
            else {
                pentominoModel.tranforms[gamePiece.tag] = Transformations(rotatedTimes: 0, flipped: 1, xPos: xStart, yPos: yStart)
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
    }
    
    //MARK: - Configure Board
    
    @IBAction func changeBoard(sender: UIButton) {
        hintCount = 0
        mainBoardView.image = boards[sender.tag]?.image
        if sender.tag == 0 {
            hintButton.isEnabled = false
            solveButton.isEnabled = false
        }
        else {
            hintIndex = sender.tag - 1
            solveButton.isEnabled = true
            hintButton.isEnabled = true
        }
        if solved && mainBoardView.image != #imageLiteral(resourceName: "Board0") {
            solvePieces(mainBoardView.image!)
        }
    }
    
    //MARK: - Moving Pieces
    
    func getAndSetTranslation(_ piece: UIView, _ sender: UIPanGestureRecognizer) {
        self.view.bringSubview(toFront: piece)
        let translation = sender.translation(in: self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func movePieceToBoard(_ piece: UIView, _ sender: UIPanGestureRecognizer) {
        // Reset size without losing rotations/flips.
        piece.transform = piece.transform.scaledBy(x: 1/kScaleY, y: 1/kScaleY)

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
        let origX = pentominoModel.getXPos(piece.tag)
        let origY = pentominoModel.getYPos(piece.tag)
        piece.frame = CGRect(x: CGFloat(origX), y: CGFloat(origY), width: piece.bounds.size.width, height: piece.bounds.size.height)
    }
    
    @objc func movePiece(_ sender: UIPanGestureRecognizer) {
        let piece = sender.view!

        for button in boardButtons {
            self.view.sendSubview(toBack: button)
        }
        
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
                self.movePieceToHome(piece)
            }
        default:
            break
        }
    }
    
    //MARK: - Transformations
    
    func rotateHelper(_ piece: UIView){
        let radians = (CGFloat(1) * CGFloat.pi*CGFloat(90))/CGFloat(180)
        piece.transform = piece.transform.rotated(by: radians)
    }
    
    @objc func rotatePiece(_ sender: UITapGestureRecognizer) {
        let piece = sender.view!
        if piece.superview == mainBoardView {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.rotateHelper(piece)
            self.snapPiece(piece)
            })
        }
    }
    
    @objc func flipPiece(_ sender: UITapGestureRecognizer) {
        let piece = sender.view!
        if piece.superview == mainBoardView {
            let flip = pentominoModel.getFlipper(piece.tag) == 1 ? -1 : 1
            pentominoModel.setFlipper(piece.tag, flip)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            piece.transform = CGAffineTransform(scaleX: 1.0, y: CGFloat(flip))
            self.snapPiece(piece)
            })
        }
    }
    
    func snapPiece(_ piece: UIView){
        let x = piece.frame.origin.x.truncatingRemainder(dividingBy: 30)
        let y = piece.frame.origin.y.truncatingRemainder(dividingBy: 30)
        piece.frame.origin.x = piece.frame.origin.x - x
        piece.frame.origin.y = piece.frame.origin.y - y
    }
    
    //MARK: - Gestures
    
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
    
    //MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        solveButton.isEnabled = false
        hintButton.isEnabled = false
        for (_, piece) in pieceViews {
            piecesHomeView.addSubview(piece)
        }

        resetPieces()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            countPerRow = 10
            resetPieces(false)
        }
        else{
            countPerRow = 8
            resetPieces(false)
        }
    }
    //MARK: - Segues
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let hintViewController = segue.destination as! HintViewController
        hintViewController.hintBoardView = mainBoardView
        hintViewController.hintBoardView.image = mainBoardView.image
        
        // Send the appropriate information to the hintViewController.
        // Not sure if there is a better way. Tried exposing these values through
        // the ViewController class, but that just didn't work, I think this is good.
        hintViewController.setHintImage((boards[hintIndex+1]?.image)!)
        hintViewController.setHintIndex(hintIndex)
        hintViewController.setHintViews(hintViews)
        hintViewController.setHintCount(hintCount)
        hintViewController.delegate = self
    }

}

