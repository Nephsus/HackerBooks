//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 24/1/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static let notificationName = Notification.Name(rawValue: "ShavalesQueNosAPAGAN¡¡¡¡" )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
       
       
        
        /*if !MyFileManager.existFileInDocumentFolder(withName: UtilsStatics.FILENAMERESOURCELIBRARY ) {
           
            libraryVC = LibraryTableViewController(library: Library() )
            let service = DownloadTaskService()
            let closure : completionLoaderTask = {(data, urlResponse, error) in
                
                //PROCESO DE DESCARGA DEL FICHERO
                let fileManager = FileManager.default
                var ulrToDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                ulrToDocuments.appendPathComponent( UtilsStatics.FILENAMERESOURCELIBRARY )
                
                let dataDownloaded = decodeInitializer(withDataJson: data!)
                
                try! dataDownloaded.write(to: ulrToDocuments, options: .atomic)
                
                
                do {
                    let newModel =  try self.loadModelfromFile( )
                    libraryVC?.ProcessingComplete(newModel: newModel)
                } catch let err as NSError {
                    print("\(err)")
                    return
                }
            }
            
            try? service.download(endpoint: UtilsStatics.URLJSONRESOURCEBOOKS, withCompletionLoaderTask: closure)
        }else{
            do {
               libraryVC =  try LibraryTableViewController(library: loadModelfromFile() )
            } catch let err as NSError {
                print("\(err)")
                return false
            }
           
        }*/

        do {
            if !MyFileManager.existFileInDocumentFolder(withName: UtilsStatics.FILENAMERESOURCELIBRARY ){
                    try downLoadFileAndSave()
            }
            let model = try loadModelfromFile()
            let libraryVC = LibraryTableViewController(library: model )
            
            //Arrancamos de diferente forma, en función de si es un iphone o iphone
            
            
            
            let detail = DetailBookControllerViewController(WithModel: model.getNumberBook(byIndexSection: 0, andRowIndex: 0))
            let navigationController = UINavigationController(rootViewController: libraryVC)
            
            let navigationControllerDetail = UINavigationController(rootViewController: detail)
            let splitVC = UISplitViewController()
            
            
            
            
            
            splitVC.viewControllers = [ navigationController, navigationControllerDetail ]
            
            self.window?.rootViewController = splitVC
            
            self.window?.makeKeyAndVisible()
            
        } catch {
            return false
        }
        
        
       

        return true
    }
    
    func downLoadFileAndSave() throws -> Void {
    
        do {
            let data = try Data(contentsOf: UtilsStatics.URLJSONRESOURCEBOOKS)
            let fileManager = FileManager.default
            var ulrToDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            ulrToDocuments.appendPathComponent( UtilsStatics.FILENAMERESOURCELIBRARY )
            let dataDownloaded = decodeInitializer(withDataJson: data)
            
            try! dataDownloaded.write(to: ulrToDocuments, options: .atomic)
        } catch {
            throw ErrorsHackerBooks.errorDownloadFile
        }
    
    }
    
    
    
    func loadModelfromFile() throws -> Library{
        //PROCESO DE LECTURA
        let fileManagerD = FileManager.default
        var ulrToDocumentsD = fileManagerD.urls(for: .documentDirectory, in: .userDomainMask)[0]
        ulrToDocumentsD.appendPathComponent( UtilsStatics.FILENAMERESOURCELIBRARY )
        
        let readData = try? Data(contentsOf: ulrToDocumentsD, options: .mappedIfSafe)
        
        guard let saveDate = readData else {
            print("la cagamos compadre")
            throw ErrorsHackerBooks.lectureErrorofJsonFile
        }
        
        
        let model : Library =  decode(withDataJson: saveDate)
        
        return model
        
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //Corre¡ que vienen con el machete cubano¡¡¡¡
        sendNotificationAppDisappear()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //Corre¡ que vienen con el machete cubano¡¡¡¡
        sendNotificationAppDisappear()
        
    }
    
    func sendNotificationAppDisappear(){
    
        //Creas una instancia del NotificacionCenter
        let nc = NotificationCenter.default
        // Creas un objeto notification
        let notification = Notification(name: AppDelegate.notificationName, object: self, userInfo: nil)
        
        nc.post( notification )

    
    
    }
    
    
}

