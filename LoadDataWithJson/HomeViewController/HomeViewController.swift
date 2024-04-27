//
//  HomeViewController.swift
//  LoadDataWithJson
//
//  Created by Ajay Awasthi on 27/04/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HomeViewModel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var lblError: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewDidLoad()
    }
    
    func setupViewDidLoad(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.isHidden = true
        activityIndicatorView.startAnimating()
        viewModel = HomeViewModel()
        loadData()
    }
    
    func loadData() {
        let startTime = DispatchTime.now()
        // Fetch data asynchronously
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
          
            self.viewModel.loadData { [weak self] error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let error = error {
                        self.handleLoadDataError(error)
                    } else {
                        self.handleLoadDataSuccess(startTime)
                    }
                }
            }
        }
    }

    private func handleLoadDataError(_ error: Error) {
        setupErrorUI()
        tableView.isHidden = true
        lblError.isHidden = false
        lblError.text = error.localizedDescription
    }

    private func handleLoadDataSuccess(_ startTime: DispatchTime) {
        setupErrorUI()
        tableView.isHidden = false
        tableView.reloadData()
        
        let endTime = DispatchTime.now()
        let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("Data fetched in \(timeInterval) seconds")
    }

    
    func setupErrorUI(){
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }

}

// MARK: - UITableViewDatSource
extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPostCount()
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          if cell.detailTextLabel == nil {
              cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
          }
          let post = viewModel.getPost(at: indexPath.row)
          cell.textLabel?.text = "ID: \(post.id)"
          cell.detailTextLabel?.text = "Title: \(post.title)"
          cell.detailTextLabel?.numberOfLines = 0
        
          return cell
      }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = viewModel.getPost(at: indexPath.row)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC =  storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailVC?.txtBody = post.title
        if let detailVC = detailVC {
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("detailVC is nil")
        }
        
    }
    
}


// MARK: - UITableViewDataSourcePrefetching
extension HomeViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row >= viewModel.getPostCount() - 1 }) {
            loadData()
        }
    }
}

