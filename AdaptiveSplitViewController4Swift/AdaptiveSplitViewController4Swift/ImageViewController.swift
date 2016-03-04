//
//  ImageViewController.swift
//  Cassini
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{
    // наша Model
    // устанавливается извне (publicly)
    // если она меняется (но только если мы на экране)
    //   делаем выборку image по imageURL
    // если мы не на экране, когда это происходит (view.window == nil)
    //   viewWillAppear будет делать это за нас позже
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    // выбираем image по imageURL
    // делаем это за пределами main thread
    // затем размещаем блок, возвращающий нас в main queue
    //   для размещения image на UI
    //   (так как нам не разрешено что-то делать с UI где-то еще, кроме main queue)
    private func fetchImage()
    {
        autoZoomed = true
        if let url = imageURL {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                
                // это блокирует поток, на котором это выполняется
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    
                    // делаем что-то с этим image только в том случае
                    // если url, которое мы выбрали является текущим imageURL, 
                    // который нам нужен (он может измениться, пока мы выбирали его)
                    // переменная "url" "захвачена" из внешнего контекста
                    if url == self.imageURL {
                        if imageData != nil {
                            
                            // мы можем потерять время, если наш MVC не в 
                            // поле зрения пользователя,
                            // это может произойти, если кто-то нажмет кнопку Back
                            // или уберет нас из splitView или navigation controller
                            // пока мы заняты выборкой image
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    

  
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size // critical to set this!
            scrollView.delegate = self                    // обязателен для zooming
            scrollView.minimumZoomScale = 0.03            // обязателен для zooming
            scrollView.maximumZoomScale = 5.0             // обязателен для zooming
        }
    }
    
    // UIScrollViewDelegate method
    // обязателен для zooming
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // Убираем автоматическую "подгонку" после того, как пользователь выполняет zoom
    // с помощью жеста pinching
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        autoZoomed = false
    }
  

    private var imageView = UIImageView()
    private var autoZoomed = true
    
    // удобное вычисляемое свойство
    // это свойство "работает" всякий раз,когда мы устанавливаем image в imageView
    // мы можем делать такие вещи, как изменение размера imageView,
    //   установка свойства contentSize для scrollView
    //   и остановка spinner
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            //----
            // в портретной ориентации на iPad в split view,
            //   к сожалению, master может быть доступен при открытом Popover
            //   (поэтому удаляем старый Popover, если кто-то изменил imageURL)
            if ((self.presentedViewController) != nil) {
                self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            //----

            spinner?.stopAnimating()
            autoZoomed = true
            zoomScaleToFit()

        }
    }
    
    // размещаем наше imageView в иерархии views
    // как subview scrollView
    // (установим его в контентную область scrollView)
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    // для эффективности мы будем осуществлять актуальную выборку image
    // когда мы точно знаем, что появимся на экране
    override func viewWillAppear(animated: Bool) {
       super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
      }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        zoomScaleToFit()
    }

    // Рассчитывает zoom масштаб для "подгонки" изображения к размеру экрана,
    // но без пустых (белых) зазоров
    private func zoomScaleToFit()
    {
    // если мы все еще в режиме "подгонки" (autoZoomed), то устанавливаем 
    // свойство zoomScale только при условии, что геометрия полностью загружена
        if !autoZoomed {
            return
        }
        if let sv = scrollView where image != nil && (imageView.bounds.size.width > 0)
                                                  && (scrollView.bounds.size.width > 0){
           
                let widthRatio = scrollView.bounds.size.width  / imageView.bounds.size.width
                let heightRatio = scrollView.bounds.size.height / self.imageView.bounds.size.height
                sv.zoomScale = (widthRatio > heightRatio) ? widthRatio : heightRatio
                sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2,
                                           y: (imageView.frame.size.height - sv.frame.size.height) / 2)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Получаем новый View Controller, используя segue.destinationViewController.
        // Передаем выбранный объект новому View Controller.
        if segue.identifier == "Show URL" {
            if let urlVC = segue.destinationViewController as? URLViewController {
                urlVC.url = self.imageURL
            }
        }
    }
}
