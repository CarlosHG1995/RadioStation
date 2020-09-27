//
//  StationCell.swift
//  RadioStation_Carlos
//
//  Created by cmu on 06/05/2020.
//  Copyright © 2020 UPV. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {

    @IBOutlet weak var image_emi: UIImageView!
    @IBOutlet weak var lbl_nombre: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup_emisora_list(_ station: Station?) {
        lbl_nombre.text = station?.name.replacingOccurrences(of:"#", with:"").uppercased()
        //let imagen = UIImage(named: "cartoon-radio.jpg")
        
        //image_emi.image = imagen
        //image_emi.contentMode = UIView.ContentMode.scaleAspectFit
        image_emi.imageFromURL(url: station?.favicon ?? "", defaultImage: "cartoon-radio")
    }

}
