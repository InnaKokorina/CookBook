//
//  LoaderView.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 22.12.2022.
//

import UIKit
import Lottie

class LoaderView {
    
    private var backgroundFadeView = UIView()
    private var animationView = LottieAnimationView(name:  "loader")

    func show(on view: UIView?) {
        DispatchQueue.main.async {
            guard let view = view else { return }
            self.backgroundFadeView.frame = view.bounds
            self.animationView.frame = self.backgroundFadeView.bounds
            self.animationView.contentMode = .scaleAspectFit
            view.addSubview(self.backgroundFadeView)
            self.backgroundFadeView.addSubview(self.animationView)
            self.backgroundFadeView.alpha = 0.0
            self.backgroundFadeView.fadeIn()
            self.animationView.loopMode = .loop
            self.animationView.play()
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

