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
        rows.append(RowItem(title: "Main", action: { vc in
            let newVC = BKMainTabBarController()
            newVC.modalPresentationStyle = .fullScreen
            vc.present(newVC, animated: true)
        }))
        
        rows.append(RowItem(title: "New", action: { vc in
            let newVC = BKNewViewController(viewModel: BKFactory.shared.newViewModel())
            vc.navigationController?.pushViewController(newVC, animated: true)
        }))
        
        rows.append(RowItem(title: "Save", action: { vc in
            let sentences = [BKSentence(sentence: "Nice to meet you", translation: "만나서 반갑습니다.", sentenceLanguage: .en, translationLanguage: .ko)]
            let viewModel = BKFactory.shared.saveViewModel(sentences: sentences)
            let saveVC = BKSaveViewController(viewModel: viewModel)
            vc.navigationController?.pushViewController(saveVC, animated: true)
        }))
        
        rows.append(RowItem(title: "Archive", action: { vc in
            let archiveVC = BKArchiveViewController(viewModel: BKFactory.shared.archiveViewModel())
            vc.navigationController?.pushViewController(archiveVC, animated: true)
        }))
        
        rows.append(RowItem(title: "음성인식", action: { vc in
            let rehearsalVC = BKRehearsalViewController()
            vc.navigationController?.pushViewController(rehearsalVC, animated: true)
        }))
        
        rows.append(RowItem(title: "Text Diff", action: { vc in
            let differVC = BKDifferViewController()
            vc.navigationController?.pushViewController(differVC, animated: true)
        }))
        
        rows.append(RowItem(title: "Background Player", action: { vc in
            let directory = BKFactory.shared.localFileService.directory(with: .mp3)!
            
            do {
                var idxStub = 0
                let items = try FileManager.default.contentsOfDirectory(atPath: directory.path)
                    .filter { $0.hasSuffix(".mp3") }
                    .map { directory.appendingPathComponent($0) }
                    .map({ url -> BKPlayerItem in
                        idxStub = idxStub + 1
                        return BKPlayerItem(sentence: "sample sentence \(idxStub)", translation: "이건 샘플 번역 \(idxStub)", ttsURL: url)
                    })
                
                let player = BKFactory.shared.player()
                let viewModel = BKPlayerViewModel(player: player)
                viewModel.loadItems(items: items)
                
                let playerVC = BKPlayerViewController(viewModel: viewModel)
                vc.navigationController?.pushViewController(playerVC, animated: true)
            } catch {
                print(error)
            }
        }))
        
//        rows.append(RowItem(title: "play audio", action: { vc in
//            let playerVC = BKPlayerViewController()
//            vc.navigationController?.pushViewController(playerVC, animated: true)
//        }))
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
