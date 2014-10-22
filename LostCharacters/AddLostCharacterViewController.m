//
//  AddLostCharacterViewController.m
//  LostCharacters
//
//  Created by Bradley Walker on 10/21/14.
//  Copyright (c) 2014 BlackSummerVentures. All rights reserved.
//

#import "AddLostCharacterViewController.h"
#import "AppDelegate.h"

@interface AddLostCharacterViewController ()

@property (strong, nonatomic) IBOutlet UITextField *passengerInput;
@property (strong, nonatomic) IBOutlet UITextField *actorInput;
@property (strong, nonatomic) IBOutlet UITextField *planeSeatInput;
@property (strong, nonatomic) IBOutlet UITextField *ageInput;
@property (strong, nonatomic) IBOutlet UITextField *hairColorInput;
@property (strong, nonatomic) IBOutlet UITextField *greatestWish;
@property (strong, nonatomic) IBOutlet UITextField *greatestFear;
@property NSManagedObjectContext *managedObjectContext;

@end

@implementation AddLostCharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)onSaveButtonPressed:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObject *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:appDelegate.managedObjectContext];

    [newCharacter setValue:self.actorInput.text forKey:@"actor"];
    [newCharacter setValue:self.passengerInput.text forKey:@"passenger"];
    [newCharacter setValue:self.planeSeatInput.text forKey:@"planeSeat"];
    [newCharacter setValue:self.ageInput.text forKey:@"age"];
    [newCharacter setValue:self.hairColorInput.text forKey:@"hairColor"];
    [newCharacter setValue:self.passengerInput.text forKey:@"passenger"];
    [newCharacter setValue:self.greatestWish.text forKey:@"greatestWish"];
    [newCharacter setValue:self.greatestFear.text forKey:@"greatestFear"];

    [appDelegate.managedObjectContext save:nil];
}

- (IBAction)onClearButtonPressed:(id)sender
{
    self.passengerInput.text = @"";
    self.actorInput.text = @"";
    self.planeSeatInput.text = @"";
    self.ageInput.text = @"";
    self.hairColorInput.text = @"";
    self.greatestWish.text = @"";
    self.greatestWish.text = @"";
}

@end
