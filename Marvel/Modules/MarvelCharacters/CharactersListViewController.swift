//
//  CharactersListViewController.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import UIKit

class CharactersListViewController: UIViewController {
    
    //MARK: Required Variable Declaration
    static let identifire = "CharactersListViewController"
    private var viewModel: CharactersListViewModel!
    private var isLoading: Bool = false
    private var isCanceledRequest = false
    
    //MARK: IBOutltes
    @IBOutlet weak var MarvelsListTableView: UITableView!
    
    //MARK: Static Class Initializer
    static func create(storyboard: UIStoryboard?) -> CharactersListViewController {
        //let storyboard = //UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard?.instantiateViewController(withIdentifier: CharactersListViewController.identifire) as! CharactersListViewController
        viewController.viewModel = CharactersListViewModel(viewController: viewController)
        viewController.title = "Characters"
        return viewController
    }
    
    //MARK: Controller Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadMarvelsList()
    }
}

//MARK: Supporting functions
extension CharactersListViewController {
    
    private func setupTableView() {
        MarvelsListTableView.register(UINib(nibName: "CharactersListCell", bundle: nil), forCellReuseIdentifier: CharactersListCell.reuseIdentifier)
        
        MarvelsListTableView.dataSource = self
        MarvelsListTableView.delegate = self
        MarvelsListTableView.rowHeight = UITableView.automaticDimension
        MarvelsListTableView.estimatedRowHeight = UITableView.automaticDimension
        MarvelsListTableView.tableFooterView = UIView()
    }
    
    func showLoader(message: String?) {
        MLoader.shared.showLoader(message: message ?? "")
    }
    
    func hideLoader() {
        MLoader.shared.hideLoader()
    }
    
    func showFooterLoader() {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: MarvelsListTableView.bounds.width, height: CGFloat(60))
        
        MarvelsListTableView.tableFooterView = spinner
        MarvelsListTableView.tableFooterView?.isHidden = false
        isLoading = true
    }
    
    func hideFooterLoader() {
        MarvelsListTableView.tableFooterView = UIView()
        MarvelsListTableView.tableFooterView?.isHidden = true
        isLoading = false
    }
    
    func setRefreshButton() {
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "refresh"), style: .done, target: self, action: #selector(self.didSelectRefreshButton))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func removeRefreshButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func didSelectRefreshButton() {
        self.isCanceledRequest = false
        self.loadMarvelsList()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Reload!", style: UIAlertAction.Style.default, handler: { _ in
            self.isCanceledRequest = false
            self.loadMarvelsList()
            self.removeRefreshButton()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel!", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            self.isCanceledRequest = true
            self.setRefreshButton()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: UITableView Delegate and Datasource

extension CharactersListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCharacters()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharactersListCell.reuseIdentifier, for: indexPath) as! CharactersListCell
        let character = viewModel.characterAt(indexPath: indexPath)
        cell.configure(character: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfCharacters() - 4 {
            if (isLoading == false && isCanceledRequest != true) {
                self.loadMarvelsList()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterModel = viewModel.characterAt(indexPath: indexPath)
        let detailViewController = CharacterDetailViewController.create(storyboard: self.storyboard!, characterModel: characterModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: ViewModel Interactor methods
extension CharactersListViewController {
    func loadMarvelsList() {
        if viewModel.reachedLastIndex() { return }
        if viewModel.numberOfCharacters() == 0 { showLoader(message: "Loading...") } else { showFooterLoader() }
        self.viewModel.loadMarvelCaractersList()
    }
    
    func refreshList(from: Int, to: Int, success: (flag: Bool, message: String)) {
        if success.flag == false {
            hideLoader()
            hideFooterLoader()
            showAlert(title: "Marvel", message:success.message)
        }
        var reloadIndex = [IndexPath]()
        if from == 0 {
            hideLoader()
            MarvelsListTableView.reloadData()
        }
        else {
            hideFooterLoader()
            for index in from...to {
                reloadIndex.append(IndexPath(row: index, section: 0))
            }
            if reloadIndex.count > 0 {
                MarvelsListTableView.insertRows(at: reloadIndex, with: .automatic)
            }
        }
    }
}
