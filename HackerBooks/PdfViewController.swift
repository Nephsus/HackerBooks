//
//  PdfViewController.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 4/2/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController {
    var model : Book
    
     static let defaultImageAsData = try! Data(contentsOf: Bundle.main.url(forResource: "pdftest", withExtension: "pdf")!)
    
    @IBOutlet weak var webView: UIWebView!
    
    init(book: Book) {
        self.model = book
       
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backItem?.title = "Volver";
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        syncModelView()
        subscribe()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribe()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func syncModelView(){
    
    let asyncData = AsyncData(url: URL(string:self.model.urlPdf)!, defaultData: PdfViewController.defaultImageAsData)
    asyncData.delegate = self
    webView.load( asyncData.data, mimeType: "application/pdf",
    textEncodingName: "utf8", baseURL: URL(string:"http://www.google.com")!)
    
    }
    

}


extension PdfViewController: AsyncDataDelegate{
    
    func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL) -> Bool {
        // nos pregunta si puede haer la descarga.
        // por supuesto!
        return true
    }
    
    func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL) {
        // Nos avisa que va a empezar
        print("Viá a empezar a descargar del remoto: \(url)")
    }
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        // la tengo!
        let data = try? Data(contentsOf: url)
        
        webView.load( data!, mimeType: "application/pdf",
                      textEncodingName: "utf8", baseURL:  URL(string:"http://www.google.com")!)
    }
    
}


extension PdfViewController{
    
    func subscribe(){
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: LibraryTableViewController.changeBookNotification,
                       object: nil, queue: OperationQueue.main) { (nc) in
                        //self.syncModelView()
                        let userInfo = nc.userInfo
                        let book = userInfo?[LibraryTableViewController.keyNotification ]
                        self.model = book as! Book
                        self.syncModelView()
        }
        
    }
    
    func unsubscribe(){
        let nc = NotificationCenter.default
        
        nc.removeObserver(self)
        
    }
    
    
    
}


