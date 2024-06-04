//
//  WaterWaveView.swift
//  PrernaUnionBank
//
//  Created by Neosoft on 24/05/23.
//

import Foundation
import UIKit


class WaterWaveView: UIView {

    
    private let firstLayer = CAShapeLayer()
    private let secondLayer = CAShapeLayer()
    
    private var firstColor: UIColor = .clear
    private var secondColor: UIColor = .clear
    
    private let percentLabel = UILabel()
    
    private var twoPI: CGFloat = .pi*2
    private var offset:  CGFloat = 0.0
    
    private let width = UIScreen.main.bounds.width - 100.0
    
    var showSinglWave = false
    private var start = false
    
    var progress: CGFloat = 0.3
    var waveHeight: CGFloat = 0.0
     let waterWaveFirstColor = UIColor(hexCode: "#D8F1FD")
     let waterWaveSecondColor = UIColor(hexCode: "#B5E5FB")
    var waterVal = "Test"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension WaterWaveView {
    
    private func setupViews() {
        bounds = CGRect(x: 0.0, y: 0.0, width: min(width, width), height: min(width, width))
        clipsToBounds = true
        backgroundColor = .clear
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        
        waveHeight = 8.0
        
        firstColor = waterWaveFirstColor
        secondColor = waterWaveSecondColor
        
        createFirstLayer()
        
        if !showSinglWave {
            createSecondLayer()
        }
        createPercentLabel()
    }
    
    private func createFirstLayer() {
        firstLayer.frame = bounds
        firstLayer.anchorPoint = .zero
        firstLayer.fillColor = firstColor.cgColor
        layer.addSublayer(firstLayer)
    }
    
    private func createSecondLayer() {
        secondLayer.frame = bounds
        secondLayer.anchorPoint = .zero
        secondLayer.fillColor = secondColor.cgColor
        layer.addSublayer(secondLayer)
    }
    
    private func createPercentLabel() {
        percentLabel.font = .boldSystemFont(ofSize: 40)//UIFont.latoBold(ofSize: 46)
        percentLabel.textAlignment = .center
        percentLabel.textColor = .white
        percentLabel.text = ""
        addSubview(percentLabel)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    }
    
    func setUpProgress(_ pr: CGFloat, waterValue: String? = nil) {
        
        progress = pr
        percentLabel.text = waterValue
        let top: CGFloat = pr * bounds.size.height
        
        firstLayer.setValue(width-top, forKeyPath: "position.y")
        secondLayer.setValue(width-top, forKeyPath: "position.y")
        
        if !start {
            DispatchQueue.main.async {
                self.startAnim()
            }
        }
    }
    
    private func startAnim() {
        start = true
        waterWaveAnim()
    }
    
    private func waterWaveAnim() {
        let w = bounds.size.width
        let h = bounds.size.height
        
        let bezier = UIBezierPath()
        let path = CGMutablePath()
        
        let startOffesetY = waveHeight * CGFloat(sinf(Float(offset * twoPI / w )))
        var originOffsetY: CGFloat = 0.0
        
        path.move(to: CGPoint(x: 0.0, y: startOffesetY), transform: .identity)
        bezier.move(to: CGPoint(x: 0.0, y: startOffesetY))
        
        for i in stride(from: 0.0, to: w*1000, by: 1) {
            originOffsetY = waveHeight * CGFloat(sinf(Float(twoPI / w * i + offset * twoPI / w)))
            bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
         }
        
        bezier.addLine(to: CGPoint(x: w*1000, y: originOffsetY))
        bezier.addLine(to: CGPoint(x: w*1000, y: h))
        bezier.addLine(to: CGPoint(x: 0.0, y: h))
        bezier.addLine(to: CGPoint(x: 0.0, y: startOffesetY))
        bezier.close()
        
        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.duration = 2.0
        anim.fromValue = -w*0.5
        anim.toValue = -w - w*0.5
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        
        firstLayer.fillColor = firstColor.cgColor
        firstLayer.path = bezier.cgPath
        firstLayer.add(anim, forKey: nil)
        
        if !showSinglWave {
            
            let bezier = UIBezierPath()
            
            let startOffesetY = waveHeight * CGFloat(sinf(Float(offset * twoPI / w )))
            var originOffsetY: CGFloat = 0.0
            
             bezier.move(to: CGPoint(x: 0.0, y: startOffesetY))
            
            for i in stride(from: 0.0, to: w*1000, by: 1) {
                originOffsetY = waveHeight * CGFloat(cosf(Float(twoPI / w * i + offset * twoPI / w)))
                bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
            }
            
            bezier.addLine(to: CGPoint(x: w*1000, y: originOffsetY))
            bezier.addLine(to: CGPoint(x: w*1000, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: startOffesetY))
            bezier.close()
            
            secondLayer.fillColor = secondColor.cgColor
            secondLayer.path = bezier.cgPath
            secondLayer.add(anim, forKey: nil)
        }
    }
    
}
