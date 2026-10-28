//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Мирас Нуралиев on 07.11.2025.
//

import UIKit
import AVFoundation

struct Track {
    let title: String
    let artist: String
    let imageName: String
    let fileName: String
}

class ViewController: UIViewController {

    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    var tracks: [Track] = []
    var currentTrackIndex = 0
    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTracks()
        updateUI()
        loadCurrentTrack()
        setupSlider()
    }
    
    @IBAction func progressSliderChanged(_ sender: UISlider) {
        audioPlayer?.currentTime = TimeInterval(sender.value)
    }
    @IBAction func progressSliderTouchDown(_ sender: UISlider) {
        timer?.invalidate()
    }
    @IBAction func progressSliderTouchUp(_ sender: UISlider) {
        if let player = audioPlayer {
            player.currentTime = TimeInterval(sender.value)
            if isPlaying {
                startTimer() // снова запускаем таймер
            }
        }
    }
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        if currentTrackIndex > 0 {
            currentTrackIndex -= 1
        } else {
            currentTrackIndex = tracks.count - 1
        }
        updateUI()
        loadCurrentTrack()
        if isPlaying {
            playMusic()
        }
    }
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if isPlaying {
            audioPlayer?.pause()
            isPlaying = false
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer?.invalidate()
        } else {
            playMusic()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if currentTrackIndex < tracks.count - 1 {
            currentTrackIndex += 1
        } else {
            currentTrackIndex = 0
        }
        updateUI()
        loadCurrentTrack()
        if isPlaying {
            playMusic()
        }
    }
    
    func setupTracks() {
            tracks = [
                Track(title: "Ты и Я", artist: "Xcho", imageName: "xcho", fileName: "xcho"),
                Track(title: "Jet", artist: "Macan", imageName: "jet", fileName: "jet"),
                Track(title: "like JENNIE", artist: "JENNIE", imageName: "jennie", fileName: "jennie"),
                Track(title: "Feel It", artist: "d4vd", imageName: "feelit", fileName: "feelit"),
                Track(title: "Bad Liar", artist: "Imagine Dragons", imageName: "badliar", fileName: "badliar")
            ]
        }
    
    func updateUI() {
            let track = tracks[currentTrackIndex]
            trackTitleLabel.text = track.title + " - " + track.artist
            albumImageView.image = UIImage(named: track.imageName)
        }
    
    func loadCurrentTrack() {
        let track = tracks[currentTrackIndex]
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") else {
            print("❌ Не найден файл: \(track.fileName).mp3")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            setupSlider()
        } catch {
            print("Ошибка при загрузке аудио: \(error.localizedDescription)")
        }
    }
    
    func playMusic() {
        audioPlayer?.play()
        isPlaying = true
        startTimer()
    }
    
    func setupSlider() {
        guard let player = audioPlayer else { return }
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = Float(player.duration)
        progressSlider.value = 0
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if let player = self.audioPlayer {
                self.progressSlider.value = Float(player.currentTime)
            }
        }
    }
    
}

