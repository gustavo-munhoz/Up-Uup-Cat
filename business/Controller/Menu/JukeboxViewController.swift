//
//  JukeboxViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/04/24.
//

import UIKit

class JukeboxViewController: UIViewController {
    
    private var jukeboxView = JukeboxView()
    
    override func loadView() {
        view = jukeboxView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jukeboxView.tableView.delegate = self
        jukeboxView.tableView.dataSource = self
        jukeboxView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .white
        navigationItem.hidesBackButton = false 
        
        let selectedTrack = UserPreferences.shared.selectedBackgroundMusic
        if let index = BackgroundMusic.allCases.firstIndex(of: selectedTrack) {
            let indexPath = IndexPath(row: index, section: 0)
            jukeboxView.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}

extension JukeboxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            if let selectedCell = tableView.cellForRow(at: selectedIndex) as? MusicPaddedLabelCell {
                selectedCell.setSelected(false, animated: true)
            }
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MusicPaddedLabelCell {
            SoundEffect.pop.playIfAllowed()
            cell.setSelected(true, animated: true)
            UserPreferences.shared.selectedBackgroundMusic = cell.music
            UserPreferences.shared.setBackgroundMusic(cell.music.rawValue)
        }
    }
}

extension JukeboxViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.register(MusicPaddedLabelCell.self, forCellReuseIdentifier: "PaddedLabelCell")
        return BackgroundMusic.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaddedLabelCell", for: indexPath) as! MusicPaddedLabelCell
        let musicCase = BackgroundMusic.allCases[indexPath.row]
        cell.configure(withTrack: musicCase)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }

}
