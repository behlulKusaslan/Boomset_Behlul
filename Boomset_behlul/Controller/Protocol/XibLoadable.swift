//
//  XibLoadable.swift
//  Boomset_behlul
//
//  Created by behlul on 6.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import Foundation
import UIKit

/* Loads view that is designed in xib file */
protocol XibLoadable {
    func loadViewFromXib()
    func viewFromNibClass() -> UIView
    var contentViewXib: UIView { get }
}

extension XibLoadable where Self: UIView {
    
    func loadViewFromXib(with nibName: String) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromXib() {
        let view = viewFromNibClass()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func viewFromNibClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
}

extension XibLoadable where Self: UIViewController {
    
    func loadViewFromXib() {
        let view = viewFromNibClass()
        view.frame = self.view.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(view)
    }
    
    func viewFromNibClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
}

extension XibLoadable {
    var contentViewXib: UIView {
        return UIView()
    }
}

extension XibLoadable where Self: UITableViewCell {
    
    var contentViewXib: UIView {
        return self.contentView
    }
    
    func loadViewFromXib() {
        let view = viewFromNibClass()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentViewXib.addSubview(view)
        contentViewXib.layoutIfNeeded()
    }
    
    func viewFromXib(withNibName nibName: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return view
    }
}

extension XibLoadable where Self: UICollectionViewCell {
    
    var contentViewXib: UIView {
        return self.contentView
    }
    
    func loadViewFromXib() {
        let view = viewFromNibClass()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentViewXib.addSubview(view)
        contentViewXib.layoutIfNeeded()
    }
}

