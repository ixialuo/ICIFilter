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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


}

