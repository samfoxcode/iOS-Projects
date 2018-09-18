//
//  HintViewController.swift
//  Pentominoes Game
//
//  Created by Samuel Fox on 9/17/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class HintViewController: UIViewController {

    @IBOutlet var hintBoardView: UIImageView!
    var image = UIImage()
    var index = 0
    let hintPentominoModel = Model()
    var pieces = [String:UIImageView]()
    let kScalePieceForBoard : CGFloat = 30
    var hintCount = 0
    
    func setHintImage(_ image: UIImage) {
        self.image = image
    }
    func setHintIndex(_ index: Int) {
        self.index = index
    }
    func setHintViews(_ views: [String:UIImageView]){
        self.pieces = views
    }
    func setHintCount(_ hintCount: Int) {
        self.hintCount = hintCount
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hintBoardView.image = self.image
        var count = 0
        print(pieces)
        for (key, piece) in pieces {
            
            if count >= hintCount {
                break
            }
            // Get solution for single piece for specific board.
            let solution = hintPentominoModel.getSolution(index, key)
            
            let newX = CGFloat((solution?.x)!)*kScalePieceForBoard
            let newY = CGFloat((solution?.y)!)*kScalePieceForBoard
            let radians = (CGFloat((solution?.rotations)!)*CGFloat.pi*CGFloat(90))/CGFloat(180)
            piece.center = hintBoardView.convert(piece.center, from: piece.superview)
            
            UIView.animate(withDuration: 1, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                piece.transform = CGAffineTransform(rotationAngle: radians)
                if ((solution?.isFlipped)!) {
                    piece.transform = piece.transform.scaledBy(x: -1, y: 1)
                }
                self.hintBoardView.addSubview(piece)
                piece.frame = CGRect(x: newX, y: newY, width: piece.frame.size.width, height: piece.frame.size.height)
            })
            count = count + 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
