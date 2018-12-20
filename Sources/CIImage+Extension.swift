//
//  CIImage+Extension.swift
//  ICIFilter
//
//  Created by xialuo on 2018/12/20.
//  Copyright © 2018 https://ixialuo.com. All rights reserved.
//

import UIKit

extension CIImage {
    
    // 1.高斯模糊滤镜（CIGaussianBlur）
    public func blur(radius: Double) -> CIImage {
        let parameters: [String: Any] = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: self
        ]
        guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else {
            fatalError("CIGaussianBlur filter creation failed!")
        }
        guard let outputImage = filter.outputImage else {
            fatalError("CIGaussianBlur outputImage generation failed!")
        }
        return outputImage
    }
    
    // 2.颜色生成滤镜（CIConstantColorGenerator）
    public func generate(color: UIColor) -> CIImage {
        let parameters: [String: Any] = [
            kCIInputColorKey: CIColor(cgColor: color.cgColor)
        ]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else {
            fatalError("CIConstantColorGenerator filter creation failed!")
        }
        guard let outputImage = filter.outputImage else {
            fatalError("CIConstantColorGenerator outputImage generation failed!")
        }
        return outputImage.cropped(to: extent)
    }
    
    // 3.图像覆盖合成滤镜（CISourceOverCompositing）
    // iOS8.0开始 <func composited(over dest: CIImage) -> CIImage> 的实现原理
    public func compositeSource(over dest: CIImage) -> CIImage {
        let parameters: [String: Any] = [
            kCIInputBackgroundImageKey: dest,
            kCIInputImageKey: self
        ]
        guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameters) else {
            fatalError("CISourceOverCompositing filter creation failed!")
        }
        guard let outputImage = filter.outputImage else {
            fatalError("CISourceOverCompositing outputImage generation failed!")
        }
        return outputImage.cropped(to: extent)
    }
    
    // 4.颜色叠层滤镜
    public func overlay(color: UIColor) -> CIImage {
        let overlay = generate(color: color)
        return overlay.compositeSource(over: self)
    }
    
}
