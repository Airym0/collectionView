//
//  JsonHelper.swift
//  CollectionView
//
//  Created by lpiem on 16/03/2022.
//

import Foundation

class JsonHelper : NSObject {
    
    static let sharedJsonHelper = JsonHelper()
    
    func parse(jsonData: Data) -> [Landmark] {
        do {
            let decodedData = try JSONDecoder().decode([Landmark].self,
                                                       from: jsonData)
            for data in decodedData{
                print("Title: ", data.name)
            }
            return decodedData
        } catch {
            print("decode error")
            return []
        }
    }
    
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}
