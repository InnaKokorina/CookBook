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
    //Use default dependency
    class var assembler: Assembler {
        return Assembler([
            SwinjectDIContainer()
            ])
    }
    
    var assembler: Assembler
    
    //If you want use custom Assembler
    init(with assemblies: [Assembly]) {
        assembler = Assembler(assemblies)
    }
    
}
