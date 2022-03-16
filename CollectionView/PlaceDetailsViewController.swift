//
//  PlaceDetailsViewController.swift
//  CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    var landmark: Landmark!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        if let landmark = landmark {
            self.title = landmark.name
            imageView.image = landmark.image
            latitude.text = landmark.locationCoordinate.latitude.description
            longitude.text = landmark.locationCoordinate.longitude.description
            desc.text = landmark.description
        }
    }

}

