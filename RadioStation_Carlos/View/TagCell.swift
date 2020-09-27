//
//  TagCell.swift
//  RadioStation_Carlos
//
//  Created by cmu on 03/05/2020.
//  Copyright © 2020 UPV. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {
    @IBOutlet weak var lbl_genero: UILabel!
    @IBOutlet weak var lbl_letra: UILabel!
    @IBOutlet weak var lbl_estaciones: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ tag: Tag?) {
        lbl_genero.text = tag!.name.replacingOccurrences(of:"#", with:"").uppercased()
        lbl_letra.text = String(tag!.name.replacingOccurrences(of:"#" , with:"").prefix(1).uppercased())
        lbl_estaciones.text = "Nº Estaciones:  \(tag!.stationcount)"
        print("Nº Estaciones:" + String(tag!.stationcount))
        print(String(tag!.name).replacingOccurrences(of:"#", with:""))
    }

}
