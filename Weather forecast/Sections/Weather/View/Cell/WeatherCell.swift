//
//  WeatherCell.swift
//  Weather forecast
//
//  Created by TSHYDLOFC00110 on 13/06/21.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsutLabel: UILabel!
    @IBOutlet weak var windInfoLabel: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(forcastData: List?, city: City) {
        if let data = forcastData {
            
            
            let currentDate = WFUtility.getCurrentDateTime()
            let dateToDisplay = WFUtility.convertSecondsToDateForConversion(seconds: Double(data.dt))
            if currentDate == dateToDisplay {
                dateLabel.text = "Today"
            } else {
                dateLabel.text = dateToDisplay
            }
            
            
            temperatureLabel.text = WFUtility.convertIntoTemp(temp: data.main.temp)
            
            
            let feelsLikeText = WFUtility.convertIntoTemp(temp: data.main.feels_like)
            feelsLikeLabel.text = "Feels like \(feelsLikeText)"
            if data.weather.count > 0 {
                descriptionLabel.text = data.weather[0].description
            }
            humidityLabel.text = "\(String(describing: data.main.humidity))%"

            let sunrise = WFUtility.convertSecondsToTime(seconds: Double(city.sunrise ))
            let sunset = WFUtility.convertSecondsToTime(seconds: Double(city.sunset))
            sunriseLabel.text = "\(String(describing: sunrise))"
            sunsutLabel.text = "\(String(describing: sunset))"
            windInfoLabel.text = "\(String(describing: data.wind.speed)) m/s"
        }
    }

}
