import UIKit

class MainViewController: UITableViewController {

    enum Section {
        case main
    }
    
    enum Row {
        case basic, list
        
        var titleString: String {
            switch self {
            case .basic:
                return "Basic"
            case .list:
                return "List"
            }
        }
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, Row>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clearsSelectionOnViewWillAppear = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, data) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = data.titleString
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.basic, .list])
        dataSource?.apply(snapshot)
    }
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BasicViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
