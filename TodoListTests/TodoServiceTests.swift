import XCTest
@testable import TodoList

final class TodoServiceTests: XCTestCase {
    var service: TodoService!
    
    override func setUp() {
        super.setUp()
        service = TodoService()
        // 清除 UserDefaults 中的测试数据
        UserDefaults.standard.removeObject(forKey: "todos")
    }
    
    override func tearDown() {
        service = nil
        // 清除 UserDefaults 中的测试数据
        UserDefaults.standard.removeObject(forKey: "todos")
        super.tearDown()
    }
    
    func testSaveAndLoadTodos() {
        // Given
        let todos = [
            Todo(title: "测试项目1"),
            Todo(title: "测试项目2", isCompleted: true)
        ]
        
        // When
        service.saveTodos(todos)
        let loadedTodos = service.loadTodos()
        
        // Then
        XCTAssertEqual(loadedTodos.count, 2)
        XCTAssertEqual(loadedTodos[0].title, "测试项目1")
        XCTAssertFalse(loadedTodos[0].isCompleted)
        XCTAssertEqual(loadedTodos[1].title, "测试项目2")
        XCTAssertTrue(loadedTodos[1].isCompleted)
    }
    
    func testLoadEmptyTodos() {
        // When
        let todos = service.loadTodos()
        
        // Then
        XCTAssertEqual(todos.count, 0)
    }
    
    func testSaveAndLoadWithSpecialCharacters() {
        // Given
        let todos = [
            Todo(title: "测试项目!@#$%^&*()"),
            Todo(title: "测试项目 中文 空格")
        ]
        
        // When
        service.saveTodos(todos)
        let loadedTodos = service.loadTodos()
        
        // Then
        XCTAssertEqual(loadedTodos.count, 2)
        XCTAssertEqual(loadedTodos[0].title, "测试项目!@#$%^&*()")
        XCTAssertEqual(loadedTodos[1].title, "测试项目 中文 空格")
    }
} 