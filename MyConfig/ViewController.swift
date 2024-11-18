//
//  ViewController.swift
//  MyConfig
//
//  Created by lynnguyen on 18/11/2024.
//

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {

    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.isHidden = true
        return view
    }()

    private let view2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.isHidden = true
        return view
    }()

    private let remoteConfig = RemoteConfig.remoteConfig()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(view1)
        view.addSubview(view2)

        fetchValues()
    }

    func fetchValues() {
        
        // show_new_ui
        let defaults: [String: NSObject] = [
            "show_new_ui": false as NSObject
        ]
        remoteConfig.setDefaults(defaults)

        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings

        let cachedValue = self.remoteConfig.configValue(forKey: "show_new_ui").boolValue
        updateUI(newUI: false)

        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
            if status == .success, error == nil {
                self?.remoteConfig.activate { _, error in
                    guard error == nil else {
                        if let error = error {
                            print("error \(error)")
                        }
                        return
                    }

                    let value = self?.remoteConfig.configValue(forKey: "show_new_ui").boolValue

                    print("Fetched: \(value! )")

                    DispatchQueue.main.async {
                        self?.updateUI(newUI: value!)
                    }
                }
            } else {
                print("something went wrong")
            }
        }
    }

    func updateUI(newUI: Bool) {
        if newUI {
            view2.isHidden = false
            // blue
        } else {
            view1.isHidden = false
            // red
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view1.frame = view.bounds
        view2.frame = view.bounds
    }
}

