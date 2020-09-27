//
//  ViewController.swift
//  RadioStation_Carlos
//
//  Created by cmu on 03/05/2020.
//  Carlos H García Castrillón
//  Copyright © 2020 UPV. All rights reserved.
//

import UIKit

class TagsViewController: UITableViewController {

   //var tempTags = ["Jazz", "Blues", "Classical", "Country"]
   var tempTags = [""]
    var tags: [Tag]?
    
    //paso 10 pag 53
    @IBAction func btn_favoritos(_ sender: Any) {
     let favStations:[Station]? = RadioAPI.fetchFavouriteStations() ?? []
        
        performSegue(withIdentifier: "showFavorites", sender: favStations)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        //asociar el archivo tagcell.xib con view cell pag 9 paso 1
        tableView.register(UINib(nibName: "TagCell", bundle:nil), forCellReuseIdentifier: "TagCell")
        
        tableView.rowHeight = 105
        //pag 17 las etiquetas del API
         RadioAPI.getTags(){ tags in
                self.tags = tags
                if self.tags != nil && self.tags!.count>0 {
                  DispatchQueue.main.async  {
                    self.tableView.reloadData()
                  }//cierra dispatch
                }//cierra if self count
            }//cierra RadioAPI
        print("tag vista")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        let fondo = UIImage(named: "fondo-homero.jpg")
        let imageView = UIImageView(image: fondo)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.frame = self.tableView.bounds
        self.tableView.backgroundView = imageView
        //para modificar colores del navigation bar e item tags
        /*self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.brown]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.brown] //
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance*/
    }
    
    func carga_tags(_ tags1: [Tag]) -> Void {
        print("carga_tags")
        tags = tags1
        //self.tableView.reloadData()
    }
    
    //MARK: Navigation a show stations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showStationsForTag",
            let stationsVC = segue.destination as? StationsViewController {
            guard let selectedTag = sender as? Tag else {return}
            stationsVC.tag = selectedTag
        } else if segue.identifier == "showFavorites" {
            guard let stationsVC = segue.destination as? StationsViewController else {return}
            guard let estacion_seleccionada = sender as? [Station] else {return}
            stationsVC.stations = estacion_seleccionada
            
        }
    }
}
// MARK: Table View delegate
extension TagsViewController {

 override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
 {print("segue show \(tags![indexPath.row])")
 performSegue(withIdentifier: "showStationsForTag", sender: tags![indexPath.row])
         }
}

// MARK: Table view source
extension TagsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // cantidad de filas de la tabla
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print(tempTags.count)
       // return tempTags.count
        if tags != nil {
            return tags!.count
        }
        return 0
    }
    
    //informacion de la celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    { if let celda = tableView.dequeueReusableCell(withIdentifier: "TagCell") as! TagCell?
    {
        let tem = tags![indexPath.row]
        print("tags:- \(tem)")
        celda.setup(tags![indexPath.row])
     return celda
     }
         return UITableViewCell()
    }
    
    // modificar el aspecto de cada celda
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        var color:UIColor
        
        if indexPath.row % 2 == 0 {
            color = UIColor(white: 1, alpha: 0.65)
        } else {
            color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        }
         
        cell.backgroundColor = color
    }
}
