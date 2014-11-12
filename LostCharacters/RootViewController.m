//
//  ViewController.m
//  LostCharacters
//
//  Created by Andrew Liu on 11/11/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "Plist.h"
#import "CoreData.h"
#import "LostCharacterTableViewCell.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>
@property NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *lostCharactersArray;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;

    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    self.lostCharactersArray = [coreDataManager retrieveLostCharacters];

    if (self.lostCharactersArray.count == 0)
    {
        self.lostCharactersArray = [[Plist lostCharacters] mutableCopy];
        [coreDataManager storeLostCharactersByArray:self.lostCharactersArray];
    }
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    self.lostCharactersArray = [coreDataManager retrieveLostCharacters];

    [self.tableView reloadData];
}


- (IBAction)editOnButtonPressed:(UIBarButtonItem *)sender
{
//    [self.tableView allowsMultipleSelection];
    if ([sender.title isEqualToString:@"Edit"])
    {
        self.tableView.editing = YES;
        sender.title = @"Done";
    }
    else{
        self.tableView.editing = NO;
        sender.title = @"Edit";
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    [coreDataManager removeLostCharactersInCoreDataWithArray:self.lostCharactersArray forRowAtIndexPath:indexPath];

    [self.tableView reloadData];
}



-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"SMOKE\nMONSTER";
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lostCharactersArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *lostCharacter = self.lostCharactersArray[indexPath.row];
    LostCharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.actorLabel.text = [NSString stringWithFormat:@"Actor:\n%@",[lostCharacter valueForKey:@"actor"]];
    cell.passengerLabel.text = [NSString stringWithFormat:@"Passenger:\n%@",[lostCharacter valueForKey:@"passenger"]];
    cell.genderLabel.text = [NSString stringWithFormat:@"Gender:\n%@",[lostCharacter valueForKey:@"gender"]];
    cell.ageLabel.text = [NSString stringWithFormat:@"Age:\n%@",[lostCharacter valueForKey:@"age"]];
    cell.originLabel.text = [NSString stringWithFormat:@"Origin:\n%@",[lostCharacter valueForKey:@"origin"]];
    return cell;
}

@end
