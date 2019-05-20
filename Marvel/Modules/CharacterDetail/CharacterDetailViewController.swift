//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterDetailViewController: UIViewController {

    //MARK: Required Variable Declaration
    static let identifire = "CharacterDetailViewController"
    private var viewModel: CharacterDetailViewModel!
    
    //MARK: IBOutltes
    @IBOutlet weak var headerHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackContainerView: UIStackView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var marvelCollectionView: UICollectionView!
    
    //MARK: Static Class Initializer
    static func create(storyboard: UIStoryboard, characterModel: result) -> CharacterDetailViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: CharacterDetailViewController.identifire) as! CharacterDetailViewController
        viewController.viewModel = CharacterDetailViewModel(viewController: viewController, characterModel: characterModel)
        
        viewController.title = characterModel.name
        return viewController
    }
    
    //MARK: Controller Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setbackButton()
        self.loadCharacterDetail()
        self.setupCollectionView()
        self.updateHeaderFrame()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateHeaderFrame()
    }
}

//MARK: Supporting functions
extension CharacterDetailViewController {
    
    func updateHeaderFrame() {
        if UIDevice.current.orientation.isLandscape {
            stackContainerView.axis = .horizontal
        } else {
            stackContainerView.axis = .vertical
        }
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.marvelCollectionView.reloadData()
        })
    }
    
    func setbackButton() {
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "Navigation_Back"), style: .done, target: self, action: #selector(self.didSelectBackButton))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func didSelectBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupCollectionView() {
        
        marvelCollectionView.register(UINib(nibName: "CharacterDetailCell", bundle: nil), forCellWithReuseIdentifier: CharacterDetailCell.reuseIdentifier)
        
        self.marvelCollectionView.delegate = self
        self.marvelCollectionView.dataSource = self
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            self.didSelectBackButton()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK - ViewModel Interactor methods
extension CharacterDetailViewController {
    func loadCharacterDetail() {
        self.viewModel.loadCaracterDetails()
    }
    
    func setDisplayFrom(character: result) {
        headerImageView.image = UIImage(named: "BannerPlaceholder")
        if let imageURL = character.imageUrl() {
            headerImageView.kf.indicatorType = .activity
            headerImageView.kf.setImage(with: URL(string: imageURL))
        }
        titleLabel.text = character.name
        descriptionLabel.text = character.description
        marvelCollectionView.reloadData()
    }
    
    func clearDisplayValues(message: String) {
        headerImageView.image = UIImage(named: "BannerPlaceholder")
        titleLabel.text = ""
        descriptionLabel.text = ""
        marvelCollectionView.reloadData()
        self.showAlert(title: "Marvels!", message: message)
    }
}

//MARK: UICollectionView Delegate and Datasource
extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsAt(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartHeaderCollectionReusableView", for: indexPath)
            for view in headerView.subviews {
                view.removeFromSuperview()
            }
            let label = UILabel(frame: CGRect(x: 20, y: 20, width: collectionView.frame.width - 10, height: 40))
            label.textColor = .red
            label.font = UIFont.boldSystemFont(ofSize: 19)
            label.text = viewModel.titleFor(section: indexPath.section)
            headerView.addSubview(label)
            
            // Customize headerView here
            return headerView
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailCell.reuseIdentifier, for: indexPath) as! CharacterDetailCell
        if let item = self.viewModel.characterAt(indexPath: indexPath) {
            cell.configure(item: item)
        }
        return cell

    }
}

extension CharacterDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(UIDevice.current.orientation.isLandscape) {
            let width = (collectionView.frame.width-30)/3
            return CGSize(width: width, height: width*1.20)
        }
        else {
            let width = (self.view.frame.width-30)/3
            return CGSize(width: width, height: width*1.20)
        }
    }
}



