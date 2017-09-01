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
import Vision
import CoreML

class ViewController: UIViewController {
  
  var model: VNCoreMLModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    model = try? VNCoreMLModel(for: SOS().model)
    
  }

  @IBOutlet weak var chooseButton: UIButton!
  @IBAction func handleChooseButtonTapped(_ sender: Any) {
    guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    present(picker, animated: true, completion: .none)
  }
  

}


extension ViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
    process(image: image)
  }
}

extension ViewController: UINavigationControllerDelegate {
  
}

extension ViewController {
  func process(image: UIImage) {
    guard let model = model else { return }
    let request = VNCoreMLRequest(model: model) { (request, error) in
      guard let results = request.results as? [VNCoreMLFeatureValueObservation],
        let mostLikelyResult = results.first else {
        print("Unknown results")
        return
      }
      
      if let array = mostLikelyResult.featureValue.multiArrayValue {
        let m = MultiArray<Double>(array)
        print(m)
        
      }
      
      print(mostLikelyResult)
    }
    
    let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        try handler.perform([request])
      } catch {
        print(error)
      }
    }
  }
}
