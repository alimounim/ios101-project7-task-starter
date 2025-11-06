//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    private(set) var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    private(set) var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {


    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {

        // TODO: Save the array of tasks
        // Save an array of tasks to UserDefaults.
        //    - we add the `static` keyword to make this a "Type Method".
        //    - We can call it from anywhere by calling it on the `Task` type.
        // 1. Create an instance of UserDefaults
        let defaults = UserDefaults.standard
        // 2. Try to encode the array of `Task` objects to `Data`
        let encodedData = try? JSONEncoder().encode(tasks)
        // 3. Save the encoded movie `Data` to UserDefaults
        defaults.set(encodedData, forKey: "tasks")
        // 🐞 DEBUG: Print movie titles to console to see which movies we just saved
        print("🍿 ---Tasks---")
        print(tasks.map(\.title).joined(separator: "\n"))
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        
        // TODO: Get the array of saved tasks from UserDefaults
        // 1. Create an instance of UserDefaults
        let defaults = UserDefaults.standard
        // 2. Get any tasks `Data` saved to UserDefaults (if any exist)
        if let savedData = defaults.data(forKey: "tasks"){
            // 3. Try to decode the task `Data` to `Task` objects
            let decodedTask = try! JSONDecoder().decode([Task].self, from: savedData)
            // 4. If 2-3 are successful, return the array of movies
            return decodedTask
        } else {
            // 5. Otherwise, return an empty array
            return [] // 👈 replace with returned saved tasks
        }
    }

    // Add a new task or update an existing task with the current task.
    func save() {

        // TODO: Save the current task
        // 1. Get all tasks from UserDefaults
        //    - We make `tasks` a `var` so we'll be able to modify it when adding another task
        var tasks = Task.getTasks()
        // 2. Add the task to the tasks array
        //   - Since this method is available on "instances" of a task, we can reference the task this method is being called on using `self`.
        if let i = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks[i] = self      // update existing
        } else {
            tasks.append(self)   // add new
        }
        // 3. Save the updated tasks array
        Task.save(tasks)
        
    }
}
