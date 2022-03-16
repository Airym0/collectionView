//
//  ViewController.swift
//  CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class AcceuilViewController: UICollectionViewController {
    
    enum Section : CaseIterable {
        case main
        case lakes
        case mountains
        case rivers
    }
    
    enum Item: Hashable {       
        case fav(Landmark)
        case cat(Landmark)
    }
    
    var diffableDataSource : UICollectionViewDiffableDataSource<Section, Item>!
    
    private var landmarks : [Landmark] = []
    private var names : [String] = []
    private var vc : SearchTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landmarks = JsonHelper.sharedJsonHelper.parse(jsonData: JsonHelper.sharedJsonHelper.readLocalFile(forName: "landmarkData")!)
        configureDataSource()
        collectionView.collectionViewLayout = createLayout()
        reloadList(landmarks: landmarks)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        vc = (storyboard.instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController)
        
        for landmark in landmarks {
            names.append(landmark.name)
        }
        
        let searchController = UISearchController(searchResultsController: vc)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    
    private func configureDataSource(){
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .fav(let landmark):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as! FavLandmarkCollectionViewCell
                cell.configure(landmark: landmark)
                return cell
            case .cat(let landmark):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCell", for: indexPath) as! CatLandmarkCollectionViewCell
                cell.configure(landmark: landmark)
                return cell
            }
        })
        
        diffableDataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: "header", for: indexPath) as! SectionHeaderView
            
            guard let section = self.diffableDataSource.sectionIdentifier(for: indexPath.section) else {
                return nil
            }
            
            switch section {
            case .rivers:
                sectionHeaderView.categoryTitle = "Rivières"
            case .main:
                sectionHeaderView.categoryTitle = "Favoris"
            case .lakes:
                sectionHeaderView.categoryTitle = "Lacs"
            case .mountains:
                sectionHeaderView.categoryTitle = "Montagnes"
            }
            
            return sectionHeaderView
            
        }
        
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        let favItems = landmarks.filter { $0.isFavorite }.map { landmark in
            return Item.fav(landmark)
        }
        snapshot.appendItems(favItems, toSection: .main)
        
        let lakeItems = landmarks.filter { $0.category == .lakes }.map { landmark in
            return Item.cat(landmark)
        }
        snapshot.appendItems(lakeItems, toSection: .lakes)
        
        let mountainsItems = landmarks.filter { $0.category == .montains }.map { landmark in
            return Item.cat(landmark)
        }
        snapshot.appendItems(mountainsItems, toSection: .mountains)
        
        let riversItems = landmarks.filter { $0.category == .rivers }.map { landmark in
            return Item.cat(landmark)
        }
        snapshot.appendItems(riversItems, toSection: .rivers)
        return snapshot
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PlaceDetailsViewController
        let cell = sender as! UICollectionViewCell
        guard let index = collectionView.indexPath(for: cell),
              let item = diffableDataSource.itemIdentifier(for: index) else {
                  return
              }
        switch item {
        case .fav(let landmark), .cat(let landmark):
            destination.landmark = landmark
        }
    }
    
    private func reloadList(landmarks:[Landmark]){
        let snapshot = createSnapshot()
        diffableDataSource.apply(snapshot)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, collectionLayoutEnvironment in
            guard let self = self,
                  let section = self.diffableDataSource.sectionIdentifier(for: sectionIndex) else {
                return nil
            }
            switch section {
            case .main:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                return section
            case .lakes, .mountains, .rivers :
                return self.createSectionCategory()
            }
            
        }
        
        return layout
    }
    
    private func createSectionCategory() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        
        return section
    }

}

extension AcceuilViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else {
            vc.reloadList(names: names)
            return
        }
        let filteredNames = names.filter { name in
            return name.localizedCaseInsensitiveContains(searchQuery)
        }
        
        vc.reloadList(names: filteredNames)
    }
}



