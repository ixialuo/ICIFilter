# ICIFilter
[封装 Core Image 的 API - 延展方式](https://www.jianshu.com/p/5537793022a5)<br>
[封装 Core Image 的 API - 高阶函数方式](https://www.jianshu.com/p/c9ba2a719167)<br>

下面介绍的是延展方式，高阶函数方式可点击👆链接查看

# Content
- [Why](#why)
- [Methods&Advantage](#methods&advantage)
    - [Methods](#methods)
    - [Advantage](#advantage)
- [Usage](#usage)
    - [效果图](#效果图)
    - [调用代码](#调用代码)
- [Implementation](#implementation)
    - [1、高斯模糊滤镜（CIGaussianBlur）](#1、高斯模糊滤镜（CIGaussianBlur）)
    - [2、颜色生成滤镜（CIConstantColorGenerator）](#2、颜色生成滤镜（CIConstantColorGenerator）)
    - [3、图像覆盖合成滤镜（CISourceOverCompositing）](#3、图像覆盖合成滤镜（CISourceOverCompositing）)
    - [4、颜色叠层滤镜](#4、颜色叠层滤镜)
- [Contact](#contact)
- [License](#license)

# Why
- Core Image 是一个强大的图像处理框架，但是它的 API 有时可能略显笨拙。
- Core Image 的 API 是弱类型的 —— 我们通过键值编码 (KVC) 来配置图像滤镜 (filter)。
- 在使用参数的类型或名字时，我们都使用字符串来进行表示，这十分容易出错，极有可能导致运行时错误。

# Methods&Advantage
#### Methods
对 CIImage 延展开发新的 API
#### Advantage
避免这些运行时错误，最终得到一组类型安全的 API

# Usage
##### 效果图
![效果图](https://upload-images.jianshu.io/upload_images/2800067-47f5219769f45235.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 调用代码
```swift
if let url = URL(string: "https://via.placeholder.com/300x180/62abe4/ffffff?text=Core+Image"), let image = CIImage(contentsOf: url) {
    
    // 原图
    coreImageViews[0].image = UIImage(ciImage: image)
    
    // 高斯模糊滤镜
    coreImageViews[1].image = UIImage(ciImage: image.blurred(radius: 2))
    
    // 颜色生成滤镜
    let color = UIColor.orange.withAlphaComponent(0.4)
    coreImageViews[2].image = UIImage(ciImage: image.generated(color: color))
    
    // 图像覆盖合成滤镜（自己实现）
    coreImageViews[3].image = UIImage(ciImage: image.generated(color: color).compositeSource(over: image))
    
    // 图像覆盖合成滤镜（系统自带）
    coreImageViews[4].image = UIImage(ciImage: image.generated(color: color).composited(over: image))
    
    // 颜色叠层滤镜
    let yellow = UIColor.yellow.withAlphaComponent(0.4)
    coreImageViews[5].image = UIImage(ciImage: image.overlaid(color: yellow))
}
```

# Implementation
##### 1、高斯模糊滤镜（CIGaussianBlur）
```swift
// 1.高斯模糊滤镜（CIGaussianBlur）
public func blurred(radius: Double) -> CIImage {
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
```

##### 2、颜色生成滤镜（CIConstantColorGenerator）
```swift
public func generated(color: UIColor) -> CIImage {
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
```

##### 3、图像覆盖合成滤镜（CISourceOverCompositing）
```swift
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
```

##### 4、颜色叠层滤镜
```swift
// 4.颜色叠层滤镜
public func overlaid(color: UIColor) -> CIImage {
    let overlay = generated(color: color)
    return overlay.compositeSource(over: self)
}
```

# Contact
QQ: 2256472253<br>
Email: ixialuo@126.com

# License
ICycleView is released under the MIT license. [See LICENSE](LICENSE) for details.
