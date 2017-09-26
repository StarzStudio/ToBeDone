//
//  ObserverPattern.swift
//  ToBeDone
//
//  Created by 周星 on 4/18/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation


protocol Subject {
    func attach(observer : Observer)
    func detach(observer : Observer)
    func notify() -> Bool
}
protocol Observer {
    func update()
}


extension ItemDetailViewController : Subject {
    
    func attach(observer : Observer) {
        
    }
    
    func detach(observer : Observer) {
        
    }
    
    func notify() -> Bool {
        return updateViewModel()
    }
    
    // if fail, then process the error, if success, then update viewModel
    fileprivate func updateViewModel() -> Bool {
        let result = viewModel.detectErrorsBeforePersistence()
        switch result {
        case .Success :
            Debug.log(message: "successfully store the data")
            viewModel.update()
            return true
        case .Failure(.FailNoTitleProvided) :
            AlertMessage.alarmEmptyTextField(body: "Oops : ( , \"Title\" area is not allowed blank")
            return false
        }
        
    }
}


extension ItemDetailViewModel {
    func update() {
        switch self.currentState {
        case .Modifing :
            updateState()
        case .Initializing:
            saveState()
        }
        
    }
}
