//
//  MasterViewController.m
//  LostCharacters
//
//  Created by Bradley Walker on 10/21/14.
//  Copyright (c) 2014 BlackSummerVentures. All rights reserved.
//

#import "MasterViewController.h"
#import "LostCharacterCell.h"

@interface MasterViewController() <UITableViewDelegate>
@property NSArray *characters;
@property NSNumber *webCharactersLoaded;

@end

@implementation MasterViewController

-(void)viewDidLoad
{
    //Call super of method
    [super viewDidLoad];

    //Initialize class variables
    self.characters = [NSMutableArray array];

    //Handle initial core data load
    [self loadSavedCharacters];
    [self checkForDefaultLoad];
}

#pragma mark - Check for Existing Characters
- (NSURL *)documentsDictionary
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return files.firstObject;
}
- (void)checkForDefaultLoad
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.webCharactersLoaded = [userDefaults objectForKey:@"DefaultsLoaded"];

    if (!(self.webCharactersLoaded.integerValue == 1)) {
            [self loadCharacterListFromWeb];
    }
}

#pragma mark - Manage Core Data Updates
-(void)loadSavedCharacters
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
    NSSortDescriptor *byPassengerName = [NSSortDescriptor sortDescriptorWithKey:@"passenger" ascending:YES];

    request.sortDescriptors = [NSArray arrayWithObjects:byPassengerName, nil];

    self.characters = [self.managedObjectContext executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

-(void)loadCharacterListFromWeb
{
    NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/2/lost.plist"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *json = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListReadCorruptError format:NULL error:&connectionError];
        NSLog(@"%@", json);

        for (NSDictionary *character in json) {
            NSManagedObject *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.managedObjectContext];

            [newCharacter setValue:[character objectForKey:@"actor"] forKey:@"actor"];
            [newCharacter setValue:[character objectForKey:@"passenger"] forKey:@"passenger"];
            [self.managedObjectContext save:nil];

            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
            self.characters = [self.managedObjectContext executeFetchRequest:request error:nil];
            [self.tableView reloadData];
        }

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSNumber *defaultsLoaded = @1;
        [userDefaults setObject:defaultsLoaded forKey:@"DefaultsLoaded"];
        [userDefaults synchronize];
    }];
}


#pragma mark - Table View Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.characters.count;
}

-(LostCharacterCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LostCharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSManagedObject *character = [self.characters objectAtIndex:indexPath.row];

    cell.passenger.text = [character valueForKey:@"passenger"];
    cell.actor.text = [NSString stringWithFormat:@"Played by: %@", [character valueForKey:@"actor"]];

//    cell.planeSeat.text = ;
//    cell.age.text = ;
//    cell.hairColor = ;
//    cell.greatestFear = ;
//    cell.greatestWish = ;

    return cell;
}


@end