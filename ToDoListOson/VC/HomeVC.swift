import UIKit
import CoreData

class HomeVC: UIViewController {
    
    private let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)

    private let coreDataManager = CoreDataManager.shared
    private let service = ToDoService()
    
    var combined: [ModelCoreDM] = []
    var filtered: [ModelCoreDM] = []
    var isSearching = false
    
    var pagedData: [ModelCoreDM] = []
    var currentPage = 0
    let pageSize = 20
    var isLoading = false
    
    private let spinner: UIActivityIndicatorView = {
        let sp = UIActivityIndicatorView(style: .medium)
        sp.hidesWhenStopped = true
        return sp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationBar()
        syncData()
    }
    
    private func syncData() {
        var todos: [ToDoResponse] = []
        var users: [UserResponse] = []
        let group = DispatchGroup()
        
        group.enter()
        service.getTodos { result in
            if case .success(let list) = result { todos = list }
            group.leave()
        }
        
        group.enter()
        service.getUsersInfo { result in
            if case .success(let list) = result { users = list }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if !todos.isEmpty, !users.isEmpty {
                self.saveToCoreData(todos: todos, users: users)
            }
            self.loadFromCoreData()
        }
    }
    
    private func saveToCoreData(todos: [ToDoResponse], users: [UserResponse]) {
        coreDataManager.deleteAll(entityName: ToDoListItem.entityName)
        for todo in todos {
            if let user = users.first(where: { $0.id == todo.userId }) {
                let item = ToDoListItem(context: coreDataManager.viewContext)
                item.id = Int64(todo.id)
                item.title = todo.title
                item.completed = todo.completed
                item.userName = user.name
                item.email = user.email
            }
        }
        coreDataManager.save()
    }
    
    private func loadFromCoreData(search: String? = nil) {
        let request = ToDoListItem.fetchRequest() as! NSFetchRequest<ToDoListItem>
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        if let s = search, !s.isEmpty {
            let p1 = NSPredicate(format: "title CONTAINS[c] %@", s)
            let p2 = NSPredicate(format: "userName CONTAINS[c] %@", s)
            request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [p1, p2])
        }

        do {
            let items = try coreDataManager.viewContext.fetch(request)
            combined = items.map { $0.model }

            isSearching = !(search?.isEmpty ?? true)
            if isSearching { filtered = combined } else { filtered.removeAll() }

            pagedData.removeAll()
            currentPage = 0
            loadNextPage()
            tableView.reloadData()
        } catch {
            print("❌ Fetch error:", error)
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    func setNavigationBar() {
        title = "ToDos"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search todos or users"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        view.backgroundColor = .systemBackground
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTVC.self, forCellReuseIdentifier: "HomeTVC")
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .systemBackground
        
        // 🔥 Table footerga spinner qo‘shamiz
        tableView.tableFooterView = spinner
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        loadFromCoreData(search: text.isEmpty ? nil : text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pagedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        let item = pagedData[indexPath.row]
        cell.accessoryType = .none
        cell.setCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == pagedData.count - 1 {
            loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        let item = pagedData[indexPath.row]
        detailVC.item = item
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // 🔥 Loader bilan pagination
    func loadNextPage() {
        guard !isLoading else { return }
        isLoading = true
        spinner.startAnimating()
        
        let source = combined
        let start = currentPage * pageSize
        let end = min(start + pageSize, source.count)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            if start < end {
                let nextSlice = source[start..<end]
                self.pagedData.append(contentsOf: nextSlice)
                self.currentPage += 1
            }
            
            self.isLoading = false
            self.spinner.stopAnimating()
            self.tableView.reloadData()
        }
    }
}
