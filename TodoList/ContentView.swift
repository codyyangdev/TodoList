//
//  ContentView.swift
//  TodoList
//
//  Created by 安路与 on 2025/5/10.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var newTodoTitle = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("新任务", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if !newTodoTitle.isEmpty {
                            viewModel.addTodo(title: newTodoTitle)
                            newTodoTitle = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                List {
                    ForEach(viewModel.todos) { todo in
                        HStack {
                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(todo.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleTodoCompletion(todo: todo)
                                }
                            
                            Text(todo.title)
                                .strikethrough(todo.isCompleted)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTodo)
                }
            }
            .navigationTitle("待办事项")
        }
    }
}

#Preview {
    ContentView()
}
