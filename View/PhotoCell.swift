//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Sean Leu on 2/8/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    var activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
