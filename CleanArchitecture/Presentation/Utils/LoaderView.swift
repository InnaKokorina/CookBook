//
//  LoaderView.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 22.12.2022.
//

import UIKit
import Lottie

class LoaderView {

    static var shared = LoaderView()
    
    private var backgroundFadeView = UIView()
    private var animationView = LottieAnimationView(name:  "loader")

    func show(on view: UIView? = nil) {
        DispatchQueue.main.async {
            self.animationView.contentMode = .scaleAspectFit
            self.backgroundFadeView.frame = UIScreen.main.bounds
            self.animationView.frame = UIScreen.main.bounds
            
            if let window = UIApplication.shared.keyWindow {
                if view != nil {
                    view?.addSubview(self.backgroundFadeView)
                } else {
                    window.addSubview(self.backgroundFadeView)
                }
                self.backgroundFadeView.addSubview(self.animationView)
                self.backgroundFadeView.alpha = 0.0
                self.backgroundFadeView.fadeIn()
                self.animationView.loopMode = .loop
                self.animationView.play()
            }
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.animationView.stop()
            self.backgroundFadeView.fadeOut()
            self.animationView.removeFromSuperview()
            self.backgroundFadeView.removeFromSuperview()
        }
    }
}

