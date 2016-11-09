//
//  HistoryViewController.swift
//  Doner
//
//  Created by Anuar's mac on 14.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage! = nil
    var imageView: UIImageView! = nil
    var titleView: UITextView! = nil
    var textView: UITextView! = nil
    var subview: UIView! = nil
    
    let padding: CGFloat = 10.0
    
    var text = "In 1957, the organization was officially founded as SPE, a constituent society of AIME. SPE became a separately incorporated organization in 1985. Our history begins within the American Institute of Mining Engineers (AIME). AIME was founded in 1871 in Pennsylvania, USA, to advance the production of metals, minerals, and energy resources through the application of engineering. In 1913, a standing committee on oil and gas was created within AIME and proved to be the genesis of SPE. The Oil and Gas Committee of AIME soon evolved into the Petroleum Division of AIME as membership grew and as interest among the members was more clearly delineated among the mining, metallurgical, and petroleum specializations. \n\n\n1960s\n The new society developed products and services to address the technical interests of its growing membership. \n\n1970s\n Membership grew rapidly, doubling by the end of the decade. The first Long Range Plan was implemented, and helped the Society map out its future for the decade to come. \n\n1980s\n The industry suffered a downturn and roughly half of all jobs were lost. However, SPE membership remained stable, even experiencing growth, throughout the decade. \n\n1990s\n SPE became more culturally diverse as the growth rate of international sections increased. SPE also became more technologically far-reaching with the introduction of international Forums and the launch of SPE.org. \n\n2000s\n SPE reached its highest number of members in its history, partly due to the high growth rate in the number of student members and chapters. Today SPE continues its constant search for new ways to meet member needs in all phases of their careers in all parts of the world."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        
        let subview = UIView(frame: scrollView.frame)
        let size = self.view.frame.width - 2 * padding
        let imageSize = size * 0.75
        let imagepaddingX = (self.view.frame.width - imageSize) / 2
        let imagepaddingY = imagepaddingX / 2
        
        // adding image
        image = UIImage(named: "spe-logo")
        imageView = UIImageView(image: image)
        view.backgroundColor = .mainColor()
        imageView.contentMode = .ScaleAspectFill
        imageView.frame = CGRect(x: imagepaddingX, y: imagepaddingY, width: imageSize, height: imageSize)
        subview.addSubview(imageView)

        // adding text view
        textView = UITextView()
        textView.scrollEnabled = false
        textView.font = .systemFontOfSize(18)
        textView.text = text
        textView.textColor = .whiteColor()
        textView.backgroundColor = .mainColor()
        textView.textAlignment = .Natural
        textView.frame = CGRect(x: padding, y: imagepaddingY + padding + imageView.frame.height, width: size, height: 0)
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame

        subview.addSubview(textView)
        
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: imageView.frame.height + textView.frame.height)
        scrollView.addSubview(subview)
    }
}
