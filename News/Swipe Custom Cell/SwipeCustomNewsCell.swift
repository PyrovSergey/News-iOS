//
//  SwipeCustomNewsCell.swift
//  News
//
//  Created by Sergey on 01/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
import SwipeCellKit

class SwipeCustomNewsCell: SwipeTableViewCell  {
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articlePublicationTimeLabel: UILabel!
}
