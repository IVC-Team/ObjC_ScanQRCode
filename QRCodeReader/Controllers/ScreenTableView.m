//
//  ScreenTableView.m
//  PushAndPopViewControllerDemo
//
//  Created by Bui Van Tin on 7/3/17.
//  Copyright © 2017 Bui Van Tin. All rights reserved.
//

#import "ScreenTableView.h"
#import "ScanQRCode.h"

@interface ScreenTableView () <UITableViewDelegate, UITableViewDataSource, ScanQRCode2Delegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnScanningQRCode;

@property (nonatomic, strong) NSMutableArray *scanningResults;

@end

@implementation ScreenTableView

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initilizeView];
}


//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Formats

- (void) initilizeView
{
    self.scanningResults = [[NSMutableArray alloc] init];
    
    [self.btnScanningQRCode setTitle: @"Scanning QR Code" forState: UIControlStateNormal];
    [self.btnScanningQRCode.titleLabel setTextColor: [UIColor whiteColor]];
    
     self.tableView.delegate = self;
     self.tableView.dataSource = self;
}


//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ScanQRCode Delegate

- (void) reloadTableWithScanningResult: (NSString *) qrCodeValue //
{
    if (qrCodeValue)
    {
        [self.scanningResults addObject: qrCodeValue];
        [self.tableView reloadData];
    }
}

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - UITableView Delegate | DataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scanningResults.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"UITableViewCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"UITableViewCell"];
    }
    
    cell.textLabel.text = [self.scanningResults objectAtIndex: indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Sai
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
//    // If don't set cell.selected = false, cell is always gray background
//    [_scanningResults removeObjectAtIndex:indexPath.row];
//    cell.selected = false;
}


// For remove UITableView row
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.scanningResults removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationTop];
        [tableView reloadData];
    }
}

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Actions



- (IBAction)pressScanningQRCode:(id)sender
{
//    ScanQRCode *scs = [[UIStoryboard storyboardWithName: @"ScanQRCode" bundle: nil] instantiateViewControllerWithIdentifier: @"ScanQRCode"];
//    // scs is scanScreen
//    // register delegate for ScreenTableView
//    scs.delegate = self;
//    
//    [self.navigationController pushViewController: scs animated: YES];
}

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Segue

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender:(id)sender
{
    // This segue was named in storyboard segue
    if ([[segue identifier] isEqualToString: @"pushScanningQRCode"])
    {
        ScanQRCode *scs = (ScanQRCode *) [segue destinationViewController];
        // register delegate for ScreenTableView
        scs.delegate = self;
    }
}

@end
