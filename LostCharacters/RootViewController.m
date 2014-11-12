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
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *lostCharactersArray;
@end

@implementation RootViewController

//MARK: project life cycle
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

//MARK: filter segment control
- (IBAction)filterWithGenderBySegmentControl:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 2)
    {
        CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
        self.lostCharactersArray = [coreDataManager filterLostCharactersByFemale];
        [self.tableView reloadData];
    }
    else if  (sender.selectedSegmentIndex == 1)
    {
        CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
        self.lostCharactersArray = [coreDataManager filterLostCharactersByMale];
        [self.tableView reloadData];
    }
    else
    {
        CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
        self.lostCharactersArray = [coreDataManager retrieveLostCharacters];
        [self.tableView reloadData];
    }
}

//MARK: tableview multiple delete
- (IBAction)deleteOnButtonPressed:(UIBarButtonItem *)sender
{
    if ([sender.title isEqual: @"Edit"])
    {
        self.tableView.editing = YES;
        sender.title = @"Delete";
    }
    else
    {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];

        CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
        [coreDataManager removeLostCharactersInCoreDataWithArray:self.lostCharactersArray forSelectedRowsAtIndexPaths:selectedRows];
        
        [self.tableView reloadData];
        self.tableView.editing = NO;
        sender.title = @"Edit";
    }
}

//MARK: tableview single delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    [coreDataManager removeLostCharactersInCoreDataWithArray:self.lostCharactersArray forRowAtIndexPath:indexPath];

    [self.tableView reloadData];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"SMOKE\nMONSTER";
}

//MARK: tableview delegate protocol
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
