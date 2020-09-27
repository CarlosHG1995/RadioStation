//
//  RadioPlayerViewController.swift
//  RadioStation_Carlos
//
//  Created by cmu on 09/05/2020.
//  Copyright © 2020 UPV. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreData

class RadioPlayerViewController: UIViewController {
    
    var station: Station?
    //paso 8  pag 38
    enum PlayerState {
        case playing
        case paused
    }
    
    lazy var player: AVPlayer = {
        initAudioSession()
        return AVPlayer()
    }()
    //--
    //pag 46 favoritas 47
    enum FavState{
        case isFavorite
        case notFavorite
    }
    //-- termina ejecicio de implementar favoritos
    
    @IBOutlet weak var lbl_estado: UILabel!
    @IBOutlet weak var icono_emisora: UIImageView!
    @IBOutlet weak var icono_play: UIButton!
    @IBOutlet weak var vol_slider: UISlider!
    @IBOutlet weak var btn_mas: UIButton!
    @IBOutlet weak var lbl_tiempo_rep: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("stationes radio player \(station!)") 
       
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    /* esto tambien sirve para cambiar el color del navigation item bar
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.blue] // With a red background, make the title more readable.
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance*/
        self.navigationItem.title = station?.name.replacingOccurrences(of:"#", with:"").uppercased() ?? "Estación Radial"
    }
     
    @IBAction func btn_play(_ sender: UIButton) {
        if player.timeControlStatus == .playing {
            pauseStream()
            lbl_estado.text = "Estado de la emisora: en pausa"
            print("emisora pausada")
        }
        else {
              print("emisora en reproduccion")
            lbl_estado.text = "Estado de la emisora: en reproducción"
            playStream(from: station!.url_resolved)//"https://listen.radioking.com/radio/1906/stream/6029")//este  es de ejemplo
            }
    }
     
    
    @IBAction func volumen_slider(_ sender: UISlider) {
        //pag 39 ejericio
        changeVolume(value: vol_slider.value)
        player.volume =  vol_slider.value
        print("volumen: \(player.volume),")
        
    }
    
    @IBAction func btn_fav(_ sender: UIButton) {
        print("boton pulsado fav")
        if self.isFavorite == .isFavorite {
            removeFromFavorites()
        } else { addToFavourites() }
        
    }
    //pag 49
    var isFavorite: FavState!
    func setupView(){
        //paso 7 pag 36 item 3
        icono_emisora.imageFromURL(url: station?.favicon ?? "", defaultImage: "cartoon-radio")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StationEntity")
        let namePredicate = NSPredicate(format: "name == %@", station!.name)
        let isFavPredicate = NSPredicate(format: "isFavorite == %@", NSNumber(booleanLiteral: true))
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, isFavPredicate])
        fetchRequest.predicate = compoundPredicate
        do {
            let count = try context.count(for: fetchRequest)
            if count == 1 {
                updateFavoriteUI(for: .isFavorite)
                self.isFavorite = .isFavorite
            } else {
                self.isFavorite = .notFavorite
            }
        } catch let error {
            print("error setup view \(error)")
        }
    }
     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
extension RadioPlayerViewController {
    func initAudioSession(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: [])
            
            print("AVAudioSession activa")
          } catch let error {
            print("Error al reproducir emisora \(error)")
        }
    }
    
    
    func playStream(from url: String){
        guard let url = URL(string: url) else {return}
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        print("tiempo--  \(player.replaceCurrentItem(with: AVPlayerItem(url: url)))")
        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { timer in
            if self.player.currentItem?.status == .readyToPlay {
                let timeElapsed = CMTimeGetSeconds(self.player.currentTime())
                let sec = Int(timeElapsed)
                let ct = timeElapsed
                let cts = String(format: "%02d:%02d", sec/60, sec%60)
                 print("ct \(ct) \(cts)")
                self.lbl_tiempo_rep.text = "Tiempo en reproducción \(cts) segs"
            }
        }
        player.play()
        player.volume = vol_slider.value
        updatePlayerUI(for: .playing)
    }
    func pauseStream(){
        player.pause()
        updatePlayerUI(for: .paused)
    }
    func changeVolume(value: Float){player.volume =  vol_slider.value}
    func updatePlayerUI(for state: PlayerState){
        switch state {
        case .paused:
            icono_play.setImage(UIImage(named: "play-music_icon-icons.com_71385"), for: .normal)
        //music-pause-button_icon
        case .playing:
            icono_play.setImage(UIImage(named: "music-pause-button_icon"), for: .normal)
        }
    }
    func updateFavoriteUI(for state: FavState){
        switch state {
        case .isFavorite:
            //btn_mas.setImage(UIImage(named: "no_favorito"), for: .normal)
         UIView.transition(with: btn_mas, duration: 0.4, options: [.transitionFlipFromRight], animations: { self.btn_mas.setImage(UIImage(named: "no_favorito"), for: .normal)},completion: nil)
        case .notFavorite:
            UIView.transition(with: btn_mas, duration: 0.4, options: [.transitionFlipFromRight], animations: { self.btn_mas.setImage(UIImage(named: "favorito"), for: .normal)},completion: nil)
            //btn_mas.setImage(UIImage(named: "favorito"), for: .normal)
        }
    }
    func addToFavourites(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "StationEntity", in: context)!
        let stationRecord = NSManagedObject(entity: entity, insertInto: context)
        stationRecord.setValue(self.station?.name, forKey: "name")
        stationRecord.setValue(self.station?.favicon, forKey: "imageURL")
        stationRecord.setValue(true, forKey: "isFavorite")
        stationRecord.setValue(self.station?.url_resolved, forKey: "streamURL")
        
        appDelegate.saveContext()
        updateFavoriteUI(for: .isFavorite)
        self.isFavorite = .isFavorite
        //
    }
    
    //pag 51
       func removeFromFavorites() {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           let context = appDelegate.persistentContainer.viewContext
           
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StationEntity")
           fetchRequest.predicate = NSPredicate(format: "name == %@", station!.name)
           fetchRequest.fetchLimit = 1 // Redundant
           do {
               let record = try context.fetch(fetchRequest)
               record.first?.setValue(NSNumber(booleanLiteral: false), forKey: "isFavorite")
               appDelegate.saveContext()
               self.isFavorite = .notFavorite
               updateFavoriteUI(for: .notFavorite)
           } catch let error {
               print("error en removefrom favorites \(error)")
           }
       }
}
