//
//  RelationshipViewController.m
//  LostCharacters
//
//  Created by Andrew Liu on 11/15/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "RelationshipViewController.h"
#import "AppDelegate.h"
#import "CoreData.h"

@interface RelationshipViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *relationTableView;
@property NSManagedObjectContext *moc;
@property NSMutableArray *relationArray;


@end

@implementation RelationshipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;

    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    NSMutableArray *lostCharactersArray = [coreDataManager retrieveLostCharacters];

    self.relationArray = lostCharactersArray;
    [self.relationArray removeObject:self.lostCharacter];

    [self.relationTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Lost *lostCharacter = self.relationArray[indexPath.row];

    self.lostCharacter.lover = lostCharacter;

    [self.moc save:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.relationArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *lostCharacter = self.relationArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Actor: %@",[lostCharacter valueForKey:@"actor"]];

    if ([self.lostCharacter.lover isEqual:lostCharacter])
    {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }

    return cell;
}
@end
