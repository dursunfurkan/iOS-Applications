//
//  ViewController.swift
//  KennyGame
//
//  Created by Furkan DURSUN on 28.04.2023.
//

import UIKit

class ViewController: UIViewController {

    //Views
    @IBOutlet weak var kennyImage9: UIImageView!
    @IBOutlet weak var kennyImage8: UIImageView!
    @IBOutlet weak var kennyImage7: UIImageView!
    @IBOutlet weak var kennyImage6: UIImageView!
    @IBOutlet weak var kennyImage5: UIImageView!
    @IBOutlet weak var kennyImage4: UIImageView!
    @IBOutlet weak var kennyImage3: UIImageView!
    @IBOutlet weak var kennyImage2: UIImageView!
    @IBOutlet weak var kennyImage1: UIImageView!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    //Variables
    var score = 0
    var timer = Timer()
    var hideTimer = Timer()
    var counter = 10
    var kennyArray = [UIImageView]()
    var randomInt = 0
    var userDefaults = UserDefaults.standard
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kennyArray = [kennyImage1, kennyImage2, kennyImage3, kennyImage4, kennyImage5, kennyImage6, kennyImage7, kennyImage8, kennyImage9]
        scoreLabel.text = "Skor: \(score)"
        timerLabel.text = "\(counter)"
        hideKenny()
    
        let storedHighscore = userDefaults.object(forKey: "highscore")
        if storedHighscore == nil {
            highScore = 0
            highscoreLabel.text = "Highscore: \(highScore)"
        }
        if let newScore = storedHighscore as? Int {
            highScore = newScore
            highscoreLabel.text = "Highscore: \(highScore)"
        }
        
        for kenny in kennyArray {
            kenny.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
            kenny.addGestureRecognizer(gestureRecognizer)
        }

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideKenny), userInfo: nil, repeats: true)
        

    }
    
    @objc func increaseScore() {
        score += 1
        scoreLabel.text = "Skor: \(score)"
    }
    
    @objc func timerFunction() {
        counter -= 1
        timerLabel.text = "\(counter)"

        if counter == 0 {
            alertMessage()
            timer.invalidate()
            hideTimer.invalidate()
            
            for kenny in kennyArray {
                kenny.isHidden = true
            }
            
            if self.score > self.highScore {
                self.highScore = self.score
                highscoreLabel.text = "Highscore: \(self.highScore)"
                userDefaults.set(self.highScore, forKey: "highscore")
            }
        }
        
    }
    
    func alertMessage() {
        let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.counter = 10
            self.timerLabel.text = "\(self.counter)"
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: true)
            self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideKenny), userInfo: nil, repeats: true)
            self.score = 0
            self.scoreLabel.text = "Skor: \(self.score)"
        }
        alert.addAction(okButton)
        alert.addAction(replayButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKenny() {
        for kenny in kennyArray {
            kenny.isHidden = true
        }
        kennyArray[randomInt].isHidden = true
        randomKenny()
    }
    
    func randomKenny() {
        randomInt = Int.random(in: 0...kennyArray.count - 1)
        kennyArray[randomInt].isHidden = false
    }
}

