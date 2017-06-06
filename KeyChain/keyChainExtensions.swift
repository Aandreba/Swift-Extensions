import Foundation
import UIKit

extension A0SimpleKeychain {
    public func setObject(object:AnyObject!, forKey:String!)-> Bool{
        if var data = object.dataValue {
        self.setData(data!, forKey: forKey)
            return true
        }
        return false
    }
    public func setDictionary(object:NSDictionary, forKey:String!){
        var data : NSData = NSKeyedArchiver.archivedDataWithRootObject(object)
        self.setData(data, forKey: forKey)
    }
    
    public func objectForKey(key:String!)->AnyObject{
        var data = self.dataForKey(key)
        return data as! AnyObject
    }
    
    public func dictionaryForKey(key:String!)->NSDictionary{
        var data = self.dataForKey(key)
        let dictionary:NSDictionary? = NSKeyedUnarchiver.unarchiveObjectWithData(data!)! as? NSDictionary
        return dictionary!
    }
}
