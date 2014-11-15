//
//  CoreData.m
//  LostCharacters
//
//  Created by Andrew Liu on 11/11/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData

- (instancetype)initWithMOC:(NSManagedObjectContext*)moc
{
    self = [super init];
    self.moc = moc;
    return self;
}

//MARK: sort and filter data
- (NSMutableArray *)retrieveLostCharacters
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Lost"];
    NSSortDescriptor *sortByActorName = [[NSSortDescriptor alloc]initWithKey:@"actor" ascending:YES];
    request.sortDescriptors = @[sortByActorName];
    NSMutableArray *lostCharactersArray = [@[] mutableCopy];
    lostCharactersArray = [[self.moc executeFetchRequest:request error:nil] mutableCopy];
    return lostCharactersArray;
}

- (NSMutableArray *)filterLostCharactersByGender:(NSString *)string
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Lost"];
    NSSortDescriptor *sortByActorName = [[NSSortDescriptor alloc]initWithKey:@"actor" ascending:YES];
    request.sortDescriptors = @[sortByActorName];
    request.predicate = [NSPredicate predicateWithFormat:@"gender = %@", string];
    NSMutableArray *lostCharactersArray = [@[] mutableCopy];
    lostCharactersArray = [[self.moc executeFetchRequest:request error:nil] mutableCopy];
    return lostCharactersArray;
}


//MARK: remove data
- (void)removeLostCharactersInCoreDataWithArray:(NSMutableArray *)lostCharactersArray forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *lostCharacter = [lostCharactersArray objectAtIndex:indexPath.row];
    
    [self.moc deleteObject:lostCharacter];
    [lostCharactersArray removeObjectAtIndex:indexPath.row];
    [self.moc save:nil];
}

- (void)removeLostCharactersInCoreDataWithArray:(NSMutableArray *)lostCharactersArray forSelectedRowsAtIndexPaths:(NSArray *)selectedRowsArray
{
//        NSMutableIndexSet *indexsOfObjectsToDelete = [NSMutableIndexSet new];
//        for (NSIndexPath *selectedIndex in selectedRowsArray)
//        {
//            [indicesOfItemsToDelete addIndex:selectedIndex.row];
//        }
//        [lostCharactersArray removeObjectsAtIndexes:indexsOfObjectsToDelete];

    NSMutableArray *objectsToDelete = [@[]mutableCopy];
    for (NSIndexPath *selectedIndex in selectedRowsArray)
    {
        [objectsToDelete addObject:lostCharactersArray[selectedIndex.row]];
    }

    for (NSManagedObject *lostCharacter in objectsToDelete)
    {
        [self.moc deleteObject:lostCharacter];
        [lostCharactersArray removeObject:lostCharacter];
    }
    [self.moc save:nil];
}


//MARK: store data
- (void)storeLostCharactersByArray:(NSMutableArray *)lostCharactersArray
{
    for (NSDictionary *lostCharacterDictionary in lostCharactersArray)
    {
        NSManagedObject *lostCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Lost" inManagedObjectContext:self.moc];
        [lostCharacter setValue:lostCharacterDictionary[@"actor"] forKey:@"actor"];
        [lostCharacter setValue:lostCharacterDictionary[@"passenger"] forKey:@"passenger"];
        [lostCharacter setValue:lostCharacterDictionary[@"gender"] forKey:@"gender"];
        [lostCharacter setValue:lostCharacterDictionary[@"age"] forKey:@"age"];
        [lostCharacter setValue:lostCharacterDictionary[@"origin"] forKey:@"origin"];

    }
    [self.moc save:nil];
}

- (void)storeLostCharactersByActorString:(NSString *)actorString byPassengerString:(NSString *)passengerString byGenderString:(NSString *)genderString byAgeString:(NSString *)ageString byOriginString:(NSString *)originString
{
    NSManagedObject *lostCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Lost" inManagedObjectContext:self.moc];
    [lostCharacter setValue:actorString forKey:@"actor"];
    [lostCharacter setValue:passengerString forKey:@"passenger"];
    [lostCharacter setValue:genderString forKey:@"gender"];
    [lostCharacter setValue:ageString forKey:@"age"];
    [lostCharacter setValue:originString forKey:@"origin"];
    [self.moc save:nil];
}

@end
