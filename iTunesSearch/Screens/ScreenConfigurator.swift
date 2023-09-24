//
//  ScreenConfigurator.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import UIKit

final class ScreenConfigurator {
    static let shared = ScreenConfigurator()
    
    public func createLandingScreen() -> UIViewController {
        let view: UIViewController & LandingPresenterToView = LandingView()
        let presenter: LandingViewToPresenter = LandingPresenter()
       
        view.presenter = presenter
        presenter.view = view
       
        return view
    }
}
