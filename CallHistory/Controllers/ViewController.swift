//
//  ViewController.swift
//  CallHistory
//
//  Created by Stepan Grachev on 22.01.2021.
//

import UIKit

class ViewController: UIViewController {

    var calls: [CallModel] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCalls()
    }
    
    func getCalls() {
        guard let url = URL(string: "https://5e3c202ef2cb300014391b5a.mockapi.io/testapi")
        else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                  error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }
                
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DataResponse.self, from: dataResponse)
                
                for call in response.requests {
                    self.calls.append(call)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch let parsingError {
                print("Error", parsingError)
                
            }
            
        }
        task.resume()
    }

}

extension ViewController: UICollectionViewDataSource,
                          UICollectionViewDelegate,
                          UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DataCollectionViewCell
        
        cell?.layer.cornerRadius = 10.0
        cell?.clipsToBounds = true
        cell!.layer.borderWidth = 0.5
        cell!.layer.borderColor = UIColor.lightGray.cgColor
        
        cell?.nameOfContact.text = calls[indexPath.row].client.Name
        cell?.phone.text = calls[indexPath.row].client.address
        if String(Array(calls[indexPath.row].duration)[0]) == "0" && String(Array(calls[indexPath.row].duration)[1]) == "0" {
            cell?.duration.text = calls[indexPath.row].duration.substring(from: String.Index(encodedOffset: 3))
        } else {
            cell?.duration.text = calls[indexPath.row].duration
        }
        
        let dateAsString = calls[indexPath.row].created
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: dateAsString)

        dateFormatter.dateFormat = "hh:mm a"
        let date24 = dateFormatter.string(from: date!)
        
        cell?.time.text = date24
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            let width  = view.frame.width-32
            return CGSize(width: width, height: width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailedViewController = storyboard.instantiateViewController(withIdentifier: "DetailedViewController") as! DetailedViewController
        detailedViewController.name = calls[indexPath.row].client.Name
        detailedViewController.phone = calls[indexPath.row].client.address
        if String(Array(calls[indexPath.row].duration)[0]) == "0" && String(Array(calls[indexPath.row].duration)[1]) == "0" {
            detailedViewController.duration = calls[indexPath.row].duration.substring(from: String.Index(encodedOffset: 3))
        } else {
            detailedViewController.duration = calls[indexPath.row].duration
        }
        detailedViewController.businessPhone = calls[indexPath.row].businessNumber.number
        navigationController?.pushViewController(detailedViewController, animated: true)
    }
}

