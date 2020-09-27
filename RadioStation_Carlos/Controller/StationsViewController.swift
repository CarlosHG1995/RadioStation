//
//  StationsViewController.swift
//  RadioStation_Carlos
//
//  Created by cmu on 06/05/2020.
//  Copyright © 2020 UPV. All rights reserved.
//

import UIKit

class StationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tabla_station: UITableView!
    
    //var datosStation = ["Station 1", "Station 2", "Station 3"]
    //var tag: String?//paso 4 pag 22
    //var estaciones:[Station]?
    var tag: Tag?
    var stations: [Station]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //data source y delegate de la tabla, además de llamar la celda customizada
        tabla_station.delegate = self
        tabla_station.dataSource = self
        tabla_station.register(UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: "StationCell")
        tabla_station.rowHeight = 105
        
          
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        let fondo = UIImage(named: "fondo-homero.jpg")
        let imageView = UIImageView(image: fondo)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.frame = self.tabla_station.bounds
        self.tabla_station.backgroundView = imageView

        //pag 22
        //self.navigationItem.title = tag?.name.replacingOccurrences(of:"#", with:"").uppercased() ?? "Info por defecto."
     
      self.navigationItem.title = tag?.name.replacingOccurrences(of:"#", with:"").uppercased() ?? "Favoritos"
        /*self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.red]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.red] // With a red background, make the title more readable.
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance*/
      //self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
        if let tag = tag {
                       let stationsURL = RadioAPI.stationsForTagURL(categoryID: tag.name)
                       print("nombre url \(stationsURL)")
                       RadioAPI.getStations(for: tag.name){ stations in
                           //actualiza model
                           self.stations = stations
                           //actualiza table view
                           if self.stations != nil && self.stations!.count > 0 {
                               DispatchQueue.main.async {
                                   self.tabla_station.reloadData()
                               }
                           }
                       }
        }else {
            //al cerrar el Radio player se actualice de inmediato stations view y no muestre la emisora favorita eliminada
            self.stations = RadioAPI.fetchFavouriteStations() ?? []
            tabla_station.reloadData()
            print("Favoritos actualizados")
        }
    }
    

    /* */
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showPlayer"
        {
            guard let rpVC = segue.destination as? RadioPlayerViewController else { return }
            guard let selectedTag = sender as? Station else {return }
                       rpVC.station = selectedTag
        }
    }
   
    //cantidad de secciones en la tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // cantidad de filas de la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         //print(datosStation.count)
        //return datosStation.count
        if stations != nil {
            return stations!.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      /*  let celda = UITableViewCell()
        celda.textLabel?.text = datosStation[indexPath.row]
        return celda*/
        
        if let celda = tableView.dequeueReusableCell(withIdentifier: "StationCell") as! StationCell?
        {let estaciones = stations![indexPath.row]
            print("emisoras:- \(estaciones)")
            celda.setup_emisora_list(stations![indexPath.row])
            return celda
        }
        
        return UITableViewCell()
        
    }

    // modificar el aspecto de cada celda
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        var color:UIColor
        
        if indexPath.row % 2 == 0 {
            color = UIColor(white: 1, alpha: 0.65)
        } else {
            color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        }
         
        cell.backgroundColor = color
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("stations vc \(stations![indexPath.row])")

        performSegue(withIdentifier: "showPlayer", sender: stations![indexPath.row])
        
    }

}
