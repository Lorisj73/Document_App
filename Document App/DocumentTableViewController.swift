//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Maxence DUBOIS on 1/17/24.
//
import UIKit
import QuickLook

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
    
    
    var bundleDocuments: [DocumentFile] = []
    
    for item in items { // Boucle sur chaque image
        if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") { // On filtre les images
            let currentUrl = URL(fileURLWithPath: path + "/" + item) // On récupére les propriétés de l'image
            let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            // On récupère les valeurs des propriétés de l'image
            bundleDocuments.append(DocumentFile(
                title: resourcesValues.name!,
                size: resourcesValues.fileSize ?? 0,
                imageName: item,
                url: currentUrl,
                type: resourcesValues.contentType!.description) // On crée un objet DocumentFile avec les données que nous avons
                                   // récupéré
            )
        }
    }
    return bundleDocuments
}

func listFileInDocumentApplication() -> [DocumentFile] {
    let fm = FileManager.default
    var importedDocuments: [DocumentFile] = []
    
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        do {
            let items = try fm.contentsOfDirectory(atPath: documentsDirectory.path)
            for item in items {
                if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {
                    let currentUrl = documentsDirectory.appendingPathComponent(item)
                    let resourcesValues = try currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                    
                    importedDocuments.append(DocumentFile(
                        title: resourcesValues.name!,
                        size: resourcesValues.fileSize ?? 0,
                        imageName: item,
                        url: currentUrl,
                        type: resourcesValues.contentType!.description)
                    )
                }
            }
        } catch {
            print("Erreur lors de la lecture des fichiers : \(error)")
        }
    }
    
    return importedDocuments
}



class DocumentTableViewController: UITableViewController, QLPreviewControllerDataSource, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            filterContentForSearchText(searchBar.text!)
        }
    
    
    var listDocumentBundle: [DocumentFile] = []
    var listDocumentImported: [DocumentFile] = []
    
    var searchController: UISearchController!
    var filteredBundleDocuments: [DocumentFile] = []
    var filteredImportedDocuments: [DocumentFile] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importDocument))
        listDocumentBundle = listFileInBundle()
        listDocumentImported = listFileInDocumentApplication()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Documents"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Deux sections : Bundle et Importations
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Bundle" : "Importations"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return section == 0 ? filteredBundleDocuments.count : filteredImportedDocuments.count
        }
        return section == 0 ? listDocumentBundle.count : listDocumentImported.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        let document: DocumentFile

        if isFiltering() {
            document = indexPath.section == 0 ? filteredBundleDocuments[indexPath.row] : filteredImportedDocuments[indexPath.row]
        } else {
            document = indexPath.section == 0 ? listDocumentBundle[indexPath.row] : listDocumentImported[indexPath.row]
        }

        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = document.size.formattedSize(int: document.size)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        
        if indexPath.section == 0 {
            // Si l'élément sélectionné est dans la section Bundle
            previewController.currentPreviewItemIndex = indexPath.row
        } else {
            // Si l'élément sélectionné est dans la section Importations
            // Ajuster l'index en prenant en compte la taille de la première section
            previewController.currentPreviewItemIndex = listDocumentBundle.count + indexPath.row
        }
        
        navigationController?.pushViewController(previewController, animated: true)
    }
    
    // MARK: - QLPreviewControllerDataSource
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return listDocumentBundle.count +  listDocumentImported.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        // Calculer l'index réel en fonction du nombre d'éléments dans la première section
        if index < listDocumentBundle.count {
            // L'index appartient à la première section (Bundle)
            let document = listDocumentBundle[index]
            return document.url as QLPreviewItem
        } else {
            // L'index appartient à la deuxième section (Importations)
            let adjustedIndex = index - listDocumentBundle.count
            let document = listDocumentImported[adjustedIndex]
            return document.url as QLPreviewItem
        }
    }
    
    @objc func importDocument() {
        // Implémentez ici la logique d'importation de documents
        // Par exemple, ouvrir un UIDocumentPickerViewController pour sélectionner des fichiers
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.content"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func copyFileToDocumentsDirectory(fromUrl url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        
        do {
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                try FileManager.default.removeItem(at: destinationUrl)
            }
            try FileManager.default.copyItem(at: url, to: destinationUrl)
        } catch {
            print("Erreur lors de la copie du fichier : \(error)")
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredBundleDocuments = listDocumentBundle.filter { document in
            return document.title.lowercased().contains(searchText.lowercased())
        }
        filteredImportedDocuments = listDocumentImported.filter { document in
            return document.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }

    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }

}

extension DocumentTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedUrl = urls.first else { return }
        
        do {
            let resourcesValues = try selectedUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            let newDocument = DocumentFile(
                title: resourcesValues.name!,
                size: resourcesValues.fileSize ?? 0,
                imageName: nil,
                url: selectedUrl,
                type: resourcesValues.contentType!.description
            )
            
            // Copier le fichier dans le répertoire des documents
            copyFileToDocumentsDirectory(fromUrl: selectedUrl)
            
            // Ajouter le nouveau document à la source de données
            listDocumentImported = listFileInDocumentApplication()
            
            // Mettre à jour la vue tableau
            tableView.reloadData()
        } catch {
            print("Erreur lors de la récupération des informations du document : \(error)")
        }
    }
}

