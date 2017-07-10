//
//  ScanQRCode.h
//  PushAndPopViewControllerDemo
//
//  Created by Bui Van Tin on 7/3/17.
//  Copyright © 2017 Bui Van Tin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanQRCode2Delegate <NSObject>

@optional
- (void) reloadTableWithScanningResult: (NSString *) qrCodeValue;

@end

@interface ScanQRCode : UIViewController

@property (nonatomic, weak) id<ScanQRCode2Delegate> delegate;

@end
