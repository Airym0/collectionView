//
//  SectionHeaderView.swift
//  CollectionView
//
//  Created by lpiem on 16/03/2022.
//

import UIKit

class SectionHeaderView : UICollectionReusableView {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    var categoryTitle : String! {
        didSet {
            categoryTitleLabel.text = categoryTitle
        }
    }
}
