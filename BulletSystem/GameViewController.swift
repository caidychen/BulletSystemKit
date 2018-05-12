//
//  GameViewController.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 9/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum ConfigOption: Int {
    case GunBarrels = 0
    case Interval   = 1
    case Accuracy   = 2
    case Pattern    = 3
    case Duration   = 4
    case Delay      = 5
    case Uptime     = 6
    case Downtime   = 7
    case Accelerate = 8
}

class GameViewController: UIViewController {

    @IBOutlet weak var gameView: SKView!
    
    @IBOutlet weak var sliderView: UIView!{
        didSet{
            sliderView.isHidden = true
        }
    }
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var sliderTItleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var gunBarrelButton: UIButton!
    @IBOutlet weak var IntervalButton: UIButton!
    @IBOutlet weak var accuracyButton: UIButton!
    @IBOutlet weak var patternButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var durationButton: UIButton!
    @IBOutlet weak var delayButton: UIButton!
    @IBOutlet weak var uptimeButton: UIButton!
    @IBOutlet weak var downtimeButton: UIButton!
    @IBOutlet weak var accelerateButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    private var patternIndex = 0 {
        didSet{
            switch patternIndex {
            case 0:
                patternValue = .SingleDirectional
                patternText = "Single-Directional"
            case 1:
                patternValue = .ArcDirectional(fullAngle: 120)
                patternText = "Arc-Directional"
            case 2:
                patternValue = .Circular
                patternText = "Circular"
            default:
                break
            }
            updateBSKConfig()
        }
    }
    private var patternText = ""
    private var gunBarrelValue: Int = 5
    private var intervalValue: CFTimeInterval = 0.1
    private var accuracyValue: CGFloat = 0.95
    private var patternValue: BSKPattern = .ArcDirectional(fullAngle: 120)
    private var duration: CFTimeInterval = 5.0
    private var delay: CFTimeInterval = 0.1
    private var uptime: CFTimeInterval = 0.5
    private var downtime: CFTimeInterval = 0.5
    private var accelerate: CGFloat = 0.0
    private var selectedOption: ConfigOption = ConfigOption(rawValue: 0)!
    
    let scene = GameScene(size: UIScreen.main.bounds.size)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.gameView!
        skView.isMultipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        patternIndex = 0
        updateButtonTitle()
    }
    
    @IBAction func optionButtonTapped(sender: UIButton){
        if sender.tag == ConfigOption.Pattern.rawValue {
            if patternIndex == 2 {
                patternIndex = 0
            } else {
                patternIndex += 1
            }
            updateButtonTitle()
            return
        }
        sliderView.isHidden = false
        stackView.isHidden = true
        setupSlider(with: ConfigOption(rawValue: sender.tag)!)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        sliderView.isHidden = true
        stackView.isHidden = false
    }
    
    func setupSlider(with option: ConfigOption) {
        selectedOption = option
        switch option {
        case .GunBarrels:
            slider.minimumValue = 1
            slider.maximumValue = 100
            slider.value = Float(gunBarrelValue)
            sliderTItleLabel.text = "Number Of Gun Barrels"
            break
        case .Interval:
            slider.minimumValue = 0
            slider.maximumValue = 5
            slider.value = Float(intervalValue)
            sliderTItleLabel.text = "Fire Interval"
            break
        case .Accuracy:
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.value = Float(accuracyValue)
            sliderTItleLabel.text = "Fire Accuracy"
            break
        case .Duration:
            slider.minimumValue = 0
            slider.maximumValue = 20
            slider.value = Float(duration)
            sliderTItleLabel.text = "Travel Duration"
            break
        case .Delay:
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.value = Float(delay)
            sliderTItleLabel.text = "Travel Delay"
            break
        case .Uptime:
            slider.minimumValue = 0
            slider.maximumValue = 10
            slider.value = Float(uptime)
            sliderTItleLabel.text = "Up Time"
            break
        case .Downtime:
            slider.minimumValue = 0
            slider.maximumValue = 10
            slider.value = Float(downtime)
            sliderTItleLabel.text = "Down Time"
            break
        case .Accelerate:
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.value = Float(accelerate)
            sliderTItleLabel.text = "Vector Acceleration"
            break
        default:
            break
        }
        
        sliderValueChanged(slider)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let newValue = sender.value
        sliderValueLabel.text = String(format: "%.2f", newValue)
        switch selectedOption {
        case .GunBarrels:
            gunBarrelValue = Int(newValue)
        case .Interval:
            intervalValue = CFTimeInterval(newValue)
        case .Accuracy:
            accuracyValue = CGFloat(newValue)
        case .Duration:
            duration = CFTimeInterval(newValue)
        case .Delay:
            delay = CFTimeInterval(newValue)
        case .Uptime:
            uptime = CFTimeInterval(newValue)
        case .Downtime:
            downtime = CFTimeInterval(newValue)
        case .Accelerate:
            accelerate = CGFloat(newValue)
        default:
            break
        }
        updateBSKConfig()
        updateButtonTitle()
    }
    
    
    @IBAction func sliderTouchUp(_ sender: Any) {
        scene.resetBSKSystem()
    }
    
    private func updateBSKConfig() {
        scene.bskConfig.numberOfGunBarrel = gunBarrelValue
        scene.bskConfig.fireInterval = intervalValue
        scene.bskConfig.fireAccuracy = accuracyValue
        scene.bskConfig.travelDuration = duration
        scene.bskConfig.visbileDelay = delay
        scene.bskConfig.bulletPattern = patternValue
        scene.bskConfig.vectorAcceleration = accelerate
        scene.bskConfig.gateControl = BSKGateControl(uptime: uptime, downtime: downtime)
        
    }
    
    private func updateButtonTitle() {
        gunBarrelButton.setTitle("Gun Barrels: \(gunBarrelValue)", for: .normal)
        IntervalButton.setTitle("Interval: \(String(format: "%.2f", intervalValue))", for: .normal)
        accuracyButton.setTitle("Accuracy: \(String(format: "%.2f", accuracyValue))", for: .normal)
        durationButton.setTitle("Duration: \(String(format: "%.2f", duration))", for: .normal)
        delayButton.setTitle("Delay: \(String(format: "%.2f", delay))", for: .normal)
        uptimeButton.setTitle("Uptime: \(String(format: "%.2f", uptime))", for: .normal)
        downtimeButton.setTitle("Downtime: \(String(format: "%.2f", downtime))", for: .normal)
        accelerateButton.setTitle("Acc: \(String(format: "%.2f", accelerate))", for: .normal)
        patternButton.setTitle(patternText, for: .normal)
    }
    
}
