//
//  CharacterViewController.m
//  LostCharacters
//
//  Created by Andrew Liu on 11/14/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "CharacterViewController.h"
#import "CoreData.h"

@interface CharacterViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *actorTextField;
@property (weak, nonatomic) IBOutlet UITextField *passengerTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *originTextField;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property NSManagedObjectContext *moc;

@end

@implementation CharacterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)backforwardOnButtonPressed:(UIButton *)sender
{
}

- (IBAction)pickImageOnButtonPressed:(UIButton *)sender
{
}

- (IBAction)confirmOnButtonPressed:(UIButton *)sender
{
}


@end
