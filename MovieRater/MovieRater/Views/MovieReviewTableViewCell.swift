/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class MovieReviewTableViewCell: UITableViewCell {
  @IBOutlet weak var reviewLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var sentimentLabel: UILabel!
  @IBOutlet weak var negativeSentimentBar: UIView!
  @IBOutlet weak var postitiveSentimentBar: UIView!
  
  var movieReview: MovieReview? {
    didSet {
      updateCellAppearance(for: movieReview)
    }
  }
  
  var sentimentPrediction: SentimentAnalyser.SentimentPrediction? {
    didSet {
      if let sentimentPrediction = sentimentPrediction {
        updateCellAppearance(for: sentimentPrediction)
      }
    }
  }
  
  private func updateCellAppearance(for movieReview: MovieReview?) {
    if let movieReview = movieReview {
      reviewLabel.text = movieReview.review
      ratingLabel.text = "\(movieReview.rating)"
    } else {
      reviewLabel.text = ""
      ratingLabel.text = ""
    }
  }
  
  private func updateCellAppearance(for sentiment: SentimentAnalyser.SentimentPrediction) {
    let ratio = sentiment.positive / (sentiment.negative + sentiment.positive)
    DispatchQueue.main.async {
      self.sentimentLabel.text = sentiment.sentiment == .postive ? "👍" : "👎"
      let oldConstraint = self.postitiveSentimentBar.constraints.first(where: { $0.firstAttribute == .width })
      oldConstraint?.isActive = false
      let newConstraint = self.postitiveSentimentBar.widthAnchor.constraint(equalTo: self.negativeSentimentBar.widthAnchor, multiplier: CGFloat(ratio))
      newConstraint.isActive = true
    }
  }
}