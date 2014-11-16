//
//  Lost.h
//  LostCharacters
//
//  Created by Andrew Liu on 11/15/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lost;

@interface Lost : NSManagedObject

@property (nonatomic, retain) NSString * actor;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) NSString * passenger;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) Lost *lover;

@end
