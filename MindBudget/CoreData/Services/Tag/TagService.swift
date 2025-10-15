//
//  TagService.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

protocol TagServiceProtocol {
    func createTag(name: String, color: String) throws -> Tag
    func fetchAllTags() -> [Tag]
    func deleteTag(_ tag: Tag) throws -> Bool
    func deleteUnusedTags() throws -> Bool
}

class TagService: BaseService, TagServiceProtocol {
    func createTag(name: String, color: String) throws -> Tag {
        // Check if tag already exists
        let existingPredicate = NSPredicate(format: "name == %@", name)
        if let existingTag = try? fetchFirst(
            entityType: Tag.self,
            predicate: existingPredicate
        ) {
            return existingTag
        }

        let tag = Tag(context: context)
        tag.id = UUID()
        tag.name = name
        tag.color = color
        tag.createdAt = Date()

        try save()
        return tag
    }

    func fetchAllTags() -> [Tag] {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)

        do {
            return try fetch(entityType: Tag.self, sortDescriptors: [sortDescriptor])
        } catch {
            print("Error fetching tags: \(error)")
            return []
        }
    }
    
    func deleteTag(_ tag: Tag) throws -> Bool {
        context.delete(tag)
        try save()
        return true
    }
        
    func deleteUnusedTags() throws -> Bool {
        let allTags: [Tag]
        do {
            allTags = try fetch(entityType: Tag.self)
        } catch {
            throw error
        }

        let unusedTags = allTags.filter { tag in
            return (tag.transactions?.count ?? 0) == 0
        }

        for tag in unusedTags {
            context.delete(tag)
        }

        try save()
        return true
    }
}
