//
//  SearchScreen.h
//  Snapbets
//
//  Created by Bhimashankar Vibhute on 13/09/16.
//  Copyright © 2016 Syneotek Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderAndConstants.h"
#import "WebConnection1.h"
#import "AppDelegate.h"

@interface SearchScreen : UIViewController<UITableViewDelegate,UITableViewDataSource,WebRequestResult1,UISearchResultsUpdating, UISearchBarDelegate>
{
    WebConnection1 *connection;
    NSMutableDictionary *dict;
    NSArray *searchResults;
    CGRect vscreenSize;
    CGFloat vscreenHeight,vscreenWidth;
}

@property (nonatomic)IBOutlet UIView *viewForInvite,*viewFrinds,*viewUsers,*viewChallenges,*viewForAlert,*viewForAlryFrnd;

#pragma mark:UIButton Properties declarations here
@property (nonatomic)IBOutlet UIButton *btnBack,*btnBackPress,*btnViewInvite,*btnCloseInvite,*btnClseBuySnpbet,*btnFrinds,*btnUsers,*btnChallenges,*btnCancel,*btnAdd,*btnSend,*btnProfileAlrt;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic)NSString *strSrchReciverID,*strUID,*snapID;

@property (nonatomic)IBOutlet UITextField *txtSearch;

#pragma mark: UITableView properties declarations here
@property(nonatomic)IBOutlet UITableView *tblSearch;

#pragma mark: UILabel properties declarations here
@property(nonatomic)IBOutlet UILabel *lblTags;

#pragma mark: NSMutableArray properties declarations here
@property (nonatomic)NSMutableArray *arrFriendList,*arrNames,*arrUIDs;

@property (nonatomic)bool isFriends,isUsers,isChallenge,isAdd,isSendLink;

@end
