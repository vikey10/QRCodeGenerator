//
//  GenerateQRCode.swift
//
//  Created by vikey wang on 17/3/15.
//  Copyright © 2017年 vikey wang All rights reserved.
//

import Foundation
import UIKit

private let sharedInstance = GenerateQRCode()
class GenerateQRCode: NSObject {
 
    /**
      生成原生黑白二维码
     - author: Vikey  wang
     - date: 17-03-15 11:03:36
     - parameter data:    二维码信息
     - parameter size:    二维码图片大小，宽高一样
     
     - returns: 生成原生黑白二维码的新图片
     */
    class func generateQRCode(_ data:String,size : CGFloat) -> UIImage {
        let nativeImage = sharedInstance.createNativeQRCode(data)
        let bitmap = sharedInstance.createNonInterpolatedUIImageFormCIImage(nativeImage!, size: size)
        return UIImage.init(cgImage: bitmap)
    }
    
    /**
     生成自定义颜色的二维码
     - author: Vikey  wang
     - date: 17-03-15 11:04:38
     - parameter data:    二维码信息
     - parameter size:    二维码图片大小，宽高一样
     - parameter colorOne: 原黑白二维码中黑色部分的替代颜色
     - parameter colorTwo: 原黑白二维码中白色部分的替代颜色
     - returns: 生成自定义颜色的二维码的新图片
     */

    class func generateColorfulQRCode(_ data:String,size : CGFloat,changeBlackColor colorOne:UIColor?,changeWhiteColor colorTwo:UIColor?) -> UIImage {
        let colorfulImage = sharedInstance.createNativeQRCodeWithColor(data, blackColor: colorOne, whiteColor: colorTwo)
        let bitmap = sharedInstance.createNonInterpolatedUIImageFormCIImage(colorfulImage, size: size)
        return UIImage.init(cgImage: bitmap)
    }
    
    /**
     生成中间带logo的二维码
     - author: Vikey  wang
     - date: 17-03-15 11:06:38
     - parameter data:    二维码信息
     - parameter size:    二维码图片大小，宽高一样
     - parameter logon:   logo图片
      - returns: 生成中间带logo的二维码的新图片
     */

    class func generateQRCodeWithLogo(_ data:String,size:CGFloat,logo:UIImage?) -> UIImage {
        let nativeImage = sharedInstance.createNativeQRCode(data)
        let bitmap = UIImage.init(cgImage:sharedInstance.createNonInterpolatedUIImageFormCIImage(nativeImage!, size: size))
//        logo的图片宽度不能大于二维码图片宽度的一半，否则二维码无法识别
        let bitmapSize = bitmap.size
        var logoImage = logo ?? UIImage.init(named: "service_choose")
        var logoSize = logo!.size
        if max(logoSize.width,logoSize.height) > bitmapSize.width/2 {
            logoSize = CGSize.init(width: ( bitmapSize.width/2) - 5, height: ( bitmapSize.width/2) - 5)
            UIGraphicsBeginImageContext(logoSize)
            logoImage!.draw(in: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: logoSize))
            //create UIImage
            logoImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return sharedInstance.interpolateImage(logoImage!, to:bitmap)

    }
    
    class func generateQRCodeWithLogo(_ data:String,size:CGFloat,logo:UIImage? ,andChangedBlackColor colorOne:UIColor?,changedWhiteColor colorTwo:UIColor?) -> UIImage {
        let nativeImage = sharedInstance.createNativeQRCodeWithColor(data, blackColor: colorOne, whiteColor: colorTwo)
        let bitmap = UIImage.init(cgImage:sharedInstance.createNonInterpolatedUIImageFormCIImage(nativeImage, size: size))
        //        logo的图片宽度不能大于二维码图片宽度的一半，否则二维码无法识别
        let bitmapSize = bitmap.size
        var logoImage = logo ?? UIImage.init(named: "service_choose")
        var logoSize = logo!.size
        if max(logoSize.width,logoSize.height) > bitmapSize.width/2 {
            logoSize = CGSize.init(width: ( bitmapSize.width/2) - 5, height: ( bitmapSize.width/2) - 5)
            UIGraphicsBeginImageContext(logoSize)
            logoImage!.draw(in: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: logoSize))
            //create UIImage
            logoImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return sharedInstance.interpolateImage(logoImage!, to:bitmap)
    }
    
    
    /**
     插入图片到另外一张图片的中心位置
     
     - author: Vikey  wang
     - date: 17-03-15 11:03:36
     
     - parameter image:     要插入的图片
     - parameter BaseImage: 原始图片
     
     - returns: 生成的插入完成后的新图片
     */

    fileprivate func interpolateImage(_ image:UIImage,to baseImage:UIImage) -> UIImage {
        let baseSize = baseImage.size
        let logoSize = image.size
        UIGraphicsBeginImageContext(baseSize)
        baseImage.draw(in: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: baseSize))
        let logoRect = CGRect.init(x: (baseSize.width-logoSize.width)/2, y: (baseSize.height-logoSize.height)/2, width: logoSize.width, height: logoSize.height)
        let path = UIBezierPath.init(rect:logoRect)
        UIColor.white.setFill()
        path.fill()
        path.addClip()
        image.draw(in: logoRect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
    
    
    /**
     系统方法生成的二维码
     - author: Vikey  wang
     - date: 17-03-15 11:03:51
     - parameter url: 二维码数据连接
     - returns: CIImage,二维码图片
     */
    fileprivate func createNativeQRCode(_ data : String) -> CIImage? {
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let codeData = data.data(using: String.Encoding.utf8)
        filter?.setValue(codeData, forKey: "inputMessage")
        return filter?.outputImage
    }
    
    /**
     生成自定义颜色的二维码
     
     - author: Vikey  wang
     - date: 17-03-15 11:03:38
     
     - parameter data:       二维码信息
     - parameter blackColor: 默认黑色部分的自定义颜色
     - parameter whiteColor: 默认白色部分的自定义颜色
     
     - returns: 生成的自定义颜色图形
     */
    fileprivate func createNativeQRCodeWithColor(_ data:String,blackColor:UIColor?,whiteColor:UIColor?) -> CIImage {
        let QRCodeImage = sharedInstance.createNativeQRCode(data)
        //          创建颜色滤镜
        let colorFilter = CIFilter.init(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(QRCodeImage, forKey: "inputImage")
        //        默认黑色，可自行替换
        let color0 = blackColor ??  UIColor.black
        colorFilter?.setValue(CIColor.init(color: color0), forKey: "inputColor0")
        
        //        默认白色，可自行替换
        let color1 = whiteColor ??  UIColor.white
        colorFilter?.setValue(CIColor.init(color: color1), forKey: "inputColor1")
        
        return (colorFilter?.outputImage)!
    }
    
    /**
     生成bitmap.图形中间无插入图片
     
     - author: Vikey  wang
     - date: 17-03-15 10:03:16
     
     - parameter image: 原始二维码
     - parameter size:  二维码的大小
     
     - returns: 生成的二维码图片
     */
    fileprivate func createNonInterpolatedUIImageFormCIImage(_ image:CIImage,size:CGFloat) -> CGImage {
        let extent = image.extent.integral
        let scale = min(size/extent.size.width,size/extent.size.height)
        //        创建bitmap
        let width  = extent.width * scale
        let height = extent.width * scale

        let cs = CGColorSpaceCreateDeviceRGB()
        let bmpInfo = CGImageAlphaInfo.premultipliedFirst.rawValue|CGBitmapInfo.byteOrder32Little.rawValue
//      参数data指向绘图操作被渲染的内存区域，这个内存区域大小应该为（bytesPerRow*height）个字节。如果对绘制操作被渲染的内存区域并无特别的要求，那么可以传递nil给参数date。
//      参数width代表被渲染内存区域的宽度。
//      参数height代表被渲染内存区域的高度。
//      参数bitsPerComponent被渲染内存区域中组件在屏幕每个像素点上需要使用的bits位，举例来说，如果使用32-bit像素和RGB颜色格式，那么RGBA颜色格式中每个组件在屏幕每个像素点上需要使用的bits位就为32/4=8。
//      参数bytesPerRow代表被渲染内存区域中每行所使用的bytes位数。
//      参数cs用于被渲染内存区域的“位图上下文”。
//      参数bmpInfo指定被渲染内存区域的“视图”是否包含一个alpha（透视）通道以及每个像素相应的位置，除此之外还可以指定组件式是浮点值还是整数值。
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: bmpInfo)
        let context = CIContext.init(options: nil)
        let bitmapImage = context.createCGImage(image, from: extent)
//        CGContextSetInterpolationQuality(bitmapRef!, CGInterpolationQuality.None)
        bitmapRef?.interpolationQuality = CGInterpolationQuality.none
//        CGContextScaleCTM(bitmapRef!, scale, scale)
        bitmapRef?.scaleBy(x: scale, y: scale)
//        CGContextDrawImage(bitmapRef, extent, bitmapImage)
        bitmapRef?.draw(bitmapImage!, in: extent)
        //        返回bitmap图片
        return bitmapRef!.makeImage()!
    }
    

    
}
