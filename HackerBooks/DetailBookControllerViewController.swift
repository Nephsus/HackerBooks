//
//  DetailBookControllerViewController.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 2/2/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit

class DetailBookControllerViewController: UIViewController {

   
    var model : Book
    
    public static let favoriteBookNotification = Notification.Name(rawValue: "favoriteBookChangeState" )
    public static let keyFavorite = Notification.Name(rawValue: "keyBookChangeState" )


    
    weak var delegado : TableRefresh? = nil
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbAuthors: UILabel!
    
    @IBOutlet weak var lbTags: UILabel!
    

    @IBOutlet weak var btnPDF: UIButton!

    @IBOutlet weak var btnFavoriteOutlet: UIButton!

    @IBOutlet weak var coverImage: UIImageView!
    
    @IBAction func pdfClick(_ sender: AnyObject) {
        
        let pdfView = PdfViewController(book: model )
        self.navigationController?.pushViewController(pdfView, animated: true)

        
    }
    
    
    @IBAction func btnFavorite(_ sender: AnyObject) {
        if model.isFavorite == "true" {
            model.isFavorite = "false"
            sender.setImage( UIImage(named: "btn_check_off_holo_dark_triodos")   , for: .normal)
        
        }else{
             model.isFavorite = "true"
            sender.setImage( UIImage(named: "btn_check_on_holo_dark_triodos")   , for: .normal)
           
        }
        
         notification()       
        guard let haveDelegate = self.delegado else {
            return
        }
        
        haveDelegate.reloadDataByRefreshState( book: model )
       
    }
    
    
    init(WithModel model: Book){
      self.model = model
      super.init(nibName: nil, bundle: nil)
      
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Volver", style: .plain, target: nil, action: nil)
        syncModelView()
        subscribe()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
    }
    
    
    func syncModelView()  {
        self.title = model.title
        self.lbTitle.text = model.title
        self.lbAuthors.text = model.authors.joined(separator: ",")
        self.lbTags.text = model.tags.joined(separator: ",")
        
        if model.isFavorite == "true" {
            btnFavoriteOutlet.setImage( UIImage(named: "btn_check_on_holo_dark_triodos")   , for: .normal)
            
        }else{
            btnFavoriteOutlet.setImage( UIImage(named: "btn_check_off_holo_dark_triodos")   , for: .normal)
            
        }
        
        let asyncData = AsyncData(url: URL(string: model.urlImage)!, defaultData: LibraryTableViewController.defaultImageAsData)
        //configurarla
        asyncData.delegate = self
        
        coverImage.image = UIImage(data: asyncData.data)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}


extension DetailBookControllerViewController: AsyncDataDelegate{
    
    
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        let dataImage = try? Data(contentsOf: url)
        
        self.coverImage.image = UIImage(data: dataImage!)
        self.coverImage.clipsToBounds = true

        
        
    }
    
}



extension DetailBookControllerViewController{
    
    func subscribe(){
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: LibraryTableViewController.changeBookNotification,
                       object: nil, queue: OperationQueue.main) { (nc) in
                        //self.syncModelView()
                        let userInfo = nc.userInfo
                        let char = userInfo?[LibraryTableViewController.keyNotification ]
                        self.model = char as! Book
                        self.syncModelView()
        }
        
    }
    
    func unsubscribe(){
        let nc = NotificationCenter.default
        
        nc.removeObserver(self)
        
    }
    
    
    func notification(){
        
        //Creas una instancia del NotificacionCenter
        let nc = NotificationCenter.default
        // Creas un objeto notification
        let notification = Notification(name: DetailBookControllerViewController.favoriteBookNotification,
                                        object: self, userInfo: [ DetailBookControllerViewController.keyFavorite : model])
        
        nc.post( notification )
    }
    
}


