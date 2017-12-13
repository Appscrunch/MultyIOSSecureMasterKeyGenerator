//This is my custom header

import UIKit
import CryptoSwift

class MasterKeyGenerator : NSObject, GGLInstanceIDDelegate {
    static let sharedGenerator = MasterKeyGenerator()
    
    fileprivate var localPasswordString : String = ""
    fileprivate var executedFunction : ((String?, Error?, String?) -> Void)?
    
    public func generateTokens(completion: @escaping (_ masterKey: String?, _ error: Error?, String?) -> ()) {
        executedFunction = completion
        
        generateInstanceID()
        generateLocalPasswordString()
    }
    
    fileprivate func generateLocalPasswordString() {
        // Future feature
        // get additional protection from local password/fingerprint
        
        localPasswordString = ""
    }
    
    fileprivate func generateInstanceID() {
        let instanceIDConfig = GGLInstanceIDConfig.default()
        instanceIDConfig?.delegate = self
        GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
        
        let iidInstance = GGLInstanceID.sharedInstance()
        
        let handler : (String?, Error?) -> Void = { (identity, error) in
            if let iid = identity {
                DispatchQueue.main.async {
                    self.generateMasterKey(instanceID: iid)
                }
            } else {
                print(error ?? "empty error")
            }
        }
        
        iidInstance?.getWithHandler(handler)
    }
    
    fileprivate func generateMasterKey(instanceID: String) {
        let key = sha512(instanceID + UIDevice.current.identifierForVendor!.uuidString + "")
        
        guard let masterKey = key else {
            print("Error generating master key")
            
            return
        }
        
        //send
        if let function = executedFunction {
            function(masterKey, nil, nil)//"\(instanceIDToken)\n\n\(devicePushToken)\n\n\(deviceUUIDToken)")
        }
    }
    
    fileprivate func sha512(_ str: String) -> String? {
        guard let data = str.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let sha512Data = data.sha3(.sha512)
        let sha512String = sha512Data.base64EncodedString(options: [])
        
        return sha512String
    }
    
    //MARK: GGLInstanceIDDelegate
    internal func onTokenRefresh() {
        print("onTokenRefresh")
    }
}
