//
//  SearchViewController.swift
//  MuMe
//
//  Created by HIFI on 2021/03/21.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    var delegate: DetailSendData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    var musics:[music] = []
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //검색결과로 갯수를 정해야함 class냐 struct냐
        print("---->aaaa:\(musics.count)")
        return musics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchVC", for: indexPath) as? searchVC else {
            return UICollectionViewCell()
        }
        let music = musics[indexPath.item]
        let url = URL(string: music.thumnailPath)
        cell.searchThumnail.kf.setImage(with: url)
        cell.searchArtist.text = String(music.artist)
        cell.searchSong.text = String(music.title)
        return cell
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let data = musics[indexPath.item]
            self.delegate?.detailSendData(data: data)
            dismiss(animated: true, completion: nil)
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as? DetailViewController
//        if let index = sender as? Int {
//            vc?.searchAtrist = musics[index].artist
//            vc?.searchSong = musics[index].title
//        }
//    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 36) / 2
        let height: CGFloat = width * 7/5
        
        return CGSize(width: width, height: height)
    }
}

class searchVC: UICollectionViewCell {

    @IBOutlet weak var searchThumnail: UIImageView!
    @IBOutlet weak var searchArtist: UILabel!
    @IBOutlet weak var searchSong: UILabel!
    
}

extension SearchViewController: UISearchBarDelegate {
    private func dismisskeyboard(){
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       dismisskeyboard()
       guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        print("조회조건 : \(searchTerm) ")
        searchAPI.search(searchTerm) { musics in
//            print("--> 몇개 넘어왔어?? \(musics.count), --> 첫 번째 제목: \(musics.first?.title)")
            DispatchQueue.main.async {
                self.musics = musics
                self.resultCollectionView.reloadData()
            }
         
        }
        
    }
    
}

class searchAPI {
    static func search(_ term: String, completion: @escaping ([music]) -> Void ) { // ref. affilate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "music")
//        let entityQuery = URLQueryItem(name: "entity", value: "music")
        let termQuery = URLQueryItem(name: "term", value: term)
        
        urlComponents.queryItems?.append(mediaQuery)
//        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                completion([])
                return
            }
            guard let resultData = data else {
                completion([])
                return
            }
//            let string = String(data: resultData, encoding: .utf8)
//            print("--->result:\(string)")
//            print("--->response:\(response)")
            let musics = searchAPI.parseJson(resultData)
            completion(musics)
        }
        dataTask.resume()
    }
    
    static func parseJson(_ data: Data) -> [music] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let musics = response.musics
            return musics
        }catch let error {
            print("error---->\(error.localizedDescription)")
            return []
        }
    }
}

struct Response: Codable {
    let resultCount: Int
    let musics: [music]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case musics = "results"
    }
}

struct music: Codable {
    let title: String
    let artist: String
    let thumnailPath: String
    let previewURL: String
    let searchResult: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case artist = "artistName"
        case previewURL = "previewUrl"
        case thumnailPath = "artworkUrl100"
        case searchResult = "collectionViewUrl"
    }
    
    
}

protocol DetailSendData {
    func detailSendData(data: music)
}
