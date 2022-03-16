//
//  Landmark.swift
//  CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import Foundation
import UIKit
import MapKit

struct Landmark : Decodable, Hashable {
    
    struct Coordinates : Decodable, Hashable {
        let latitude: Double
        let longitude: Double
    }
    
    enum Category: String, CaseIterable, Decodable {
        case lakes = "Lakes"
        case montains = "Mountains"
        case rivers = "Rivers"
    }
    
    let name: String
    let category: Category
    let city: String
    let state: String
    let id: Int
    let isFavorite: Bool
    let isFeatured: Bool
    let description: String
    private let imageName: String
    private let coordinates: Coordinates
    var image: UIImage {
        return UIImage(named: imageName)!
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
        
}
