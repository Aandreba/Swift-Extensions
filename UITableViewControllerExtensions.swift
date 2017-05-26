import Foundation
import UIKit

struct TableItem {
    let title: String
    let price: Float
    let creationDate: NSDate
    
    init(name:String, price:Float){
        self.title = name
        self.price = price
        self.creationDate = NSDate()
    }
    
    private func convertDateFormatter(date: String) -> String
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(date)
        
        
        dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        
        return timeStamp
    }
    
    public init(dictionary: Dictionary<String, AnyObject>){
        self.title = (dictionary["title"] as? String)!
        self.price = (dictionary["price"] as? Float)!
        self.creationDate = (dictionary["creationDate"] as? NSDate)!
    }
    
    // Encode
    public func encode() -> Dictionary<String, AnyObject> {
        var dictionary : Dictionary = Dictionary<String, AnyObject>()
        dictionary["title"] = self.title
        dictionary["price"] = self.price
        dictionary["creationDate"] = self.creationDate
        print(dictionary)
        return dictionary
    }
    
}

struct TableSection {
    let name: String
    var TableItems: Dictionary<Int,TableItem>
    let creationDate: NSDate
    
    init(name:String, items:[Int:TableItem]?){
        self.name = name
        TableItems = items!
        creationDate = NSDate()
    }
    
    init(name:String){
        self.name = name
        creationDate = NSDate()
        self.TableItems = [:]
    }
    
    mutating func addItem(item:TableItem){
        self.TableItems[self.TableItems.count] = item
    }
    
    mutating func addItem(name:String, price:Float){
        self.TableItems[self.TableItems.count] = TableItem(name: name, price: price)
    }
    
    public init(dictionary: Dictionary<String, AnyObject>){
        self.name = (dictionary["name"] as? String)!
        var en = dictionary["TableItems"] as? NSDictionary
        self.TableItems = [:]
        for (name, value) in en! {
            var dictio = value as? Dictionary<String,AnyObject>
            self.TableItems[TableItems.count] = TableItem(dictionary: dictio!)
        }
        self.creationDate = (dictionary["creationDate"] as? NSDate)!
    }
    
    // Encode
    public func encode() -> Dictionary<String, AnyObject> {
        var dictionary : Dictionary = Dictionary<String, AnyObject>()
        dictionary["name"] = self.name
        dictionary["creationDate"] = self.creationDate
        var exp = Dictionary<Int,Dictionary<String, AnyObject>>()
        for (id, object) in TableItems {
            exp[id] = object.encode()
        }
        dictionary["TableItems"] = exp
        return dictionary
    }
    
}
