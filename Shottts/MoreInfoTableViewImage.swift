//
//  MoreInfoTableViewImage.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/12/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

class MoreInfoTableViewImage: UITableViewHeaderFooterView {
    
    @IBOutlet weak var moreInfoImages: UIImageView!
    
    override func awakeFromNib() {
        
        moreInfoImages.image = moreInfoImage;
        
    }
    
}