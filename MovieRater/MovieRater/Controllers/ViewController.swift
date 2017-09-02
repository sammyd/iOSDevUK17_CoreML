//
//  ViewController.swift
//  MovieRater
//
//  Created by Sam Davies on 01/09/2017.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let analyser = SentimentAnalyser()
    let prediction = analyser.predictSentiment(for: "highly very best best awesome recommended")
    print(prediction)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

