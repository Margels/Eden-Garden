//
//  ViewController.swift
//  Eden Garden
//
//  Created by Martina on 19/05/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    // loading screen
    var loadingLabel: UILabel = {
        let l = UILabel()
        // text
        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        l.textColor = .label
        l.numberOfLines = 0
        l.textAlignment = .center
        l.text = "loading..."
        // position
        l.frame = CGRect(x: 20,
                         y: 300,
                         width: UIScreen.main.bounds.width-40,
                         height: 100)
        // shadow
        l.layer.shadowRadius = 5
        l.layer.shadowColor = UIColor.black.cgColor
        l.layer.shadowOffset = CGSize.zero
        l.layer.shadowOpacity = 0.5
        return l
    }()
    
    // blur view behind loading scren
    lazy var blurry: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()

    // strings to show on loading
    var randomStrings = [
        
        "Picking flowers from Eden Garden...",
        "Making flower crowns for nymphs...",
        "Spreading petals along the lake...",
        "Smelling cherry blossoms off a tree...",
        "Blowing poplar fluff in the wind...",
        "Painting orchids baby blue...",
        "Watching the lotus floating in the pond...",
        "Clipping daisies in my hair...",
        "Caressing young doves...",
        "Singing spring songs with the nightingale...",
        "Catching the treasure at the end of the rainbow...",
        "Napping on a cloud...",
        "Sipping tea with a wood fairy..."
    
    ]
    
    
    @IBOutlet var whatchuDoinButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button formatting
        self.whatchuDoinButton.layer.cornerRadius = self.whatchuDoinButton.frame.height / 2
        self.whatchuDoinButton.layer.shadowRadius = 25
        self.whatchuDoinButton.layer.shadowColor = UIColor.black.cgColor
        self.whatchuDoinButton.layer.shadowOffset = CGSize.zero
        self.whatchuDoinButton.layer.shadowOpacity = 0.75
        
    }
    
    
    
    
    func blurView(completion: @escaping (_ success: Bool) -> ()) {
        
        // check that users settings allow blur view
        if !UIAccessibility.isReduceTransparencyEnabled {
            
            // add subview and bring to front
            self.view.addSubview(blurry)
            self.view.bringSubviewToFront(blurry)
            
            // animate the view
            UIView.animate(withDuration: 1) {
                self.blurry.alpha = 0.75
                completion(true)
                }
            }
        }
    
    
    func loadingScreen(animating: Bool) {
        
        // if loading screen is on
        if animating == true {
            
            // use system circle hexagon grid images as circles
            let img1 = UIImage(systemName: "circle.hexagongrid")
            let img2 = UIImage(systemName: "circle.hexagongrid.fill")
            
            DispatchQueue.main.async {
            
                // add the label
                self.loadingLabel.translatesAutoresizingMaskIntoConstraints = true
                self.view.contains(self.loadingLabel) ? self.loadingLabel.isHidden = false :  self.view.addSubview(self.loadingLabel)
                self.labelText()
                
                // add the circles
                let iv1 = UIImageView(image: img1)
                let iv2 = UIImageView(image: img2)
                let images = [iv1, iv2]
                var i = 100
                iv1.alpha = 0
                
                // set up both images at once
                for image in images {
                    
                    // give a tag to the image view so you can find it and remove it later
                    i += 1
                    image.tag = i
                    
                    // set the circles position
                    let hw: CGFloat = 200
                    image.frame = CGRect(x: UIScreen.main.bounds.width/2 - hw/2,
                                         y: 100,
                                         width: hw,
                                         height: hw)
                    image.contentMode = .scaleAspectFill
                    
                    // set the circles colors
                    if #available(iOS 15.0, *) {
                        image.tintColor = (image.image == img1 ? .systemMint : .systemPink)
                    } else {
                        image.tintColor = (image.image == img1 ? .systemGreen : .systemRed)
                    }
                    
                    // add to the view
                    self.view.addSubview(image)
                    
                    // rotation animation
                    UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .curveLinear]) {
                        image.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    }
                    
                    
                    
                }
                
                // add blur view
                self.blurView { success in
                    
                    // bring the circles in front of the blurred view
                    self.view.bringSubviewToFront(iv1)
                    self.view.bringSubviewToFront(iv2)
                    self.view.bringSubviewToFront(self.loadingLabel)
                    
                    // switch views
                    UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
                        iv2.alpha = 0
                        iv1.alpha = 1
                    }
                    UIView.animate(withDuration: 1, delay: 1, options: [.repeat, .autoreverse]) {
                        iv1.alpha = 0
                        iv2.alpha = 1
                    }
                }
            }
            
        // if loading screen is off
        } else {
            
            // remove blur view and image views
            UIView.animate(withDuration: 1, delay: 0) {
                
                // find image views by tag
                let views = [self.view.viewWithTag(101), self.view.viewWithTag(102), self.blurry]
                for view in views {
                    view?.alpha = 0
                    view?.removeFromSuperview()
                    
                }
                
                // hide loading label
                self.loadingLabel.isHidden = true
                
            }

        }
        
    }
    
    
    func labelText() {
        
        // show a random sentence
        let random = Int.random(in: 0...self.randomStrings.count-1)
        self.loadingLabel.text = self.randomStrings[random]
        
        // change sentence after 6 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
            self.labelText()
            
        }
    }
    
    
    
    @IBAction func whatchuDoingButtonTapped(_ sender: Any) {
        
        // start loading screen
        self.loadingScreen(animating: true)
        
        // end loading screen
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(30)) {
            self.loadingScreen(animating: false)
            
        }
        
        
    }
    



}

