//
//  ManagedFilmImage.swift
//  EssentialGhibli
//
//  Created by Igor Malyarov on 10.10.2022.
//
//

import CoreData

@objc(ManagedFilmImage)
class ManagedFilmImage: NSManagedObject {
    @NSManaged internal var id: UUID
    @NSManaged internal var title: String
    @NSManaged internal var filmDescription: String
    @NSManaged internal var imageURL: URL
    @NSManaged internal var filmURL: URL
    @NSManaged var data: Data?
    @NSManaged internal var cache: ManagedCache
}

extension ManagedFilmImage {
    static func data(
        with url: URL,
        in context: NSManagedObjectContext
    ) throws -> Data? {
        if let data = context.userInfo[url] as? Data { return data }
        
        return try first(with: url, in: context)?.data
    }
    
    static func first(
        with url: URL,
        in context: NSManagedObjectContext
    ) throws -> ManagedFilmImage? {
        let request = NSFetchRequest<ManagedFilmImage>(entityName: entity().name!)
        request.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(ManagedFilmImage.imageURL), url]
        )
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func images(
        from localFeed: [LocalFilm],
        in context: NSManagedObjectContext
    ) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedFilmImage(context: context)
            managed.id = local.id
            managed.title = local.title
            managed.filmDescription = local.description
            managed.imageURL = local.imageURL
            managed.filmURL = local.filmURL
            return managed
        })
    }
    
    var local: LocalFilm {
        return LocalFilm(
            id: id,
            title: title,
            description: filmDescription,
            imageURL: imageURL,
            filmURL: filmURL
        )
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        
        managedObjectContext?.userInfo[imageURL] = data
    }
}
