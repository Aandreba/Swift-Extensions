import Foundation
import UIKit


//Extensions
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var QRImage:UIImage?{
        let data = self.dataUsingEncoding(NSASCIIStringEncoding)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(a: 0, b: 0, c: 0, d: 0, tx: 3, ty: 3)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        
        return nil
    }
}

extension UIImage {
    private func _resizeWithAspect_doResize(size: CGSize)->UIImage{
        if UIScreen.mainScreen().respondsToSelector("scale"){
            UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.mainScreen().scale);
        }
        else
        {
            UIGraphicsBeginImageContext(size);
        }
        
        self.drawInRect(CGRectMake(0, 0, size.width, size.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }

    
    func resizeImageWithAspect(scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage
    {
        let oldWidth = self.size.width;
        let oldHeight = self.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSizeMake(newWidth, newHeight);
        
        return self._resizeWithAspect_doResize(newSize);
    }
}

extension NSDictionary {
    func stringValue()->String{
        var data : NSData = NSKeyedArchiver.archivedDataWithRootObject(self)
        return NSString(data: data, encoding: NSUTF8StringEncoding) as! String
    }
    
    func DictionaryValueForStringKey()->Dictionary<String, AnyObject>{
        var swiftDict : Dictionary<String,AnyObject!> = Dictionary<String,AnyObject!>()
        for key : AnyObject in self.allKeys {
            let stringKey = key as! String
            if let keyValue = self.valueForKey(stringKey){
                swiftDict[stringKey] = keyValue
            }
        }
        return swiftDict
    }
    
    func DictionaryValueForIntKey()->Dictionary<Int, AnyObject>{
        var swiftDict : Dictionary<Int,AnyObject!> = Dictionary<Int,AnyObject!>()
        for key : AnyObject in self.allKeys {
            let stringKey = key as! Int
            if let keyValue = self.valueForKey("\(stringKey)"){
                swiftDict[stringKey] = keyValue
            }
        }
        return swiftDict
    }

}

extension NSMutableDictionary {
    override func stringValue()->String{
        var ns = self as? NSDictionary
        var data : NSData = NSKeyedArchiver.archivedDataWithRootObject(ns!)
        return NSString(data: data, encoding: NSUTF8StringEncoding) as! String
    }
}


extension NSURL {
    func openURL(){
        UIApplication.sharedApplication().openURL(self)
    }
    var QRImage:UIImage?{
        let data = self.dataRepresentation
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(a: 0, b: 0, c: 0, d: 0, tx: 3, ty: 3)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        
        return nil
    }
}

extension NSData {
    func stringUsingEncoding(encoding: UInt)->String{
        return (NSString(data: self, encoding: NSUTF8StringEncoding) as! String)
    }
}

extension UIImage {
    var qrString: String {
        var image = self.CIImage
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyLow])
        
        var decode = ""
        let features = detector.featuresInImage(image!)
        for feature in features as! [CIQRCodeFeature] {
            decode = feature.messageString
            print("1")
        }
        return decode
    }

}

func presentXibViewController(actualVC:UIViewController, name:String, animation:Bool, completion:(()->Void)?){
    let vc = UIViewController(nibName: "name", bundle: nil)
    actualVC.presentViewController(vc, animated: animation, completion: completion)
}

extension UIImage{
    func getImageFromWeb(_urlString: String)->UIImage {
        let url = NSURL(string: _urlString)
        let data = try? NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        print(data, String(data))
        return UIImage(data: data!!)!
    }
}

extension NSDate {
    func addMonth(n: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        return cal.dateByAddingUnit(.Month, value: n, toDate: self, options: .MatchNextTime)!
    }
    func addDay(n: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        return cal.dateByAddingUnit(.Day, value: n, toDate: self, options: .MatchNextTime)!
    }
    func addSecond(n: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        return cal.dateByAddingUnit(.Second, value: n, toDate: self, options: .MatchNextTime)!
    }
    func addYear(n: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        return cal.dateByAddingUnit(.Year, value: n, toDate: self, options: .MatchNextTime)!
    }
    var month:Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month], fromDate: self)
        return components.month
    }
    var day:Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: self)
        return components.day
    }
    var year:Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year], fromDate: self)
        return components.year
    }
    var second:Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Second], fromDate: self)
        return components.second
    }
}
