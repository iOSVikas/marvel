//
//  CharacterDetailCell.swift
//  Marvel
//
//  Created by Vikas on 5/20/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import UIKit

class CharacterDetailCell: UICollectionViewCell {
    
    //MARK: Variable Declaration
    static let reuseIdentifier = "CharacterDetailCell"

    //MARK: IBOutlet Declaration
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 8.0
        self.containerView.clipsToBounds = true
    }
    
    func configure(item: items) {
        self.titleLabel.text = item.name
    }

}
