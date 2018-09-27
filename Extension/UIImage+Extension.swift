//
//  UIImage+Extension.swift
import UIKit
public extension UIImage {
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width == 0 ? 1.0 : size.width, height: size.height == 0 ? 1.0 : size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
     func resetImageSize(_ newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    func zjResizeToSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    //根据颜色生成图片
    class func createImageWithColor(_ color : UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect);
        let theImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return theImage
    }
    func original() ->UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    class func imageWithURL(_ url : String,imgView : UIImageView) -> UIImage {
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        var image : UIImage?
        let task = URLSession.shared.dataTask(with:URL(string: url)!, completionHandler: { (data, respons, eror) -> Void in
            if data != nil{
                DispatchQueue.main.async(execute: {
                    image = UIImage(data: data!)
                    imgView.image = image
                })
            }else{
            }
        })
        task.resume();
        return image!
    }
    func imageByApplyingAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -area.size.height)
        ctx.setBlendMode(.multiply)
        ctx.setAlpha(alpha)
        ctx.draw(self.cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    func imageInRect(_ rect: CGRect) -> UIImage {
        let sourceImageRef = self.cgImage
        let newImageRef = sourceImageRef?.cropping(to: rect)
        return UIImage(cgImage: newImageRef!)
    }
    func clipImage(_ size: CGSize) -> UIImage {
        if self.size.width*size.height <= self.size.height*size.width {
            //以被剪裁图片的宽度为基准，得到剪切范围的大小
            let width  = self.size.width
            let height = self.size.width * size.height / size.width
            
            return self.imageInRect(CGRect(x: 0, y: (self.size.height - height)*0.5, width: width, height: height))
        } else {
            // 以被剪切图片的高度为基准，得到剪切范围的大小
            let width  = self.size.height * size.width / size.height
            let height = self.size.height
            return self.imageInRect(CGRect(x: (self.size.width - width) * 0.5, y: 0, width: width, height: height))
        }
    }
    //圆角加边框
    static func circleBorderW(_ borderW: CGFloat, circleColor: UIColor, image: UIImage)->UIImage {
        // 圆环宽度
        let borderWH: CGFloat = borderW
        let ctxWH: CGFloat = image.size.width + 2 * borderWH
        let ctxRect = CGRect(x: 0, y: 0, width: ctxWH, height: ctxWH)
        // 1.开启位图上下文
        UIGraphicsBeginImageContextWithOptions(ctxRect.size, false, 0)
        let bigCirclePath = UIBezierPath(ovalIn: ctxRect)
        // 设置圆环的颜色
        circleColor.set()
        bigCirclePath.fill()
        // 3.设置裁剪区域
        let clipRect = CGRect(x: borderWH, y: borderWH, width: image.size.width, height: image.size.height)
        let clipPath = UIBezierPath(ovalIn: clipRect)
        clipPath.addClip()
        //4.画图片
        image.draw(at: CGPoint(x: borderWH, y: borderWH))
        // 5.从上下文中获取图片
        let image1 = UIGraphicsGetImageFromCurrentImageContext()
        // 6.关闭上下文
        UIGraphicsEndImageContext()
        return image1!
    }
    //拉伸图片使用
    class func resizeImage(_ imageName: String) -> UIImage {
        var bgImage = UIImage(named: imageName)
        let a  = Int((bgImage?.size.width)!)/2
        let b = Int((bgImage?.size.height)!)/2
        bgImage = bgImage?.stretchableImage(withLeftCapWidth: Int(a), topCapHeight: Int(b))
        return bgImage!
    }
    //  生成图片名字
    class func createTypeAndName(_ image: UIImage) -> String {
        var mimeType: String? = nil
        // 可以在上传时使用当前的系统事件作为文件名
        let formatter = DateFormatter()
        // 设置时间格式
        formatter.dateFormat = "yyyyMMddHHmmss"
        let str: String = formatter.string(from: Date())
        //    NSString *uuid = [[NSUUID UUID] UUIDString];
//        if UIImage.imageHasAlpha(image) {
//            mimeType = "\(str).png"
//        }else {
            mimeType = "\(str).jpeg"
//        }
        return mimeType!
    }
    class func dataURL2Image(_ imgSrc: String) -> UIImage {
        let url = URL(string: imgSrc)
        let data = try! Data(contentsOf: url!)
        let image = UIImage(data: data)
        return image!
    }
    //按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
    class func imageCompress(forSize sourceImage: UIImage, targetSize size: CGSize) -> UIImage {
        var newImage: UIImage? = nil
        let imageSize: CGSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = size.width
        let targetHeight: CGFloat = size.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = targetWidth
        var scaledHeight: CGFloat = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        if imageSize.equalTo(size) == false {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            }else {
                scaleFactor = heightFactor
            }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
       }
        UIGraphicsBeginImageContext(size)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if newImage == nil {
            print("scale image fail")
        }
        UIGraphicsEndImageContext()
        return newImage!
    }
    //裁剪成圆形图片
    class func circleImage(_ image: UIImage, withParam inset: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2)
        context?.setStrokeColor(UIColor.white.cgColor)
        let rect = CGRect(x: inset, y: inset, width: image.size.width - inset * 2.0, height: image.size.height - inset * 2.0)
        context?.addEllipse(in: rect)
        context?.clip()
        image.draw(in: rect)
        context?.addEllipse(in: rect)
        context?.strokePath()
        let newimg: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newimg!
    }
    //把图片缩放到固定大小
    class func scale(toSize img: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    //通过颜色来生成一个纯色图片
    class func image(from color: UIColor, size aSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: aSize.width, height: aSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    func imageByScaling(to targetSize: CGSize) -> UIImage {
        let sourceImage: UIImage? = self
        var newImage: UIImage? = nil
        let targetWidth: CGFloat = targetSize.width
        let targetHeight: CGFloat = targetSize.height
        let scaledWidth: CGFloat = targetWidth
        let scaledHeight: CGFloat = targetHeight
        let thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage?.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if newImage == nil {
            print("could not scale image")
        }
        return newImage!
    }
    func resizeImage(withNewSize newSize: CGSize) -> UIImage {
        let newWidth: CGFloat = newSize.width
        let newHeight: CGFloat = newSize.height
        // Resize image if needed.
        let width = size.width
        let height = size.width
        if width == 0 || height == 0 {}
        //float scale;
        if width != newWidth || height != newHeight {
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            let resized: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            //NSData *jpeg = UIImageJPEGRepresentation(image, 0.8);
            return resized!
        }
        return self
    }
    //  根据图片名返回一张能够自由拉伸的图
    func imageWithStrch(_ imageName: String)-> UIImage {
        let image = UIImage(named: imageName)
        // 获取原有图片的宽高的一半
        let w: CGFloat? = (image?.size.width)! * 0.5
        let h: CGFloat? = (image?.size.height)! * 0.5
        // 生成可以拉伸指定位置的图片
        let newImage: UIImage? = image?.resizableImage(withCapInsets: UIEdgeInsets(top: h!, left: w!, bottom: h!, right: w!), resizingMode: .stretch)
        return newImage!
    }
}
