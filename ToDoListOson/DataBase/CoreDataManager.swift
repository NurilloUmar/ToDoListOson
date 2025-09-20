import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "TodoDM")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("❌ CoreData error: \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print("❌ Save error:", error.localizedDescription)
            }
        }
    }
    
    func deleteAll(entityName: String) {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteReq = NSBatchDeleteRequest(fetchRequest: req)
        do {
            try viewContext.execute(deleteReq)
        } catch {
            print("❌ Delete error:", error)
        }
    }
    
    func fetchAll() -> [ModelCoreDM] {
        do {
            let request = ToDoListItem.fetchRequest() as! NSFetchRequest<ToDoListItem>
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            
            let items = try viewContext.fetch(request)
            return items.map { $0.model }
        } catch {
            print("❌ Fetch error:", error)
            return []
        }
    }
}
