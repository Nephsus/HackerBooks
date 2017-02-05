//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 25/1/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit
import Foundation

class LibraryTableViewController: UITableViewController, ProcessingBooksProtocol, TableRefresh {
    
    
    var model : Library
    
    var currentOverlay : UIView?
    
    static let defaultImageAsData = try! Data(contentsOf: Bundle.main.url(forResource: "noImage", withExtension: "png")!)

    public static let changeBookNotification = Notification.Name(rawValue: "changeBookSelected" )
    public static let keyNotification = Notification.Name(rawValue: "newBookSelected" ) 
   
    init(library model: Library){
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeChangeStateBook()
       if model.books.isEmpty {
                self.show((self.navigationController?.view)!, loadingText: "Cargando")
        }
        
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return model.books.countBuckets
    
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return model.getNumberBooksSection(byIndexSection: section)
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellId = "HackerBooksCell"
        let book = model.getNumberBook(byIndexSection: indexPath.section, andRowIndex: indexPath.row)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: cellId)
        }

        let asyncData = AsyncData(url: URL(string: book.urlImage)!, defaultData: LibraryTableViewController.defaultImageAsData, imageView: (cell?.imageView)!)
        //configurarla
        asyncData.delegate = self
        cell?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cell?.imageView?.clipsToBounds = true
        cell?.imageView?.image =  UIImage(data: asyncData.data)
        
        
        cell?.textLabel?.text = book.title
        cell?.detailTextLabel?.text =  book.authors.joined(separator: ", ")
        
        //Devolverla


        return cell!
    }
    
    
   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.getNameSection( byIndexSection: section )
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let book = model.getNumberBook(byIndexSection: indexPath.section, andRowIndex: indexPath.row)
        
        
        let  detail = DetailBookControllerViewController(WithModel: book)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Volver", style: .plain, target: nil, action: nil)

        
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                self.navigationController?.pushViewController(detail, animated: true)
            case .pad:
                notification(withBookSelected: book)
            default:
                notification(withBookSelected: book)
        }
        
        
    }
    
   

    
    func ProcessingComplete( newModel model: Library ) -> Void{
        //refrescamos los datos
        
        self.model = model
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hiddeProgressView()
        }
        
    
    }
    
    func hiddeProgressView() -> Void {
        if currentOverlay != nil {
            currentOverlay?.removeFromSuperview()
            currentOverlay =  nil
            self.navigationController?.view.isUserInteractionEnabled = true
           }
    }
    
    
    // MARK: - ShowLoaderFunction
     func show(_ overlayTarget : UIView, loadingText: String?) {
        // Clear it first in case it was already shown
         self.navigationController?.view.isUserInteractionEnabled = false
        
        // Creamos la capa que cubre la pantalla
        let overlay = UIView(frame: overlayTarget.frame)
        overlay.center = overlayTarget.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubview(toFront: overlay)
        
        // Creamos el activity indicator
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicator.center = overlay.center
        
        indicator.startAnimating()
        overlay.addSubview(indicator)
        
    
        if let textString = loadingText {
            let label = UILabel()
            label.text = textString
            label.textColor = UIColor.white
            label.sizeToFit()
            label.center = CGPoint(x: indicator.center.x, y: indicator.center.y + 30)
            overlay.addSubview(label)
        }
        
        // Animamos el spinner
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 0 ? 0 : 0.5
        UIView.commitAnimations()
        
        currentOverlay = overlay
    }
    
    //MARK: Protocolo de refresco debido a un cambio de estado del libro
    func reloadDataByRefreshState(book: Book) {
       self.model.syncBookFavorite(book: book)
        
         DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    
    }
    
    
    //MARK: Ciclelyfe
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "HACKERBOOKS"
        subscribe()
    
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
        unsubscribeChangeStateBook()
    }

    
    
}


extension LibraryTableViewController{
    
    func subscribe(){
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: AppDelegate.notificationName,
                       object: nil, queue: OperationQueue.main) { (nc) in
                        //Recibimos una notificación de que nos van a cerrar,
                        //así que salvamos el modelo para persistir los datos
                        
                        self.model.persistanceToDisk()     
        }
        
    }
    
    func unsubscribe(){
        let nc = NotificationCenter.default
        
        nc.removeObserver(self)
        
    }
}

extension LibraryTableViewController: AsyncDataDelegate{
    
    func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL) -> Bool {
        // nos pregunta si puede haer la descarga.
        // por supuesto!
        return true
    }
    
   
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL, withImage image: UIImageView) {
        // la tengo!
       let dataImage = try? Data(contentsOf: url)
       
        
        
        // la actualizo, y encima con una animación (más en el avanzado)
       UIView.transition(with: image,
                          duration: 0.7,
                          options: [.transitionCrossDissolve],
                          animations: {
                            // cambio la imagen
                            image.image = UIImage(data: dataImage!)
                            image.clipsToBounds = true
                            
                            
        }, completion: nil)
        
        
    }
    
}

extension LibraryTableViewController{

    func notification(withBookSelected book: Book){
        
        //Creas una instancia del NotificacionCenter
        let nc = NotificationCenter.default
        // Creas un objeto notification
        let notification = Notification(name: LibraryTableViewController.changeBookNotification,
                                        object: self, userInfo: [ LibraryTableViewController.keyNotification: book])
        
        nc.post( notification )
}




}


extension LibraryTableViewController{
    
    func subscribeChangeStateBook(){
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: DetailBookControllerViewController.favoriteBookNotification,
                       object: nil, queue: OperationQueue.main) { (nc) in
                        let userInfo = nc.userInfo
                        let book = userInfo?[DetailBookControllerViewController.keyFavorite ]
                        self.reloadDataByRefreshState(book:  book as! Book)
      
                        
        }
        
    }
    
    func unsubscribeChangeStateBook(){
        let nc = NotificationCenter.default
        
        nc.removeObserver(self)
        
    }
    
    
    
}




