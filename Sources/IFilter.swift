//
//  IFilter.swift
//  ICIFilter
//
//  Created by xialuo on 2018/12/20.
//  Copyright © 2018 https://ixialuo.com. All rights reserved.
//

import UIKit

public typealias Filter = (CIImage) -> CIImage

// 1.高斯模糊滤镜（CIGaussianBlur）
public func blur(radius: Double) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ]
        guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else {
            fatalError("CIGaussianBlur filter creation failed!")
        }
        guard let outputImage = filter.outputImage else {
            fatalError("CIGaussianBlur outputImage generation failed!")
        }
        return outputImage
    }
}

// 2.颜色生成滤镜（CIConstantColorGenerator）
public func generate(color: UIColor) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputColorKey: CIColor(cgColor: color.cgColor)
        ]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else {
            fatalError("CIConstantColorGenerator filter creation failed!")
        }
        guard let outputImage = filter.outputImage else {
            fatalError("CIConstantColorGenerator outputImage generation failed!")
        }
        return outputImage.cropped(to: image.extent)
    }
}

// 3.图像覆盖合成滤镜（CISourceOverCompositing）
public func compositeSource(over dest: CIImage) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputBackgroundImageKey: dest,
            kCIInputImageKey: image
        ]
        guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameters) else {
            fatalError("CISourceOverCompositing filter creation failed!")
        }
        guard let outputImage = filter.outputImage else {
            fatalError("CISourceOverCompositing outputImage generation failed!")
        }
        return outputImage.cropped(to: image.extent)
    }
}

// 4.颜色叠层滤镜
public func overlay(color: UIColor) -> Filter {
    return { image in
        let overlay = generate(color: color)(image)
        return compositeSource(over: image)(overlay)
    }
}

// 5.复合函数组合滤镜
public func compose(filter filter1: @escaping Filter, with filter2: @escaping Filter) -> Filter {
    return { image in
        filter2(filter1(image))
    }
}

// 6.自定义运算符组合滤镜
infix operator >>>
public func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in
        filter2(filter1(image))
    }
}
