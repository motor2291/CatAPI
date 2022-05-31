//
//  FavViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/16.
//
import UIKit
import Kingfisher

class FavViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        fetchFavData()
    }
    
    // 取得螢幕的尺寸
    var fullScreenSize :CGSize! = UIScreen.main.bounds.size
    var myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 20), collectionViewLayout: UICollectionViewFlowLayout())
    var favouriteModel = [FavoriteModel]()
    
    override func viewDidLoad() {
        fetchFavData()
        
        self.view.backgroundColor = UIColor.systemBackground
        let layout = UICollectionViewFlowLayout()
        let myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 20, width: fullScreenSize.width, height: fullScreenSize.height - 20), collectionViewLayout: layout)
        
        myCollectionView.register(FavCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.myCollectionView = myCollectionView
        
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5);
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/3 - 10.0, height: CGFloat(fullScreenSize.width)/3 - 10.0)
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        self.view.addSubview(myCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FavCollectionViewCell
        let favouriteModel = favouriteModel[indexPath.item]
        cell.imageView.kf.setImage(with: favouriteModel.image.url)
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFavDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavDetail" {
            if let dvc = segue.destination as? DetailFavViewController {
                let selectedIndexPath = sender as? NSIndexPath
                if let selectRow = selectedIndexPath?.row {
                    dvc.infoFromImageURL = favouriteModel[selectRow].image.url
                    dvc.infoFromImageId = favouriteModel[selectRow].id
                }
            }
        }
    }
    
    func fetchFavData() {
        let url = URL(string: "https://api.thecatapi.com/v1/favourites")
        var request = URLRequest(url: url!)
        request.setValue("3135a0e2-1fb4-4739-bac9-3cca33874ff0", forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let safeData = data {
                do {
                    let favouriteModel = try JSONDecoder().decode([FavoriteModel].self, from: safeData)
                    self.favouriteModel = favouriteModel
                } catch {
                    print(error)
                }
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }
        }.resume()
    }
}




