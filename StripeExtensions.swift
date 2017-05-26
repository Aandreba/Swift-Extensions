import Foundation
import UIKit
import Stripe

extension STPCard{
    func validate(completed: ()->())->Bool{
        var error: NSError? = nil
        try? self.validateCardReturningError()
        //3
        if error != nil {
            return false
        } else {
        completed()
        return true
        }
}
    var token:STPToken{
        var ret = [STPToken]()
        STPAPIClient.sharedClient().createTokenWithCard(self, completion: { (token, error) -> Void in
            
            if error != nil {
                return
            }
            ret[0] = token!
        })
        return ret[0] as! STPToken
    }
}
extension STPCardBrand{
    var brandName:String{
        var options = ["Visa", "American Express", "MasterCard", "Discover", "JCB", "Diners Club", "Unknown"]
        return options[self.hashValue]
    }
}
