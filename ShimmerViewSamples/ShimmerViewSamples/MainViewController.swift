import UIKit

class MainViewController: UITableViewController {

    enum Section {
        case main
    }
    
    enum Row: CaseIterable {
        static var allCases: [Row] {
            if #available(iOS 14, *) {
                return [.basic, .list, .swiftUI]
            } else {
                return [.basic, .list]
            }
        }
        
        case basic, list
        @available(iOS 14, *)
        case swiftUI
        
        var titleString: String {
            switch self {
            case .basic:
                return "Basic"
            case .list:
                return "List"
            case .swiftUI:
                return "SwiftUI"
            }
        }
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, Row>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.rowHeight = 56
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, data) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = data.titleString
            cell.textLabel?.font = .preferredFont(forTextStyle: .body)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Row.allCases)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Row.allCases[indexPath.row] {
        case .basic:
            let vc = BasicViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .list:
            let vc = ListViewController()
            navigationController?.pushViewController(vc, animated: true)

        case .swiftUI:
            if #available(iOS 14.0, *) {
                let vc = SwiftUIViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
