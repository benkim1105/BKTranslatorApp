//
//  DevViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import UIKit

struct RowItem {
    let title: String
    let action: (UIViewController) -> Void
}

struct DevViewModel {
    var rows = [RowItem]()
    
    init() {
        rows.append(RowItem(title: "New", action: { vc in
            let newVC = BKNewViewController(viewModel: BKFactory.shared.newViewModel())
            vc.navigationController?.pushViewController(newVC, animated: true)
        }))
        
        rows.append(RowItem(title: "Save", action: { vc in
            let sentences = [Sentence(script: "Nice to meet you", translation: "만나서 반갑습니다.", scriptLanguage: .en, translationLanguage: .ko)]
            let viewModel = BKFactory.shared.saveViewModel(sentences: sentences)
            let saveVC = BKSaveViewController(viewModel: viewModel)
            vc.navigationController?.pushViewController(saveVC, animated: true)
        }))
        
        rows.append(RowItem(title: "play audio", action: { vc in
            let playerVC = BKPlayerViewController()
            vc.navigationController?.pushViewController(playerVC, animated: true)
        }))
    }
}

class DevViewController: UITableViewController {
    let viewModel = DevViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "개발 메인"
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.rows[indexPath.row].action(self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let rowItem = viewModel.rows[indexPath.row]
        cell.textLabel?.text = rowItem.title
        
        return cell
    }
    
}
