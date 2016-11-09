//
//  NUSPESCViewController.swift
//  Doner
//
//  Created by Anuar's mac on 14.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class NUSPESCViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage! = nil
    var imageView: UIImageView! = nil
    var textView: UITextView! = nil
    
    var imageView2: UIImageView! = nil
    var textView2: UITextView! = nil
    
    let padding: CGFloat = 10.0
    
    let part1 = "Nazarbayev University SPE Student Chapter was established on October 28, 2013. Currently more than 170 members are involved. The vision of NU SPE SC is to be an excellent performing society that provides its members with the highest quality lifelong knowledge of oil and gas industry and stimulates continuous personal and professional development. Our club is more than a Student Chapter! We are the first step to the fabulous engineering career of our members. From the first days of our chapter’s establishment at the university, our chapter tried to organize many events that will help our students to develop. In the period of 2013-2014 NU SPE SC got the “Outstanding Chapter” reward. Also, in 2014 and 2015 we were recognized as “The best academic club” and “The best student development club” of our university. Each year, all these honors were stimulating us to work harder, to be innovative and to do everything to bright the social life of NU community. Come and join our family! Think Big! Think Smart! Think SPE! \n\n"
    let part2 = "Our members \n\u{2022} More than 250 active members \nActivities\n\u{2022} Technical lectures Soft skills lectures \n\u{2022} Research Workshops \n\u{2022} Intellectual games \n\u{2022} Conferences and forums \n\u{2022} Entertaining events \n\u{2022} Fieldtrips \n\n Achievements\n\u{2022} 2013-2014 “Outstanding Chapter” among student chapters all over the world\n\u{2022} 2014 “The best academic club” at Nazarbayev University\n\u{2022} 2015 “The best student development club” at Nazarbayev University\n\u{2022} 2014-2016 Participants of international game “Petrobowl”. Petrobowl is a competition of SPE Student chapter teams all over the world, where they play against each other in a series of quick – fire rounds, answering technical and nontechnical industry-related questions.\n\nOpportunities\n\u{2022} Improvement of your knowledge in oil and gas industry\n\u{2022} Possibility to pass the internship in international company\n\u{2022} Being a part of “Petrobowl” team\n\u{2022} Improvement of your social skills\n\nOur Board\n\n\u{2022} President – Akzhan Arystanov\n\u{2022} Vice-President – Nazerke Marat\n\u{2022} External affairs manager – Yerik Tassanbayev\n\u{2022} Treasurer – Nardana Bazybek\nSecretrary – Dinara Junuskaliyeva\n\u{2022} Science manager – Aslan Tabyldiev\n\u{2022} Science manager–Bauyrzhan Ibragimov\n\u{2022} Event manager – Amanzhol Daribay\n\u{2022} Event manager – Miras Yeleshov\n\u{2022} Event manager – Alena Sorokina\n\u{2022} Designer – Meruyet Bazhanova\n\u{2022} Pr manager – Telkozha Mustafa\n\u{2022} Pr manager – Anuar Sarsembinov \n\n Contacts\nFollow us on:\nhttp://vk.com/nu_spe\n\nhttps://www.facebook.com/nu.spe.sc\n\nhttps://twitter.com/NU_SPE_SC\n\nhttp://instagram.com/nu_spe_sc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        let size = self.view.frame.width - 2 * padding
        let imageSize = size * 0.75
        let imagepaddingX = (self.view.frame.width - imageSize) / 2
        let imagepaddingY = imagepaddingX / 2
        
        // adding image
        image = UIImage(named: "history")
        imageView = UIImageView(image: image)
        imageView.contentMode = .ScaleAspectFill
        imageView.frame = CGRect(x: imagepaddingX, y: imagepaddingY, width: imageSize, height: imageSize)
        scrollView.addSubview(imageView)
        
        // adding text view
        textView = UITextView()
        textView.scrollEnabled = false
        textView.textAlignment = .Natural
        textView.frame = CGRect(x: padding, y: imagepaddingY + padding + imageView.frame.height, width: size, height: 0)
        
        textView.font = .systemFontOfSize(20)
        textView.text = part1
        textView.userInteractionEnabled = true // default: true
        textView.editable = false // default: true
        textView.selectable = true // default: true
        textView.dataDetectorTypes = [.Link]
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        
        scrollView.addSubview(textView)
        
        // adding image
        image = UIImage(named: "history2")
        imageView2 = UIImageView(image: image)
        imageView2.contentMode = .ScaleAspectFill
        imageView2.frame = CGRect(x: imagepaddingX, y: 3 * padding + textView.frame.height + imageView.frame.height, width: imageSize, height: imageSize)
        scrollView.addSubview(imageView2)
        
        // adding text view
        textView2 = UITextView()
        textView2.scrollEnabled = false
        textView2.textAlignment = .Natural
        textView2.frame = CGRect(x: padding, y: 4 * padding + textView.frame.height + imageView2.frame.height + imageView.frame.height, width: size, height: 0)
        
        textView2.font = .systemFontOfSize(20)
        textView2.text = part2
        textView2.userInteractionEnabled = true // default: true
        textView2.editable = false // default: true
        textView2.selectable = true // default: true
        textView2.dataDetectorTypes = [.Link]
        
        let fixedWidth2 = textView2.frame.size.width
        textView2.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.max))
        let newSize2 = textView2.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.max))
        var newFrame2 = textView2.frame
        newFrame2.size = CGSize(width: max(newSize2.width, fixedWidth2), height: newSize2.height)
        textView2.frame = newFrame2
        
        scrollView.addSubview(textView2)
        scrollView.contentSize = CGSize(width: view.frame.width, height: imageView.frame.height + textView.frame.height + imageView2.frame.height + textView2.frame.height)
    }
}
