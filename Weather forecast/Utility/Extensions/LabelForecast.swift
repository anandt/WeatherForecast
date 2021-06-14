//
//  ForecastLabel.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//
import UIKit

class LabelForecast: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        let image = WFUtility.imageToShow()
        var fontColor = UIColor.black
        switch image {
        case Day.Morning:
            fontColor = UIColor.apgrayColor
        case Day.Afternoon:
            fontColor = UIColor.white
        case Day.Evening:
            fontColor = UIColor.apgrayColor
        default:
            fontColor = UIColor.white
        }
        self.textColor = fontColor
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    public override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}
