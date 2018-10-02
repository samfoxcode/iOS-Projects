//
//  ParkCollectionViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/30/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ParkCollectionViewController: UICollectionViewController {

    @IBOutlet var parkCollectionView: UICollectionView!
    
    let parkModel = Model.sharedInstance
    let scrollViewManager = ScrollViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return parkModel.lengthOfParks()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parkModel.parkInfoLength(section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParkCollectionCell", for: indexPath) as! ParkCollectionViewCell
    
        // Configure the cell
        let parkName = parkModel.park(indexPath.section)
        let parkImageName = parkName+"0\(indexPath.row+1)"
        let parkImage = UIImage(named: parkImageName)
        cell.parkImageView.image = parkImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! ParkCollectionReusableView
            let parkName = parkModel.park(indexPath.section)
            headerView.parkCollectionHeader.text = parkName
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let view = parkCollectionView {
            //Update collcetion view's frame due to custom cells.
            view.frame.size = size
        }
        if (scrollViewManager.parkImageGlobal != nil) {
            scrollViewManager.scrollViewTransitionUpdate(size)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollViewManager.populateScrollView(indexPath, parkModel, self.view, parkCollectionView, parkCollectionView.cellForItem(at: indexPath))
    }

}
