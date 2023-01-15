//
//  ViewController.swift
//  MuMe
//
//  Created by HIFI on 2021/02/21.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailMume" {
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
}





class ReuseViewController: UICollectionReusableView {
    @IBOutlet weak var todayRe: UILabel!
    
}

class cvCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txt: UILabel!

}

extension HomeViewController: UICollectionViewDataSource  {
//    몇 개의 컬렉션 뷰 셀을 나타낼건지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
//    컬렉션 뷰 셀을 어떻게 표현할건지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as? cvCell else {
            return UICollectionViewCell()
        }
        return cell
    }
//    헤더 뷰도 여기서 구성한다
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReuseViewController", for: indexPath) as? ReuseViewController else {
            return UICollectionReusableView()
        }
        return header
    }
}

extension HomeViewController: UICollectionViewDelegate {
    //클릭했을 때 어떻게 할까
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("오늘한거 맞냐?")
        performSegue(withIdentifier: "detailMume", sender: indexPath.row)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // Layout 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - (20 * 3))
        let height: CGFloat = width * (7/3)
        
        return CGSize(width: width, height: height)
    }
}

