//
//  HintViewController.swift
//  Pentominoes Game
//
//  Created by Samuel Fox on 9/17/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

protocol HintDelegate {
    func dismiss()
}

class HintViewController: UIViewController {

    @IBOutlet var hintBoardView: UIImageView!
    var image = UIImage()
    var index = 0
    let hintPentominoModel = Model()
    var pieces = [String:UIImageView]()
    let kScalePieceForBoard : CGFloat = 30
    var hintCount = 0
    var delegate : HintDelegate?
    
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
    
    @IBAction func dismissHint(_ sender: Any) {
        delegate?.dismiss()
    }
    
    func solveHintPieceHelper(_ piece: UIView, _ key: String) {
        // Get solution for single piece for specific board.
        let solution = hintPentominoModel.getSolution(index, key)
        
        let newX = CGFloat((solution?.x)!)*kScalePieceForBoard
        let newY = CGFloat((solution?.y)!)*kScalePieceForBoard
        let radians = (CGFloat((solution?.rotations)!)*CGFloat.pi*CGFloat(90))/CGFloat(180)
        piece.center = hintBoardView.convert(piece.center, from: piece.superview)
        piece.transform = CGAffineTransform(rotationAngle: radians)
        if ((solution?.isFlipped)!) {
            piece.transform = piece.transform.scaledBy(x: -1, y: 1)
        }
        self.hintBoardView.addSubview(piece)
        piece.frame = CGRect(x: newX, y: newY, width: piece.frame.size.width, height: piece.frame.size.height)
    }
    
    func solveHint() {
        var count = 0
        for (key, piece) in pieces {
            if count >= hintCount {
                break
            }
            solveHintPieceHelper(piece, key)
            count = count + 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hintBoardView.image = self.image
        solveHint()
    }


}
