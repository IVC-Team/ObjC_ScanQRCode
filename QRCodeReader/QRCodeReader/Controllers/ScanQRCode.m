//
//  ViewController2.m
//  PushAndPopViewControllerDemo
//
//  Created by Bui Van Tin on 7/3/17.
//  Copyright © 2017 Bui Van Tin. All rights reserved.
//

#import "ScanQRCode.h"

#import <AVFoundation/AVFoundation.h>

@interface ScanQRCode () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewQRCode;
@property (weak, nonatomic) IBOutlet UILabel *lblGuidance;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession; //real-time capture
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSString *qrCodeValue;

@end

@implementation ScanQRCode

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lblGuidance.text = @"Click Start! Scan QR Code";
    self.lblResult.text   = @"None";
    [self.btnStart setTitle: @"Start!" forState: UIControlStateNormal];
    
    self.isReading = false;
    self.captureSession = nil;
    
    //[self loadBeepSound];
}



- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear: animated];
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(reloadTableWithScanningResult:)])
    {
        [self.delegate reloadTableWithScanningResult: self.qrCodeValue];
    }
}

//--------------------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Processes

- (BOOL) startReading {
    NSError *error = nil;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; 
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice: captureDevice error: &error];
    
    if (!input)
    {
        NSLog(@"startReading's error = %@", [error localizedDescription]);
        
        return false;
    }
    
     self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput: input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init]; 
    [self.captureSession addOutput: captureMetadataOutput];
    
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate: self queue: dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes: [NSArray arrayWithObject: AVMetadataObjectTypeQRCode]];
    
    //show to user what the camera of the device sees.
     self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame: self.viewQRCode.layer.bounds];
    [self.viewQRCode.layer addSublayer: self.videoPreviewLayer];
    
    [self.captureSession startRunning]; //call function start
    
    return true;
}

- (void) stopReading
{
    [self.captureSession stopRunning];
     self.captureSession = nil;
    
    [self.videoPreviewLayer removeFromSuperlayer];
}



#pragma mark - AVCaptureMetadataOutputObjects Delegate


- (void)   captureOutput: (AVCaptureOutput *) captureOutput
didOutputMetadataObjects: (NSArray *) metadataObjects
          fromConnection: (AVCaptureConnection *) connection
{
    if ((metadataObjects != nil) && ([metadataObjects count] > 0))
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString: AVMetadataObjectTypeQRCode])
        {
            NSString *qrCodeValue = [metadataObj stringValue];
            
            self.qrCodeValue = qrCodeValue; //will delegate that value for ScreenTableView
            
            NSLog(@"qrCodeValue = %@", qrCodeValue);//
            
            
            [self.lblResult performSelectorOnMainThread: @selector(setText:) withObject: qrCodeValue waitUntilDone: NO];
            [self performSelectorOnMainThread: @selector(stopReading) withObject: nil waitUntilDone: NO];
            [self.btnStart performSelectorOnMainThread: @selector(setTitle:) withObject: @"Start!" waitUntilDone: NO];
            
            self.isReading = false;
            
        }
    }
}

//-------------------------------------------------------------------------------------------------------------

#pragma mark - Actions

- (IBAction) didPressStart:(UIButton *)sender
{
    if (!self.isReading)
    {
        if ([self startReading])
        {
            [self.btnStart setTitle: @"Stop" forState: UIControlStateNormal];
            [self.lblResult setText: @"Start Scan QR Code..."];
        }
    }
    else
    {
        [self stopReading];
        [self.btnStart setTitle: @"Start!" forState: UIControlStateNormal];
    }
    
    self.isReading = !self.isReading;
}

@end
