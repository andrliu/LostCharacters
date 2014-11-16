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
#import "CharacterViewController.h"
#import "RelationshipViewController.h"
#import "Lost.h"    

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
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
        self.lostCharactersArray = [coreDataManager retrieveLostCharacters];
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
        self.lostCharactersArray = [coreDataManager filterLostCharactersByGender:@"Female"];
        [self.tableView reloadData];
    }
    else if  (sender.selectedSegmentIndex == 1)
    {
        CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
        self.lostCharactersArray = [coreDataManager filterLostCharactersByGender:@"Male"];
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

//MARK: add character
- (IBAction)addLostCharacterOnButtonPressed:(UIBarButtonItem *)sender
{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a character"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];



    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = @"Actor";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = @"Passenger";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = @"Gender";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = @"Age";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = @"Origin";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alert addAction:cancelAction];

    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                               {

                                   UITextField *textFieldForActor = alert.textFields.firstObject;
                                   UITextField *textFieldForPassenger = alert.textFields[1];
                                   UITextField *textFieldForGender = alert.textFields[2];
                                   UITextField *textFieldForAge = alert.textFields[3];
                                   UITextField *textFieldForOrigin = alert.textFields.lastObject;

                                   CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
                                   [coreDataManager storeLostCharactersByActorString:textFieldForActor.text
                                                                   byPassengerString:textFieldForPassenger.text
                                                                      byGenderString:textFieldForGender.text
                                                                         byAgeString:textFieldForAge.text
                                                                      byOriginString:textFieldForOrigin.text];

                                   self.lostCharactersArray = [coreDataManager retrieveLostCharacters];
                                   [self.tableView reloadData];
                               }];

    [alert addAction:addAction];

    [self presentViewController:alert animated:YES completion:nil];
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

    Lost *lostCharacter = self.lostCharactersArray[indexPath.row];
    LostCharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.actorLabel.text = [NSString stringWithFormat:@"Actor:\n%@",lostCharacter.actor];
    cell.passengerLabel.text = [NSString stringWithFormat:@"Passenger:\n%@",lostCharacter.passenger];
    cell.genderLabel.text = [NSString stringWithFormat:@"Gender:\n%@",lostCharacter.gender];
    cell.ageLabel.text = [NSString stringWithFormat:@"Age:\n%@",lostCharacter.age];
    cell.originLabel.text = [NSString stringWithFormat:@"Origin:\n%@",lostCharacter.origin];
    cell.actorImageView.image = [[UIImage alloc]initWithData:lostCharacter.photo];

    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString: @"RelationSegue"])
//    {
//        RelationshipViewController *rvc = segue.destinationViewController;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        Lost *lostCharacter = self.lostCharactersArray[indexPath.row];
//        rvc.lostCharacter = lostCharacter;
//        rvc.lostCharactersArray = self.lostCharactersArray;
//        
//    }
//    else if  ([segue.identifier isEqualToString: @"EditSegue"])
//    {
        CharacterViewController *cvc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Lost *lostCharacter = self.lostCharactersArray[indexPath.row];
        cvc.lostCharacter = lostCharacter;
//    }

}

@end
