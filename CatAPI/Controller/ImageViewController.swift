//
//  ImageViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/16.
//

import UIKit
import Kingfisher

class ImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        fetchImageData(category: selectedDictionary["category"]!, catType: selectedDictionary["type"]!)
    }
    @IBAction func pickerViewDisplay(_ sender: UIBarButtonItem) {
        if categoryPicker.isHidden {
            categoryPicker.isHidden = false
        } else {
            categoryPicker.isHidden = true
        }
    }
    
    // 取得螢幕的尺寸
    var fullScreenSize :CGSize! = UIScreen.main.bounds.size
    var myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 20), collectionViewLayout: UICollectionViewFlowLayout())
    var imageModel = [ImageModel]()
    let baseURL = "https://api.thecatapi.com/v1/images/search"
    let apiKey = "3135a0e2-1fb4-4739-bac9-3cca33874ff0"
    var selectedDictionary = ["category": "", "type": ""]
    let categoryDictionary = ["None": "", "hats": "category_ids=1", "space": "category_ids=2", "sungless": "category_ids=4", "boxes": "category_ids=5", "ties": "category_ids=7", "sinks": "category_ids=14", "clothes": "category_ids=15"]
    let typeDictionary = ["All": "", "Static": "mime_types=jpg,png", "Animated": "mime_types=gif"]
    
    func fetchImageData(category: String, catType: String) {
        let urlString = "\(baseURL)?apikey=\(apiKey)&limit=90&\(category)&\(catType)"

        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let safeData = data {
                do {
                    self.imageModel = try JSONDecoder().decode([ImageModel].self, from: safeData)
                } catch {
                    print(error)
                }
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                    self.myCollectionView.setContentOffset(.init(x: 0, y: -70), animated: true)
                }
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        categoryPicker.isHidden = true
        super.viewDidLoad()
        
        // 設置底色
        self.view.backgroundColor = UIColor.systemBackground

        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 建立 UICollectionView
        let myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 20, width: fullScreenSize.width, height: fullScreenSize.height - 20), collectionViewLayout: layout)
        
        // 註冊 cell 以供後續重複使用
        myCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.myCollectionView = myCollectionView
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 5
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/3 - 10.0, height: CGFloat(fullScreenSize.width)/3 - 10.0)
        
        // 設置委任對象
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        // 加入畫面中
        self.view.addSubview(myCollectionView)
        self.view.addSubview(categoryPicker)
        
        fetchImageData(category: "", catType: "")
    }
    
    // 必須實作的方法：每一組有幾個 cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModel.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
        let imageModel = imageModel[indexPath.item]
        cell.imageView.kf.setImage(with: imageModel.url)
        return cell
    }
    
    // 有幾個 section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let dvc = segue.destination as? DetailImageViewController {
                let selectedIndexPath = sender as? NSIndexPath
                if let selectRow = selectedIndexPath?.row {
                    dvc.infoFromImageURL = imageModel[selectRow].url
                    dvc.infoFromImageId = imageModel[selectRow].id
                }
            }
        }
    }
}

extension ImageViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return typeDictionary.count
        }else{
            return categoryDictionary.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            let typeKey = [String](typeDictionary.keys.sorted())
            return typeKey[row]
        }else{
            let categoryKey = [String](categoryDictionary.keys.sorted())
            return categoryKey[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            let typeKey = [String](typeDictionary.keys.sorted())
            let typeValue = typeDictionary["\(typeKey[row])"]!
            selectedDictionary.updateValue(typeValue, forKey: "type")
            fetchImageData(category: selectedDictionary["category"]!, catType: selectedDictionary["type"]!)
            categoryPicker.isHidden = true
        } else {
            let categoryKey = [String](categoryDictionary.keys.sorted())
            let categoryValue = categoryDictionary["\(categoryKey[row])"]!
            selectedDictionary.updateValue(categoryValue, forKey: "category")
            fetchImageData(category: selectedDictionary["category"]!, catType: selectedDictionary["type"]!)
            categoryPicker.isHidden = true
        }
    }
}
