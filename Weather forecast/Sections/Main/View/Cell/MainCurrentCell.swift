//
//  MainCurrentCell.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import UIKit
import MapKit
class MainCurrentCell: UITableViewCell {
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var currentType: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var looksLike: UILabel!
    @IBOutlet weak var weatherInfo: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setTableCellData(information: LocationInformation?, forcast: TodayWeather?) {
        if let locationInfo = information {
            self.area.text = locationInfo.city
            self.currentType.text = "Current Location"
            self.temperatureLabel.text = ""
        }
        
        let imageName = WFUtility.setImageIImageName(image: WFUtility.imageToShow() )
        self.backImageView.image = UIImage(named: imageName ?? "")
        if let forcastData = forcast {
            temperatureLabel.text =  WFUtility.convertIntoTemp(temp: forcastData.main.temp)
            let feelsLikeText = WFUtility.convertIntoTemp(temp: forcastData.main.feels_like)
            looksLike.text = "Feel like \(feelsLikeText)"
            
            dateLabel.text = WFUtility.getCurrentDateTime()
            humidityLabel.text = "\(String(describing: forcast?.main.humidity ?? 0)) %"
            windLabel.text = "\(String(describing: forcast?.wind.speed ?? 0)) m/s"
            
            timeLabel.text = WFUtility.getCurrentTime()
            
            let sunrise = WFUtility.convertSecondsToTime(seconds: forcast?.sys.sunrise ?? 0)
            let sunset = WFUtility.convertSecondsToTime(seconds: forcast?.sys.sunset ?? 0)
            sunriseLabel.text = "\(String(describing: sunrise))"
            sunsetLabel.text = "\(String(describing: sunset))"
            
            if ((forcast?.weather.indices.contains(0)) != nil) {
                weatherInfo.text = forcast?.weather[0].description
            }
        }
    }
}
