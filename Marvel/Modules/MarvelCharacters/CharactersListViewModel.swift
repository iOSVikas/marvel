//
//  CharactersListViewModel.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import Foundation

class CharactersListViewModel: NSObject {
    
    //MARK: Required Variable Declaration
    private var _viewController: CharactersListViewController!
    private var maxLimit = -1
    private let pageItemLimit: Int = 20
    var characterList = [result]()
    
    //MARK: Initializer
    init(viewController: CharactersListViewController) {
        super.init()
        self._viewController = viewController
    }
}

//MARK: API Interactor
extension CharactersListViewModel {
    func loadMarvelCaractersList() {
        MarvelServiceCalls.shared.getCharactersList(limit: pageItemLimit, offset: self.characterList.count) { (characters, error) in
            if characters != nil {
                print(characters?.results?.count ?? "")
                if let results = characters?.results,
                    let offset = characters?.offset {
                    self.maxLimit = characters?.total ?? 0
                    self.characterList.append(contentsOf: results)
                    self._viewController.refreshList(from: offset, to: offset + results.count - 1, success: (true  , ""))
                }
            }
            else if let error = error as? MError {
                self._viewController.refreshList(from: 0, to: 0, success: (false, error.localizedDescription))
            }
            else if error != nil {
                self._viewController.refreshList(from: 0, to: 0, success: (false, error?.localizedDescription ?? "Unable to load data"))
            }
        }
    }
}

//MARK: View controller datasource methods
extension CharactersListViewModel {
    func numberOfCharacters() -> Int {
        return self.characterList.count
    }
    
    func characterAt(indexPath: IndexPath) -> result {
        return characterList[indexPath.row]
    }
    
    func reachedLastIndex() -> Bool {
        return maxLimit != -1 && maxLimit <= self.characterList.count
    }
}
