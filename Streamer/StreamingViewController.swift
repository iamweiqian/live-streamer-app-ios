//
//  StreamingViewController.swift
//  Streamer
//
//  Created by Wei Qian Yap on 20/05/2021.
//

import UIKit
import AVFoundation
import HaishinKit

class StreamingViewController: UIViewController {
    
    @IBOutlet private weak var lfView: MTHKView!
    
    private var rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    private var sharedObject: RTMPSharedObject!
    private var currentEffect: VideoEffect?
    private var currentPosition: AVCaptureDevice.Position = .back
    private var retryCount: Int = 0
    
    private static let maxRetryCount: Int = 5
    
    var streamerName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupAudio()
        rtmpStream = RTMPStream(connection: rtmpConnection)
        rtmpStream.videoSettings = [
            .width: 720,
            .height: 1280
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = streamerName
        self.navigationItem.largeTitleDisplayMode = .never
        
        rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio)) { error in
            print(error.description)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: .back)) { error in
            print(error.description)
        }
        
        lfView?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        lfView?.attachStream(rtmpStream)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rtmpStream.close()
        rtmpStream.dispose()
    }
    
    func setupAudio() {
        let session = AVAudioSession.sharedInstance()
        do {
            // https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print(error)
        }
    }
    
    @IBAction func on(publish: UIButton) {
        if publish.isSelected {
            print("Selected")
            UIApplication.shared.isIdleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            publish.setTitle("●", for: [])
        } else {
            print("Deselected")
            UIApplication.shared.isIdleTimerDisabled = true
            rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            rtmpConnection.connect("rtmp://push.strattonshire.com/live/\(streamerName)")
            publish.setTitle("■", for: [])
        }
        publish.isSelected.toggle()
    }
    
    @objc private func rtmpStatusHandler(_ notification: Notification) {
        print(notification)
        let e = Event.from(notification)
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            print("Successsss")
            retryCount = 0
            rtmpStream!.publish(streamerName)
        case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
            print("Faillllll")
            guard retryCount <= StreamingViewController.maxRetryCount else {
                return
            }
            Thread.sleep(forTimeInterval: pow(2.0, Double(retryCount)))
            rtmpConnection.connect("rtmp://push.strattonshire.com/live/\(streamerName)")
            retryCount += 1
        default:
            break
        }
    }

    @objc private func rtmpErrorHandler(_ notification: Notification) {
        print(notification)
        rtmpConnection.connect("rtmp://push.strattonshire.com/live/\(streamerName)")
    }

}
