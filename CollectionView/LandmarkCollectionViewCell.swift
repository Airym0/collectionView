//
//  LandmarkCollectionViewCell.swift
//  CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class FavLandmarkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var landmarkImage: UIImageView!
    
    var landmark: Landmark!
    
    func configure(landmark: Landmark){
        self.landmark = landmark
        title.text = landmark.name
        landmarkImage.layer.cornerRadius = 20
        landmarkImage.image = landmark.image
    }
    
}
