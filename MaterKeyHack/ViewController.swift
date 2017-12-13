//This is my custom header

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var masterKeyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        generateMasterKey()
    }

    func generateMasterKey() {
        MasterKeyGenerator.sharedGenerator.generateTokens { (masterKey, error, keysString) in
            if error != nil {
                self.presentAlertWithTitle(nil, andMessage: (error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    self.masterKeyLabel.text = masterKey!
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func presentAlertWithTitle(_ title : String?, andMessage message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}

