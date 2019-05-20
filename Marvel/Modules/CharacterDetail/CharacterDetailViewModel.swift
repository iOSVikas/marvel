//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import Foundation


class CharacterDetailViewModel: NSObject {
    
    //MARK: Required Variable Declaration
    private var _viewController: CharacterDetailViewController!
    private var _result: result?
    
    //MARK: Initializer
    init(viewController: CharacterDetailViewController, characterModel: result) {
        super.init()
        self._viewController = viewController
        self._result = characterModel
    }
}

//MARK: API Interactor
extension CharacterDetailViewModel {
    func loadCaracterDetails() {
        if let charId = self._result?.id {
            MarvelServiceCalls.shared.getCharactersDetails(charID: charId) { (character, error) in
                if let characterObject = character {
                    if characterObject.results?.count ?? 0 > 0 {
                        self._result = characterObject.results?[0]
                        self._viewController.setDisplayFrom(character: self._result!)
                    }
                }
                else if let error = error as? MError {
                    self._result = nil
                    self._viewController.clearDisplayValues(message: error.localizedDescription)
                }
                else if error != nil {
                    self._result = nil
                    self._viewController.clearDisplayValues(message: error?.localizedDescription ?? "Unable to load data")
                }
            }
        }
        else {
            self._viewController.clearDisplayValues(message: "Not able to find details for selected character.")
        }
    }
}

//MARK: View controller datasource methods
extension CharacterDetailViewModel {
    func numberOfSections() -> Int {
        return self._result != nil ? 3 : 0
    }
    
    func numberOfRowsAt(section: Int) -> Int {
        switch section {
        case 0:
            return self._result?.comics?.items?.count ?? 0
        case 1:
            return self._result?.series?.items?.count ?? 0
        case 2:
            return self._result?.stories?.items?.count ?? 0
        default:
            return 0
        }
    }
    
    func titleFor(section: Int) -> String {
        switch section {
        case 0:
            return "COMICS"
        case 1:
            return "SERIES"
        case 2:
            return "STORIES"
        default:
            return ""
        }
    }
    
    func characterAt(indexPath: IndexPath) -> items? {
        
        switch indexPath.section {
        case 0:
            let item = self._result?.comics?.items?[indexPath.row]
            return item
        case 1:
            let item = self._result?.series?.items?[indexPath.row]
            return item
        case 2:
            let item = self._result?.stories?.items?[indexPath.row]
            return item
        default:
            return nil
        }
    }
}
