//
//  CharactersListCell.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import UIKit
import Kingfisher


class CharactersListCell: UITableViewCell {

    //MARK: Variable Declaration
    static let reuseIdentifier = "BarChartViewCell"
    
    //MARK: IBOutlet Declaration
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbnailImage.layer.cornerRadius = 8.0
        self.thumbnailImage.clipsToBounds = true
    }
    
    func configure(character: result) {
        self.titleLabel.text = character.name
        if let imageURL = character.imageUrl() {
            self.thumbnailImage.kf.indicatorType = .activity
            self.thumbnailImage.kf.setImage(with: URL(string: imageURL))
        }
        else {
            self.thumbnailImage.image = nil
        }
    }
}
