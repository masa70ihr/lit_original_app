//
//  PostTableViewCell.swift
//  lit_original_app
//
//  Created by MASANAO on 2022/06/05.
//

protocol CustomCellDelegate {
    func didTapOption1Button(sender: UIButton, cell: PostTableViewCell)
    func didTapOption2Button(sender: UIButton, cell: PostTableViewCell)
}

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var delegate: CustomCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
//    @IBOutlet var optionButtonArray: [UIButton] = []
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func option1ButtonTapped(_ sender: Any) {
        delegate?.didTapOption1Button(sender: self.option1Button, cell: self)
    }
    
    
    @IBAction func option2ButtonTapped(_ sender: Any) {
        delegate?.didTapOption2Button(sender: self.option2Button, cell: self)
    }
}
