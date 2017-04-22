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
    func notify()
}
protocol Observer {
    func update()
}


extension ItemDetailViewController : Subject {
    
    func attach(observer : Observer) {
        
    }
    
    func detach(observer : Observer) {
        
    }
    
    func notify() {
        updateViewModel()
    }
    
    // if fail, then process the error, if success, then update viewModel
    fileprivate func updateViewModel() {
        let result = viewModel.detectErrorsBeforePersistence()
        switch result {
        case .Success :
            Debug.log(message: "successfully log the data")
            viewModel.update()
        case .Failure(.FailNoTitleProvided) :
            AlertMessage.alarmEmptyTextField(body: "Oops : ( , note area is not allowed blank")
            return
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
