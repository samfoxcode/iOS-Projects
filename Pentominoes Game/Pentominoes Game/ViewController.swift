//
//  ViewController.swift
//  Pentominoes Game
//
//  Created by Samuel Fox on 9/3/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit


extension UIImageView {
    convenience init(piece id:String, x positionX: Int, y positionY: Int) {
        let image = UIImage(named: id)
        self.init(image: image)
        self.frame = CGRect(x: CGFloat(positionX), y: CGFloat(positionY), width: image!.size.width, height: image!.size.height)
        self.contentMode = .scaleAspectFit
    }
}



class ViewController: UIViewController {
    
    @IBOutlet var mainBoardView: UIImageView!
    @IBOutlet var piecesHomeView: UIView!
    
    let pentominoModel = Model()
    let pieceViews : [String:UIImageView]
    
    @IBAction func changeBoard(sender: UIButton) {
        switch sender.tag{
            case 0:
                mainBoardView.image = #imageLiteral(resourceName: "Board0")
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
    }
    
    func movePieces(_ image: UIImage){
        
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
        var flipX = 0
        // TODO : figure out why the pieces all end up on top of each other
        for (key, piece) in pieceViews {
            piece.removeFromSuperview()
            mainBoardView.addSubview(piece)
            let solution = pentominoModel.allSolutions[index][key]
            
            print(key)
            print(piece)
            print(solution)
            print(piece.frame)
            let newX = CGFloat((solution?.x)!)*30
            let newY = CGFloat((solution?.y)!)*30
            piece.transform = piece.transform.rotated(by: (CGFloat((solution?.rotations)!))*CGFloat.pi*CGFloat(90)/CGFloat(180))
            if ((solution?.isFlipped)!) {
                piece.transform.scaledBy(x: -1, y: 1)
            }
            piece.frame = CGRect(x: newX, y: newY, width: piece.frame.size.width, height: piece.frame.size.height)
        }
    }
    
    @IBAction func solve(_ sender: Any) {
        movePieces(mainBoardView.image!)
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    

    required init?(coder aDecoder: NSCoder) {
        
        var xStart = 30
        var yStart = 50
        
        var secondRow = false
        var count = 1
        var _pieceViews = [String:UIImageView]()
        
        for (key, gamePiece) in pentominoModel.pieces{
            let aView = UIImageView(piece: gamePiece, x: xStart, y: yStart)
            xStart = xStart + Int(aView.image!.size.width)+30
            if secondRow {
                yStart = yStart + 180
                xStart = 30
                secondRow = false
            }
            if count == 6 {
                secondRow = true
            }
            _pieceViews[key] = aView
            count = count + 1
        }
        pieceViews = _pieceViews
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (_, piece) in pieceViews {
            piecesHomeView.addSubview(piece)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

