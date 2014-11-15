//
//  RelationshipViewController.m
//  LostCharacters
//
//  Created by Andrew Liu on 11/15/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "RelationshipViewController.h"


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

    self.relationArray = self.lostCharactersArray;
    [self.relationArray removeObject:self.lostCharacter];
    
    [self.relationTableView reloadData];
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
    return cell;
}
@end
