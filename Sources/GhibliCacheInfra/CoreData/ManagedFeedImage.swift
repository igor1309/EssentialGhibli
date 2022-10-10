//
//  ManagedFeedImage+CoreDataClass.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 10.10.2022.
//
//


import CoreData

@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
    @NSManaged internal var id: UUID
    @NSManaged internal var title: String
    @NSManaged internal var filmDescription: String
    @NSManaged internal var imageURL: URL
    @NSManaged internal var filmURL: URL
    @NSManaged internal var cache: ManagedCache
}

extension ManagedFeedImage {
    internal static func images(from localFeed: [LocalFilm], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.title = local.title
            managed.filmDescription = local.description
            managed.imageURL = local.imageURL
            managed.filmURL = local.filmURL
            return managed
        })
    }
    
    internal var local: LocalFilm {
        return LocalFilm(
            id: id,
            title: title,
            description: filmDescription,
            imageURL: imageURL,
            filmURL: filmURL
        )
    }
}
