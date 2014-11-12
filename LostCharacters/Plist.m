//
//  Plist.m
//  LostCharacters
//
//  Created by Andrew Liu on 11/11/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "Plist.h"

@implementation Plist

+ (NSMutableArray *)lostCharacters
{
    NSString *bundlePathOfPlist = [[NSBundle mainBundle]pathForResource:@"lost" ofType:@"plist"];
    NSMutableArray *lostCharactersArray = [@[] mutableCopy];
    lostCharactersArray = [NSMutableArray arrayWithContentsOfFile:bundlePathOfPlist];
    return lostCharactersArray;
}


@end
