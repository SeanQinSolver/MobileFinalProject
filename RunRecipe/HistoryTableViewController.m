//
//  HistoryTableViewController.m
//  RunRecipe
//
//  Created by Chuanyu Chen on 7/23/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "DetailRunViewController.h"

@interface HistoryTableViewController () {
    Run *currentRunObject;
}

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"Running History";
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
//    NSLog(@"Record size: %lu", (unsigned long)_historyRecords.count);
//    Run *runPastObject = _historyRecords[0];
//    NSLog(@"Duration: %f", _historyRecords[0].duration.floatValue);
//    NSLog(@"Distance: %f", _historyRecords[0].distance.floatValue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Run" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    _historyRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    
    
//    NSLog(@"Record size: %lu", (unsigned long)_historyRecords.count);
//    Run *runPastObject = _historyRecords[0];
//    NSLog(@"Duration: %f", _historyRecords[0].duration.floatValue);
//    NSLog(@"INit TIme Stamp: %f", _historyRecords[0].timestamp);
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_historyRecords.count == 0) {
        return 0;
    }
    return _historyRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:(0/255.0) alpha:1];
    
    NSDateFormatter *dfomatter = [[NSDateFormatter alloc] init];
    [dfomatter setDateStyle:NSDateFormatterShortStyle];
    
    Run *runPastObject = [_historyRecords objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //cell.textLabel.text = [NSString stringWithFormat:@"Duration: %0.2f",  runPastObject.duration.floatValue];
    
    //NSLog(@"TIme STAMP: %@",[formatter stringFromDate:runPastObject.timestamp]);
    cell.detailTextLabel.text =[formatter stringFromDate:runPastObject.timestamp];
    
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %0.2f", runPastObject.distance.floatValue];
    
    cell.textLabel.text = [FormatController formatDistance:runPastObject.distance.floatValue];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    //Pass the selected run to the detail page
    if ([[segue destinationViewController] isKindOfClass:[DetailRunViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        currentRunObject = [self.historyRecords objectAtIndex:indexPath.row];
        [(DetailRunViewController *)[segue destinationViewController] setRun:currentRunObject];
    }
    
}


@end
