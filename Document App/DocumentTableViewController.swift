//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Maxence DUBOIS on 1/17/24.
//
import UIKit

extension Int {
    func formattedSize(int size: Int) -> String {
        let formatter = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
        return formatter
        
    }
}

struct DocumentFile {
    var title: String
    var size: Int
    var imageName: String? = nil
    var url: URL
    var type: String
    
    
    static var data: [DocumentFile]  {
        return listFileInBundle()
    }
}

func listFileInBundle() -> [DocumentFile] {
    
    let fm = FileManager.default // Initailisation de la gestion des fichiers
    let path = Bundle.main.resourcePath! // Indication du chemin vers DocumentApp
    let items = try! fm.contentsOfDirectory(atPath: path) // Récupération de toutes les images
    
    var documentListBundle = [DocumentFile]() // On définit une liste vide de type: DocumentFile
    
    for item in items { // Boucle sur chaque image
        if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") { // On filtre les images
            let currentUrl = URL(fileURLWithPath: path + "/" + item) // On récupére les propriétés de l'image
            let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            // On récupère les valeurs des propriétés de l'image
            documentListBundle.append(DocumentFile(
                title: resourcesValues.name!,
                size: resourcesValues.fileSize ?? 0,
                imageName: item,
                url: currentUrl,
                type: resourcesValues.contentType!.description) // On crée un objet DocumentFile avec les données que nous avons
                                      // récupéré
            )
        }
    }
    return documentListBundle
}




class DocumentTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DocumentFile.data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        
        let element = DocumentFile.data[indexPath.row]
        
        cell.textLabel?.text = element.title
        cell.detailTextLabel?.text = element.size.formattedSize(int: element.size)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let documentVC = segue.destination as? DocumentViewController {
            let selectedDocument = DocumentFile.data[indexPath.row]
            documentVC.imageName = selectedDocument.imageName
        }
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
