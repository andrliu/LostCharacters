//
//  CoreData.h
//  LostCharacters
//
//  Created by Andrew Liu on 11/11/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CoreData : NSObject

@property NSManagedObjectContext *moc;

- (instancetype)initWithMOC:(NSManagedObjectContext*)moc;

- (NSMutableArray *)retrieveLostCharacters;

- (void)removeLostCharactersInCoreDataWithArray:(NSMutableArray *)lostCharactersArray forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)storeLostCharactersByArray:(NSMutableArray *)lostCharactersArray;

- (void)storeLostCharactersByActorString:(NSString *)actorString byPassengerString:(NSString *)passengerString byGenderString:(NSString *)genderString byAgeString:(NSString *)ageString byOriginString:(NSString *)originString;

@end
