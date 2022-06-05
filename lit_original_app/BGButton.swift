//
//  BGButton.swift
//  lit_original_app
//
//  Created by MASANAO on 2022/05/25.
//

import UIKit

@IBDesignable
class BGButton: UIButton {

    var gradientLayer = CAGradientLayer()

    @IBInspectable var startColor: UIColor = UIColor.white {
        didSet {
            setGradient()
        }
    }

    @IBInspectable var endColor: UIColor = UIColor.black {
        didSet {
            setGradient()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            setGradient()
        }
    }

    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0.5) {
        didSet {
            setGradient()
        }
    }

    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            setGradient()
        }
    }

    private func setGradient() {

        gradientLayer.removeFromSuperlayer()

        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.frame.size = frame.size
        gradientLayer.frame.origin = CGPoint.init(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.zPosition = -100
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.masksToBounds = true

        imageView?.layer.zPosition = 0

    }

}
