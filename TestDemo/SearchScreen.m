//
//  SearchScreen.m
//  Snapbets
//
//  Created by Bhimashankar Vibhute on 13/09/16.
//  Copyright © 2016 Syneotek Software Solution. All rights reserved.
//

#import "SearchScreen.h"
@interface SearchScreen ()
{
    NSInteger index;
    NSMutableArray *arrSelectedCells,*arrSelectedUIDs;
    NSString *selectedUIDs;
    UIView *sendView;
}

@end

@implementation SearchScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    index=-1;
    _isAdd=NO;
    
    _arrFriendList=[[NSMutableArray alloc]init];
    arrSelectedCells=[[NSMutableArray alloc]init];
    arrSelectedUIDs=[[NSMutableArray alloc]init];
    
    [self loadInitialUI];
    _isFriends=YES;
    [self searchListServerAPI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return true;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark: LoadInitialUI
-(void)loadInitialUI
{
    UIView *viewHeader=[[UIView alloc]initWithFrame:CGRectMake(0,0,screenWidth,120)];
    viewHeader.backgroundColor=[UIColor colorWithRed:240/255.0 green:137/255.0 blue:0/255.0 alpha:1];
    [self.view addSubview:viewHeader];
    
    UILabel *lblTitle=[[UILabel alloc]init];
    lblTitle.frame=CGRectMake(0,5,screenWidth,30);
    lblTitle.text=@"Search";
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:lblTitle];
    
    _btnBack=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnBack.frame = CGRectMake(8,8,25,25);
    [_btnBack setBackgroundImage:[UIImage imageNamed:@"iconBackArrow.png"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBack];
    
    /*----------- Button Pressed Event Fired and goto SidebarViewController--------*/
    _btnBackPress=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnBackPress.frame = CGRectMake(0,0,105,55);
    [_btnBackPress addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBackPress];
    
    _btnFrinds=[[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lblTitle.frame)+10,screenWidth/3,30)];
    _btnUsers=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_btnFrinds.frame),CGRectGetMaxY(lblTitle.frame)+10,screenWidth/3,30)];
    _btnChallenges=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_btnUsers.frame),CGRectGetMaxY(lblTitle.frame)+10,screenWidth/3,30)];
    [_btnFrinds setTitle:@"Friends" forState:UIControlStateNormal];
    [_btnChallenges setTitle:@"Challengers" forState:UIControlStateNormal];
    [_btnUsers setTitle:@"Users" forState:UIControlStateNormal];
    
    [_btnFrinds addTarget:self action:@selector(btnFriendsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_btnUsers addTarget:self action:@selector(btnUserPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_btnChallenges addTarget:self action:@selector(btnChallengePressed:)forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnFrinds];
    [self.view addSubview:_btnUsers];
    [self.view addSubview:_btnChallenges];
    
    _viewFrinds=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_btnFrinds.frame)-3,screenWidth/3,2)];
    _viewUsers=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_viewFrinds.frame),CGRectGetMaxY(_btnUsers.frame)-3,screenWidth/3,2)];
    _viewChallenges=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_viewUsers.frame),CGRectGetMaxY(_btnChallenges.frame)-3,screenWidth/3,2)];
    
    _viewUsers.backgroundColor=[UIColor whiteColor];
    _viewFrinds.backgroundColor=[UIColor whiteColor];
    _viewChallenges.backgroundColor=[UIColor whiteColor];
    
    _viewChallenges.hidden=YES;
    _viewUsers.hidden=YES;
    
    [self.view addSubview:_viewUsers];
    [self.view addSubview:_viewFrinds];
    [self.view addSubview:_viewChallenges];
    
    UIView *viewForSearch=[[UIView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(_viewChallenges.frame)+5,screenWidth-120,35)];
    viewForSearch.backgroundColor=[UIColor clearColor];
    viewForSearch.layer.cornerRadius=5.0;
    viewForSearch.layer.borderColor=[[UIColor blackColor]CGColor];
    viewForSearch.layer.borderWidth=1.0;
   // [self.view addSubview:viewForSearch];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(5,5,25,25)];
    img.image=[UIImage imageNamed:@"icon_Search1"];
   // [viewForSearch addSubview:img];
    
    _txtSearch=[[UITextField alloc]initWithFrame:CGRectMake(35,5,viewForSearch.frame.size.width-45,25)];
    [self getTextFieldWithProperties:_txtSearch placeholder:@"Email" forLogin:YES];
   // [viewForSearch addSubview:_txtSearch];
    
    _btnCancel=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewForSearch.frame)+10,CGRectGetMaxY(_viewFrinds.frame)+10,100,30)];
    [_btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [self.view addSubview:_btnCancel];
    
    
    //-----------------------UIView For Send Button-----------------------------------//
    if (theAppDelegate.isSearch == YES)
    {
        
    }
    else
    {
        sendView=[[UIView alloc]initWithFrame:CGRectMake(0, screenHeight-50, screenWidth, 50)];
        sendView.backgroundColor=[UIColor colorWithRed:248/255.0 green:206/255.0 blue:162/255.0 alpha:1.0];
        [self.view addSubview:sendView];
        [self.view bringSubviewToFront:sendView];
        
        _btnSend=[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-100, 5, 90, 40)];
        [_btnSend setTitle:@"Send" forState:UIControlStateNormal];
        [_btnSend setBackgroundImage:[UIImage imageNamed:@"img_PlainBG"] forState:UIControlStateNormal];
        [_btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnSend addTarget:self action:@selector(btnSendPressed) forControlEvents:UIControlEventTouchUpInside];
        _btnSend.titleLabel.font=[UIFont fontWithName:@"Avenir Medium" size:20];
        [sendView addSubview:_btnSend];
        
    }
    
    _tblSearch=[[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_viewFrinds.frame)+5,screenWidth,screenHeight-170)];
    _tblSearch.dataSource=self;
    _tblSearch.delegate=self;
    _tblSearch.tableFooterView=[[UIView alloc]init];
    _tblSearch.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tblSearch];
    [self initializeSearchController];
}

#pragma mark: Set Proerties for TextFields
-(UITextField*)getTextFieldWithProperties:(UITextField*)textField placeholder:(NSString*)placeholder forLogin:(BOOL)forLogin
{
    //------------- Add properties to textfield ------------- //
    //  textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder =placeholder;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType=UIKeyboardAppearanceDefault;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardAppearance=UIKeyboardAppearanceLight;
    [textField addTarget:self action:@selector(resignTxt:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    _txtSearch.font=[UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
    
    _txtSearch.textAlignment=NSTextAlignmentLeft;
    
    _txtSearch.textColor=[UIColor blackColor];
    
    //----------- Validate return keys -------------------- //
    if (forLogin && textField==_txtSearch)
    {
        _txtSearch.returnKeyType=UIReturnKeyDone;
    }
    
    
    return textField;//------- Return fully updated textfield
}

#pragma mark- TextField DelegateMethods
-(void)resignTxt:(UITextField*)txt
{
    //----------- Validate textfield return action ------ //
    if (txt==_txtSearch)
    {
        [_txtSearch becomeFirstResponder];
    }
    else
    {
        [txt resignFirstResponder];
    }
    //------------------------------------------------ //
}

#pragma mark: Button pressed delegate declarations here
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnChallengePressed:(id)sender
{
    
    _viewChallenges.hidden=NO;
    _viewUsers.hidden=YES;
    _viewFrinds.hidden=YES;

    _isFriends=NO;
    _isUsers=NO;
    _isChallenge=YES;
    [self searchListServerAPI];
}

-(IBAction)btnUserPressed:(id)sender
{
    _viewChallenges.hidden=YES;
    _viewUsers.hidden=NO;
    _viewFrinds.hidden=YES;
    
    _isFriends=NO;
    _isUsers=YES;
    _isChallenge=NO;
    
    [self searchListServerAPI];
}

-(IBAction)btnFriendsPressed:(id)sender
{
    _viewChallenges.hidden=YES;
    _viewUsers.hidden=YES;
    _viewFrinds.hidden=NO;
    
    _isFriends=YES;
    _isUsers=NO;
    _isChallenge=NO;
    [self searchListServerAPI];
}

-(IBAction)btnAddPressed:(UIButton *)sender
{
    NSString *indexPat=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    NSString *uid=[NSString stringWithFormat:@"%@",[_arrUIDs objectAtIndex:sender.tag]];
    if ([arrSelectedCells containsObject:indexPat] && [arrSelectedUIDs containsObject:uid])
    {
        [arrSelectedCells removeObject:indexPat];
        [arrSelectedUIDs removeObject:uid];
    }
    else
    {
        [arrSelectedCells addObject:indexPat];
        [arrSelectedUIDs addObject:uid];
    }
    
    [_tblSearch reloadData];
}

-(void)btnSendPressed
{
    NSLog(@"%@",arrSelectedUIDs);
    selectedUIDs=[arrSelectedUIDs componentsJoinedByString:@","];
    
    if ([arrSelectedUIDs count])
    {
        [self sendLinkServerCall];
    }
    else
    {
        [self viewForAlertPopupUI];
        NSLog(@"Please select User to invite");
    }
}

#pragma mark: ViewForFriends
-(void)viewForInfoDisplay
{
    
}

- (void)initializeSearchController
{
    //instantiate a search results controller for presenting the search/filter results (will be presented on top of the parent table view)
    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    searchResultsController.accessibilityFrame=CGRectMake(0,100,screenWidth,screenHeight-50);
    //instantiate a UISearchController - passing in the search results controller table
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    //this view controller can be covered by theUISearchController's view (i.e. search/filter table)
    self.definesPresentationContext = NO;
    
    //define the frame for the UISearchController's search bar and tint
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,100, self.searchController.searchBar.frame.size.width, 44.0);

    self.searchController.searchBar.tintColor = [UIColor orangeColor];
    //add the UISearchController's search bar to the header of this table
    self.tblSearch.tableHeaderView = self.searchController.searchBar;
    
    //this ViewController will be responsible for implementing UISearchResultsDialog protocol method(s) - so handling what happens when user types into the search bar
    self.searchController.searchResultsUpdater = self;
    
    //this ViewController will be responsisble for implementing UISearchBarDelegate protocol methods(s)
    self.searchController.searchBar.delegate = self;
}

#pragma mark- TableView DataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchController.searchBar.text.length > 0)
    {
        return [searchResults count];
    }
    else
    {
        return [_arrFriendList count];
    }
    return 0;
}

//--------------------- cellforrow At Index TableView -----------------------//

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (cell == nil)
    {
        //  cell.transform= CGAffineTransformMakeRotation(M_PI/2);
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UILabel *lblCellTitle=[[UILabel alloc]initWithFrame:CGRectMake(5,5,screenWidth-10,30)];
    if(self.searchController.searchBar.text.length > 0)
    {
        cell.textLabel.text=[searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        lblCellTitle.text=[[_arrFriendList objectAtIndex:indexPath.row]valueForKey:@"name"];
    }
    
    lblCellTitle.font=[UIFont fontWithName:@"AvenirNext-Regular" size:16];
    [cell.contentView addSubview:lblCellTitle];
    
    UIView *viewsept=[[UIView alloc]initWithFrame:CGRectMake(0,39,screenWidth,1)];
    viewsept.backgroundColor=[[UIColor grayColor]colorWithAlphaComponent:0.6];
    [cell.contentView addSubview:viewsept];
    
    if (theAppDelegate.isSearch == YES)
    {
        
    }
    else
    {
//        UIImageView *imgFrwd=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-20,15,10,10)];
//        imgFrwd.image=[UIImage imageNamed:@"icon_add"];
//        [cell.contentView addSubview:imgFrwd];
        
        UIButton *btnAdd;
        if (cell.accessoryView == nil)
        {
            btnAdd=[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-35,7.5,25,25)];
            
            NSString *indexPat=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            if ([arrSelectedCells containsObject:indexPat])
            {
                [btnAdd setBackgroundImage:[UIImage imageNamed:@"icon_minus1"] forState:UIControlStateNormal];
            }
            else
            {
                [btnAdd setBackgroundImage:[UIImage imageNamed:@"icon_Snap"] forState:UIControlStateNormal];
            }
            
            [btnAdd addTarget:self action:@selector(btnAddPressed:) forControlEvents:UIControlEventTouchUpInside];
            btnAdd.tag=indexPath.row;
            cell.accessoryView=btnAdd;
        }
        
        
    }

    
    cell.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.6];
    return cell;
}

#pragma Mark-delegate methods
//--------------------- Tableview didselected index ---------------------//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (theAppDelegate.isSearch == YES)
    {
        theAppDelegate.isProfFromMenu=NO;
        

        NSString *strStatus=[[_arrFriendList valueForKey:@"privacy"]objectAtIndex:indexPath.row];
        if ([strStatus isKindOfClass:[NSNull class]]) {
            
        }
        else
        {
            if ([strStatus isEqualToString:@"Y"]) {
                [self viewForAlertUI];
            }
            else
            {
                ProfileScreen *objProfile=[[ProfileScreen alloc]initWithNibName:@"ProfileScreen" bundle:nil];
                objProfile.strUserID=[_arrUIDs objectAtIndex:indexPath.row];
                
                [self.navigationController pushViewController:objProfile animated:YES];
                
            }
        }
       
        
    }
    else
    {
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    //get search text from user input
    NSString *searchText = [self.searchController.searchBar text];
    
    //exit if there is no search text (i.e. user tapped on the search bar and did not enter text yet)
    if(!([searchText length] > 0)) {
        
        return;
    }
    //handle when there is search text entered by the user
    else {
        
        if([searchText length] == 0)
        {
            
        }
        //handle when user types in one or more characters in the search bar
        else if(searchText.length > 0) {
            
            [self filterContentForSearchText:searchText
                                       scope:[[self.searchController.searchBar scopeButtonTitles]
                                              objectAtIndex:[self.searchController.searchBar
                                                             selectedScopeButtonIndex]]];
        }
        _tblSearch.hidden=YES;
        [self.view bringSubviewToFront:sendView];
        ((UITableViewController *)self.searchController.searchResultsController).tableView.backgroundColor=[UIColor clearColor];
        [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    searchResults = [_arrNames filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _tblSearch.hidden=NO;
    [_tblSearch reloadData];
}


#pragma mark: view For Alert
-(void)viewForAlertUI
{
    [_viewForAlryFrnd removeFromSuperview];
    _viewForAlryFrnd =[[UIView alloc]initWithFrame:CGRectMake(30, screenHeight/2,screenWidth-50,0)];
    _viewForAlryFrnd.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:.8];
    _viewForAlryFrnd.tag=20;
    [self.view addSubview:_viewForAlryFrnd];
    
    CGRect frameForViewForHelp=_viewForAlryFrnd.frame;
    
    frameForViewForHelp=CGRectMake(0,0,screenWidth,screenHeight);
    [UIView animateWithDuration:0.5f animations:^{
        _viewForAlryFrnd.frame=frameForViewForHelp;
    } completion:^(BOOL finished) {
        vscreenSize=_viewForAlryFrnd.frame;
        vscreenHeight=vscreenSize.size.height;
        vscreenWidth=vscreenSize.size.width;
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(_viewForAlryFrnd.frame.size.width/2-50,([UIScreen mainScreen].bounds.size.height/100*25),100,100)];
        img.image=[UIImage imageNamed:@"icon_Share"];
        [_viewForAlryFrnd addSubview:img];
        UILabel *lblAlert=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(img.frame)+20,_viewForAlryFrnd.frame.size.width,30)];
        lblAlert.text=@"Private profile can't see !!";
        lblAlert.textAlignment=NSTextAlignmentCenter;
        lblAlert.textColor=[UIColor whiteColor];
        lblAlert.font=[UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        [_viewForAlryFrnd addSubview:lblAlert];
        
        _btnProfileAlrt=[[UIButton alloc]init];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            _btnProfileAlrt.frame=CGRectMake(_viewForAlryFrnd.frame.size.width/2-60,CGRectGetMaxY(lblAlert.frame)+50,120,40);
        }
        else
        {
            _btnProfileAlrt=[[UIButton alloc]initWithFrame:CGRectMake(_viewForAlryFrnd.frame.size.width/2-50,CGRectGetMaxY(lblAlert.frame)+50,100,40)];
        }
        
        [_btnProfileAlrt setTitle:@"Close" forState:UIControlStateNormal];
        
        
        [_btnProfileAlrt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnProfileAlrt.layer.borderWidth=2.0;
        _btnProfileAlrt.layer.cornerRadius=4.0;
        _btnProfileAlrt.layer.borderColor=[[UIColor orangeColor]CGColor];
        //[_btnVoteSeeMore addTarget:self action:@selector(btnFBSharePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnProfileAlrt addTarget:self action:@selector(viewForCloseAlert) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewForAlryFrnd addSubview:_btnProfileAlrt];
    }];
}

#pragma mark-Close Comment View
-(void)viewForCloseAlert
{
    @try
    {
        for(UIView *subview in [_viewForAlryFrnd subviews])
        {
            [subview removeFromSuperview];
        }
        
        CGRect frameForViewForVote=_viewForAlryFrnd.frame;
        frameForViewForVote=CGRectMake(30, screenHeight/2,screenWidth-60,0);
        
        [UIView animateWithDuration:0.5f animations:^{
            _viewForAlryFrnd.frame=frameForViewForVote;
        } completion:^(BOOL finished){
            
            [_viewForAlryFrnd removeFromSuperview];
            
            //   [self enableSubViews];
        }];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark: Viewfor Buy single Theme Package
-(void)viewForInvitePopUpUI
{
    [_viewForInvite removeFromSuperview];
    _viewForInvite =[[UIView alloc]initWithFrame:CGRectMake(30, screenHeight/2,screenWidth-50,0)];
    _viewForInvite.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:.8];
    _viewForInvite.tag=20;
    [self.view addSubview:_viewForInvite];
    CGRect frameForViewForHelp=_viewForInvite.frame;
    
    frameForViewForHelp=CGRectMake(0,0,screenWidth,screenHeight);
    [UIView animateWithDuration:0.5f animations:^{
        _viewForInvite.frame=frameForViewForHelp;
    } completion:^(BOOL finished) {
        vscreenSize=_viewForInvite.frame;
        vscreenHeight=vscreenSize.size.height;
        vscreenWidth=vscreenSize.size.width;
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(_viewForInvite.frame.size.width/2-50,[UIScreen mainScreen].bounds.size.height/100*25,100,100)];
        img.image=[UIImage imageNamed:@"icon_Share"];
        [_viewForInvite addSubview:img];
        UILabel *lblInvite=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(img.frame)+20,_viewForInvite.frame.size.width,30)];
        lblInvite.text=@"You Have an Invite!";
        lblInvite.textAlignment=NSTextAlignmentCenter;
        lblInvite.textColor=[UIColor whiteColor];
        lblInvite.font=[UIFont fontWithName:@"AvenirNext-DemiBold" size:25];
//        [_viewForInvite addSubview:lblInvite];
        
        UILabel *lblInvite1=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lblInvite.frame)+20,_viewForInvite.frame.size.width,30)];
        lblInvite1.text=@"Invite sent successfully!";
        lblInvite1.textAlignment=NSTextAlignmentCenter;
        lblInvite1.textColor=[UIColor whiteColor];
        lblInvite1.font=[UIFont fontWithName:@"Avenir-Roman" size:16];
        //[lblInvite1 sizeToFit];
        [_viewForInvite addSubview:lblInvite1];
        
        _btnViewInvite=[[UIButton alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(lblInvite1.frame)+50,_viewForInvite.frame.size.width/2-40,50)];
        _btnCloseInvite=[[UIButton alloc]initWithFrame:CGRectMake(_viewForInvite.frame.size.width/2-40,CGRectGetMaxY(lblInvite1.frame)+50,80,50)];
        
        [_btnViewInvite setTitle:@"View" forState:UIControlStateNormal];
        [_btnCloseInvite setTitle:@"Close" forState:UIControlStateNormal];
        
        [_btnViewInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnCloseInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_btnViewInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnCloseInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_btnCloseInvite addTarget:self action:@selector(closeViewButonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        _btnViewInvite.layer.borderWidth=2.0;
        _btnCloseInvite.layer.borderWidth=2.0;
        
        _btnViewInvite.layer.borderColor=[[UIColor orangeColor]CGColor];
        _btnCloseInvite.layer.borderColor=[[UIColor orangeColor]CGColor];
        
        _btnViewInvite.layer.cornerRadius=5.0;
        _btnCloseInvite.layer.cornerRadius=5.0;
        
        [_btnClseBuySnpbet addTarget:self action:@selector(closeViewButonPressed) forControlEvents:UIControlEventTouchUpInside];
        
//        [_viewForInvite addSubview:_btnViewInvite];
        [_viewForInvite addSubview:_btnCloseInvite];
    }];
}

#pragma mark: Viewfor Buy single Theme Package
-(void)viewForAlertPopupUI
{
    [_viewForAlert removeFromSuperview];
    _viewForAlert =[[UIView alloc]initWithFrame:CGRectMake(30, screenHeight/2,screenWidth-50,0)];
    _viewForAlert.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:.8];
    _viewForAlert.tag=20;
    [self.view addSubview:_viewForAlert];
    CGRect frameForViewForHelp=_viewForAlert.frame;
    
    frameForViewForHelp=CGRectMake(0,0,screenWidth,screenHeight);
    [UIView animateWithDuration:0.5f animations:^{
        _viewForAlert.frame=frameForViewForHelp;
    } completion:^(BOOL finished) {
        vscreenSize=_viewForAlert.frame;
        vscreenHeight=vscreenSize.size.height;
        vscreenWidth=vscreenSize.size.width;
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(_viewForAlert.frame.size.width/2-50,[UIScreen mainScreen].bounds.size.height/100*25,100,100)];
        img.image=[UIImage imageNamed:@"icon_Share"];
        [_viewForAlert addSubview:img];
        UILabel *lblInvite=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(img.frame)+20,_viewForAlert.frame.size.width,30)];
        if(_isFriends)
        {
           lblInvite.text=@"Please select friend name!";
        }
        else if (_isUsers)
        {
            lblInvite.text=@"Please select users name!";
        }
        else if (_isChallenge)
        {
            lblInvite.text=@"Please select challengers name!";
        }
        
        
        lblInvite.textAlignment=NSTextAlignmentCenter;
        lblInvite.textColor=[UIColor whiteColor];
        lblInvite.font=[UIFont fontWithName:@"Avenir-Roman" size:20];
        [_viewForAlert addSubview:lblInvite];
        
        _btnCloseInvite=[[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2-50,CGRectGetMaxY(lblInvite.frame)+10,100,45)];
        
         [_btnCloseInvite setTitle:@"Close" forState:UIControlStateNormal];
        [_btnCloseInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnCloseInvite addTarget:self action:@selector(closeAlertViewButonPressed) forControlEvents:UIControlEventTouchUpInside];
        _btnCloseInvite.layer.borderWidth=2.0;
        _btnCloseInvite.layer.borderColor=[[UIColor orangeColor]CGColor];
        _btnCloseInvite.layer.cornerRadius=5.0;
        
        [_btnClseBuySnpbet addTarget:self action:@selector(closeViewButonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_viewForAlert addSubview:_btnCloseInvite];
    }];
}

#pragma mark-Close Comment View
-(void)closeViewButonPressed
{
//    [_tblSearch reloadData];
    @try
    {
        for(UIView *subview in [_viewForInvite subviews])
        {
            [subview removeFromSuperview];
        }
          CGRect frameForViewForInvite=_viewForInvite.frame;
        
         frameForViewForInvite=CGRectMake(30, screenHeight/2,screenWidth-60,0);
        
        [UIView animateWithDuration:0.5f animations:^
        {
            
           _viewForInvite.frame=frameForViewForInvite;
            
        } completion:^(BOOL finished)
        {
             [_viewForInvite removeFromSuperview];
        }];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark-Close Comment View
-(void)closeAlertViewButonPressed
{
    //    [_tblSearch reloadData];
    @try
    {
        for(UIView *subview in [_viewForAlert subviews])
        {
            [subview removeFromSuperview];
        }
        CGRect frameForViewForInvite=_viewForAlert.frame;
        
        frameForViewForInvite=CGRectMake(30, screenHeight/2,screenWidth-60,0);
        
        [UIView animateWithDuration:0.5f animations:^
         {
             
             _viewForAlert.frame=frameForViewForInvite;
             
         } completion:^(BOOL finished)
         {
             [_viewForAlert removeFromSuperview];
         }];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
#pragma mark: User SignIn Server Call
-(void)searchListServerAPI
{
    NSMutableURLRequest *request;
    if (theAppDelegate.isConnected)
    {
        @try
        {
            [theAppDelegate showSpinnerInView:self.view];
            [self.view setUserInteractionEnabled:NO];
        
            NSString *urlString;
            NSString *strBaseURL=base_URL;
            if (_isFriends)
            {
                urlString =[NSString stringWithFormat:@"wsfriendlist.php?uid=%@",[theAppDelegate.arrUserLoginData objectAtIndex:0]];
            }
            else if (_isUsers)
            {
                urlString=[NSString stringWithFormat:@"wsuserlist.php?uid=%@",[theAppDelegate.arrUserLoginData objectAtIndex:0]];
            }
            else if (_isChallenge)
            {
                urlString=[NSString stringWithFormat:@"wschallengerserch.php?uid=%@",[theAppDelegate.arrUserLoginData objectAtIndex:0]];
            }
        
            strBaseURL=[strBaseURL stringByAppendingString:urlString];
            NSURL *urlData=[NSURL URLWithString:strBaseURL];
            request=[NSMutableURLRequest requestWithURL:[urlData standardizedURL]];
        
            if(!connection)
                connection= [[WebConnection1 alloc] init];
                connection.delegate = self;
            [connection makeConnection:request];
            request = nil;
            
            }
        @catch (NSException *exception)
        {
            
        }
        @finally
        {
            
        }
    }
    else
    {
        
    }
}


#pragma mark-Send Link Server Call
-(void)sendLinkServerCall
{
    //http://54.67.95.152/snapbets/aws/wsinvite.php?sid=2&uid=2,3,4,5,6,7
    _isSendLink=YES;
    NSMutableURLRequest *request;
    if (theAppDelegate.isConnected)
    {
        @try
        {
            [theAppDelegate showSpinnerInView:self.view];
            [self.view setUserInteractionEnabled:NO];
            
            NSString *urlString;
            NSString *strBaseURL=base_URL;
            urlString =[NSString stringWithFormat:@"wsinvite.php?sid=%@&uid=%@",_snapID,selectedUIDs];
            strBaseURL=[strBaseURL stringByAppendingString:urlString];
            NSURL *urlData=[NSURL URLWithString:strBaseURL];
            request=[NSMutableURLRequest requestWithURL:[urlData standardizedURL]];
            
            if(!connection)
                connection= [[WebConnection1 alloc] init];
            connection.delegate = self;
            [connection makeConnection:request];
            request = nil;
            
        }
        @catch (NSException *exception)
        {
            
        }
        @finally
        {
            
        }
    }
}

#pragma mark: Web Response From JSON
-(void) webResponse:(NSMutableDictionary*)response
{
    [theAppDelegate stopSpinner];
    [self.view setUserInteractionEnabled:YES];
    _arrFriendList=[[NSMutableArray alloc]init];
    dict =[[NSMutableDictionary alloc]initWithDictionary:response];
    NSLog(@"%@",dict);
    
    NSString *strMessage=[dict valueForKey:@"message"];
    if ([strMessage isEqualToString:@"sus"])
    {
        if (_isSendLink == YES)
        {
            _isSendLink=NO;
            [self viewForInvitePopUpUI];
        }
        else
        {
            _arrNames=[[NSMutableArray alloc]init];
            _arrUIDs=[[NSMutableArray alloc]init];
            _arrFriendList=[dict valueForKey:@"info"];
            if([_arrFriendList isEqual:(id)[NSNull null]])
            {
                _arrFriendList=[[NSMutableArray alloc]init];
                _arrNames=[[NSMutableArray alloc]init];
                [_tblSearch reloadData];
            }
            else
            {
                for (int i=0;i<[_arrFriendList count];i++)
                {
                    [_arrNames addObject:[[_arrFriendList objectAtIndex:i]valueForKey:@"name"]];
                    [_arrUIDs addObject:[[_arrFriendList objectAtIndex:i] valueForKey:@"uid"]];
                    [_tblSearch reloadData];
                }
            }
        }
        
        
        
    }
    else
    {
        
    }
}
@end
