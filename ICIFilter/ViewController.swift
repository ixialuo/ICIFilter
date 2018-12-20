//
//  ViewController.swift
//  ICIFilter
//
//  Created by xialuo on 2018/12/20.
//  Copyright © 2018 https://ixialuo.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var coreImageViews: [UIImageView]!
    
    @IBOutlet var filterImageViews: [UIImageView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreImageExtension()
        
        filterImageHigherOrderFunctions()
    }

    // 延展方式
    func coreImageExtension() {
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
    }
    
    // 高阶函数方式
    func filterImageHigherOrderFunctions() {
        if let url = URL(string: "https://via.placeholder.com/300x180/62abe4/ffffff?text=IFilter"), let image = CIImage(contentsOf: url) {
            
            // 原图
            filterImageViews[0].image = UIImage(ciImage: image)
            
            // 高斯模糊滤镜
            filterImageViews[1].image = UIImage(ciImage: blur(radius: 2)(image))
            /**
            // 对应的延展方式实现同样效果
            filterImageViews[1].image = UIImage(ciImage: image.blurred(radius: 2))
            */
            
            // 颜色生成滤镜
            let color = UIColor.orange.withAlphaComponent(0.4)
            filterImageViews[2].image = UIImage(ciImage: generate(color: color)(image))
            /**
            // 对应的延展方式实现同样效果
            filterImageViews[2].image = UIImage(ciImage: image.generated(color: color))
            */
            
            // 颜色叠层滤镜
            filterImageViews[3].image = UIImage(ciImage: overlay(color: color)(image))
            /**
            // 对应的延展方式实现同样效果
            filterImageViews[3].image = UIImage(ciImage: image.overlaid(color: color))
            */
            
            // 复合函数组合滤镜
            let blurAndOverlay1 = compose(filter: blur(radius: 2), with: overlay(color: color))
            filterImageViews[4].image = UIImage(ciImage: blurAndOverlay1(image))
            /**
            // 对应的延展方式实现同样效果
            filterImageViews[4].image = UIImage(ciImage: image.blurred(radius: 2).overlaid(color: color))
            */
            
            // 自定义运算符组合滤镜
            let blurAndOverlay2 = blur(radius: 2) >>> overlay(color: color)
            filterImageViews[5].image = UIImage(ciImage: blurAndOverlay2(image))
            /**
            // 对应的延展方式实现同样效果
            filterImageViews[5].image = UIImage(ciImage: image.blurred(radius: 2).overlaid(color: color))
            */
        }
    }
}

