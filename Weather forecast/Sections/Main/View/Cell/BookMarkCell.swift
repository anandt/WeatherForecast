//
//  BookMarkCell.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import UIKit

class BookMarkCell: UITableViewCell {
    @IBOutlet weak var bookMarkCity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTableCellData(city: BookMarkPlace?) {
        if let bookMark = city {
            let bookMarkData = (bookMark.city ?? "") + ", " + (bookMark.country ?? "")
            self.bookMarkCity.text = bookMarkData
        }
    }

}
