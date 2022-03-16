//
//  ViewController.swift
//  DiffableDataSource_SampleCode
//
//  Created by Quentin Genevois on 09/03/2022.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case name(String)
    }
    
    private var landmarks : [Landmark] = []
    private var names : [String] = []
    
    private var diffableDataSource: UITableViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
              
        landmarks = JsonHelper.sharedJsonHelper.parse(jsonData: JsonHelper.sharedJsonHelper.readLocalFile(forName: "landmarkData")!)
        //Create DataSource
        diffableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .name(let value):
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = value
                return cell
            }
        })
        for landmark in landmarks {
            names.append(landmark.name)
        }
        reloadList(names: names)
    }
    
    public func reloadList(names: [String]) {
        let snapshot = createSnapshot(names: names)
        diffableDataSource.apply(snapshot)
    }
    
    private func createSnapshot(names: [String]) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.main])
        
        let items = names.map(Item.name)
        snapshot.appendItems(items, toSection: Section.main)
        return snapshot
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = diffableDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        switch item {
        case .name(let value):
            print(#function, indexPath, value)
        }
    }
}
