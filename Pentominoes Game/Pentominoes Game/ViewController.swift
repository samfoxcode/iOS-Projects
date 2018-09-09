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

class ViewController: UIViewController {
    
    @IBOutlet var mainBoardView: UIImageView!
    @IBOutlet var piecesHomeView: UIView!
    
    let pentominoModel = Model()
    let pieceViews : [String:UIImageView]
    var solved = false
    
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
            mainBoardView.addSubview(piece)
            let solution = pentominoModel.allSolutions[index][key]

            let newX = CGFloat((solution?.x)!)*30
            let newY = CGFloat((solution?.y)!)*30
            let radians = (CGFloat((solution?.rotations)!)*CGFloat.pi*CGFloat(90))/CGFloat(180)
            // Set the view's alpha so that we can animate a fade effect.
            piece.alpha = 0
            
            UIView.animate(withDuration: 0.8, delay: 0.1, animations: { () -> Void in
            piece.transform = CGAffineTransform(rotationAngle: radians)
            if ((solution?.isFlipped)!) {
                piece.transform = piece.transform.scaledBy(x: -1, y: 1)
            }
            piece.frame = CGRect(x: newX, y: newY, width: piece.frame.size.width, height: piece.frame.size.height)
            piece.alpha = 1
            })
        }
    }
    
    func resetPieces(){
        var xStart = 30
        var yStart = 50
        solved = false
        var secondRow = false
        var count = 1
        for (_, gamePiece) in pieceViews {
            gamePiece.transform = CGAffineTransform.identity
            if secondRow {
                yStart = yStart + 180
                xStart = 30
                secondRow = false
            }
            if count == 6 {
                secondRow = true
            }
            count = count + 1
            piecesHomeView.addSubview(gamePiece)
            
            gamePiece.alpha = 0
            UIView.animate(withDuration: 0.6, delay: 0.1, animations: { () -> Void in
            gamePiece.alpha = 1
            gamePiece.frame = CGRect(x: CGFloat(xStart), y: CGFloat(yStart), width: gamePiece.bounds.size.width, height: gamePiece.bounds.size.height)
            })
            xStart = xStart + Int(gamePiece.bounds.size.width)+30
            
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
        
        for (key, gamePiece) in pentominoModel.pieces{
            let aView = UIImageView(piece: gamePiece)
            _pieceViews[key] = aView
        }
        pieceViews = _pieceViews
        
        super.init(coder: aDecoder)
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

