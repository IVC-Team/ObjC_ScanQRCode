//
//  ViewController.m
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
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initilizeView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    // If don't set cell.selected = false, cell is always gray background
    [_scanningResults removeObjectAtIndex:indexPath.row];
    cell.selected = false;
}

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Actions

- (IBAction) didPressScanningQRCode:(UIButton *) sender
{
    ScanQRCode *scs = [[UIStoryboard storyboardWithName: @"ScanQRCode" bundle: nil] instantiateViewControllerWithIdentifier: @"ScanQRCode"];
    // scs is scanScreen
    // register delegate for ScreenTableView
    scs.delegate = self;
    
    [self.navigationController pushViewController: scs animated: YES];
}

@end
