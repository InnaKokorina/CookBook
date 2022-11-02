//
//  AppDIContainer.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation
import Swinject

final class AppDIContainer {
    
    // MARK: - SwinjectAssambly
    class var assembler: Assembler {
        return Assembler([SwinjectDIContainer()])
    }
}
