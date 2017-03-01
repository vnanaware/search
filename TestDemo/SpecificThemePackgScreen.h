//
//  SpecificThemePackgScreen.h
//  Snapbets
//
//  Created by Bhimashankar Vibhute on 10/09/16.
//  Copyright © 2016 Syneotek Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderAndConstants.h"
#import "MBProgressHUD.h"
#import "IAPHelper.h"
#import "InAppRageIAPHelper.h"


@interface SpecificThemePackgScreen : UIViewController
{
    CGRect vscreenSize;
    CGFloat vscreenHeight,vscreenWidth;
    
    NSUInteger *singleSelectionID;
    MBProgressHUD *hud;
    int productId;
}

#pragma mark: UIView properties declarations here
@property (nonatomic)IBOutlet UIView *viewForBuySingleTheme;



#pragma mark: UIButton properties declarations here
@property(nonatomic)IBOutlet UIButton *btnPlay,*btnBuySingle,*btnBack,*btnBackPress,*btnSBuySnpbet,*btnClseBuySnpbet,*btnBuyAll,*btnViewInvite,*btnCloseInvite,*btnClsoePostRespnse,*btnCloseUpgradeUI,*btnUpgrade,*btnCloseVideoScreen,*btnCloseAlert;





#pragma mark: Bool Properties declarations here
@property (nonatomic)BOOL ispurchaseList,isSinglePurchase,isBuyAllList;


@end
