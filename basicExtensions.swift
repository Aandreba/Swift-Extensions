import Foundation
import UIKit
import LocalAuthentication


//Extensions
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var QRImage:UIImage?{
        let data = self.dataUsingEncoding(NSASCIIStringEncoding)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransformMakeScale(5, 5)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        
        return nil
    }
    func stringUsingEncoding(encoding: NSStringEncoding)->String{
    var data = self.dataUsingEncoding(encoding)
        return (NSString(data: data!, encoding: encoding)) as! String
    }
}

extension String {
    func URLEncodedString() -> String? {
        var escapedString = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        return escapedString
    }
    static func queryStringFromParameters(parameters: Dictionary<String,String>) -> String? {
        if (parameters.count == 0)
        {
            return nil
        }
        var queryString : String? = nil
        for (key, value) in parameters {
            if let encodedKey = key.URLEncodedString() {
                if let encodedValue = value.URLEncodedString() {
                    if queryString == nil
                    {
                        queryString = "?"
                    }
                    else
                    {
                        queryString! += "&"
                    }
                    queryString! += encodedKey + "=" + encodedValue
                }
            }
        }
        return queryString
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

extension CIImage {
    var cgimage:CGImage!{
        let context:CIContext? = CIContext(options: nil)
        if context != nil {
            return context!.createCGImage(self, fromRect: self.extent)
        }
        return nil
    }
    var uiimage:UIImage{
        var ui = UIImage(CGImage: self.cgimage)
        return ui
    }
    
    var data:NSData{
        var cg = self.cgimage
        print(cg)
        return UIImagePNGRepresentation(cg.uiimage)!
    }
}

extension CGImage {
    var data:NSData{
        return UIImagePNGRepresentation(UIImage(CGImage: self))!
    }
    var uiimage:UIImage{
        return UIImage(CGImage: self)
    }
    }



extension NSURL {
    func openURL(){
        UIApplication.sharedApplication().openURL(self)
    }
    func resizeImage(image: UIImage, withQuality quality: CGInterpolationQuality, rate: CGFloat) -> UIImage {
        let width = image.size.width * rate
        let height = image.size.height * rate
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), true, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, quality)
        image.drawInRect(CGRectMake(0, 0, width, height))
        
        let resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resized;
    }
    
    var QRImage:UIImage?{
        let data = self.absoluteString.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("L", forKey: "inputCorrectionLevel")
            var ret = UIImage()
            ret = UIImage(CGImage: filter.outputImage!.cgimage)
            ret.drawInRect(filter.outputImage!.extent)
            print(filter.outputImage?.data)
            let transform = CGAffineTransformMakeScale(5, 5)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
 
                return output.uiimage
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

private func UIImageToCIImage(image: UIImage)->CIImage {
    return CIImage(image: image)!
}

extension UIImage {
    var qrString: String? {
        var image = UIImageToCIImage(self)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyLow])
        
        var decode = ""
        let features = detector.featuresInImage(image)
        for feature in features as! [CIQRCodeFeature] {
            decode = feature.messageString
        }
        return decode
    }

}

func presentXibViewController(actualVC:UIViewController, name:String, animation:Bool, completion:(()->Void)?){
    let vc = UIViewController(nibName: "name", bundle: nil)
    actualVC.presentViewController(vc, animated: animation, completion: completion)
}

func errorAlert(vc:UIViewController!, error: NSError!, animated:Bool!, handler: ((UIAlertAction) -> Void)?){
    let alert = UIAlertController(title: "\(error.code)", message: error.domain, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: handler))
    vc.presentViewController(alert, animated: animated, completion: nil)
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
