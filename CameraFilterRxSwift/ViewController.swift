//
//  ViewController.swift
//  CameraFilterRxSwift
//
//  Created by BoMin on 2023/03/05.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var applyButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
            fatalError("Segue destination is not found")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.upateUI(with: photo)
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    @IBAction func applyButtonPressed() {
        
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    private func upateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyButton.isHidden = false
    }


}

