    //
//  InAppPuchaseViewController.m
//  Image Fun
//
//  Created by Santosh Bayas on 7/2/12.
//  Copyright 2012 abc. All rights reserved.
//

#import "InAppPuchaseViewController.h"
#import "InAppRageIAPHelper.h"
#import "Reachability.h"
#import "AppDelegate.h"

//#define kSampleAppkey @"017ef875c0aa40d6a406ee5a5d188c36"
#define kSampleAppkey @"0949"

@implementation InAppPuchaseViewController
@synthesize inAppTableView, inAppArray;
@synthesize hud = _hud;



/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.navigationItem.title = @"InApp Purchase";
	
	appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
		
	inAppArray = [[NSMutableArray alloc]initWithObjects:@"Emoticon FunPlusPack", @"Remove Ads", nil];
	
	UIImage *img = [UIImage imageNamed:@"BlueBackgound.png"];
	
	UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// The device is an iPad running iPhone 3.2 or later.
		imgView.frame = CGRectMake(0, 0, 768, 1024);
		inAppTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, 768, 924) style:UITableViewStyleGrouped];
				
		[inAppTableView setBackgroundView:nil];
		[inAppTableView setBackgroundView:[[UIView alloc] init]];
	}
	else
	{
		//iPhone
		imgView.frame = CGRectMake(0, 0, 320, 480);
		inAppTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, 320, 410) style:UITableViewStyleGrouped];
    }
	
	[self.view addSubview:imgView];
	
	inAppTableView.dataSource = self;
	inAppTableView.delegate = self;
	inAppTableView.backgroundColor = [UIColor clearColor];
	[inAppTableView setSeparatorColor:[UIColor whiteColor]];
    self.inAppTableView.backgroundView = nil;
	[self.view addSubview:inAppTableView];
}

- (void)dismissHUD:(id)arg {
    
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
}

- (void)timeout:(id)arg {
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
    _hud.customView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}

-(void)updateInterfaceWithReachability: (Reachability*) curReach
{
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO];
//	}

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
        NSLog(@"No internet connection!");
        //theAppDelegate.alert.message=@"Please check internet connection and try again.";
        //theAppDelegate.alert.show;
    }
    else
    {
        if ([InAppRageIAPHelper sharedHelper].products == nil)
        {
            [[InAppRageIAPHelper sharedHelper] requestProducts];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Loading...";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
        }        
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
//    if(!appDelegate.isAddAppPurchased)
//    {
//        [adView removeFromSuperview];
//
//        //[adView release];
//    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[InAppRageIAPHelper sharedHelper].products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		
       cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
				
    }
	
	cell.backgroundColor= [UIColor clearColor];
	// Configure the cell...
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		cell.textLabel.font = [UIFont systemFontOfSize:40];
	
    //cell.textLabel.text = [inAppArray objectAtIndex:indexPath.row];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	// Configure the cell.
    SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:indexPath.row];
	
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
	
    cell.textLabel.text = product.localizedTitle;
    cell.detailTextLabel.text = formattedString;
	cell.detailTextLabel.textColor = [UIColor whiteColor];
		
    if ([[InAppRageIAPHelper sharedHelper].purchasedProducts containsObject:product.productIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
        cell.accessoryView = nil;
		
		//write purchased product in file
		if(indexPath.row == 0)
		{
			//Additional Filters Purchased
           // appDelegate.isFilterPurchased = YES;
		}
		else if(indexPath.row == 1)
		{
			//Remove Add Purchased
			
           // appDelegate.isAddAppPurchased = YES;
          //  adView.hidden=YES;
		}
		
		
    } else {        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(0, 0, 72, 37);
        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
        buyButton.tag = indexPath.row;
        [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;     
    }
	
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat cellHight;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// The device is an iPad running iPhone 3.2 or later.
		cellHight = 100;
	}
	else 
	{
		//iPhone
		cellHight = 45;
	}
	return cellHight;
}




#pragma mark 
#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSInteger row = [indexPath row];
	//NSLog(@"row = %i", row);
}


- (IBAction)buyButtonTapped:(id)sender 
{
    UIButton *buyButton = (UIButton *)sender;    
    SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:buyButton.tag];
	
    NSLog(@"Buying %@...", product.productIdentifier);
    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
	
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Buying...";
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
   // self.inAppTableView.hidden = FALSE;    
    
    [self.inAppTableView reloadData];
    
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];    
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
        
    [self.inAppTableView reloadData];
	[self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:0.0];
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {
       // theAppDelegate.alert.title=@"Error";
       // theAppDelegate.alert.message=transaction.error.localizedDescription;
       // theAppDelegate.alert.show;
        
		[self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:0.0];
    }
    
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)writeToFile:(NSString *)fileName andProductString:(NSString *)productName
{
	NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *docDir = [docArray objectAtIndex:0];
	
	NSString *docFileName = [docDir stringByAppendingPathComponent:fileName];
	
	//NSLog(@"FilePath:%@", docFileName);
	
	return [productName writeToFile:docFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	//[productName writeToFile:docFileName atomically:YES];
}

- (UIViewController *)viewControllerForPresentingModalView {
	
	//return UIWindow.viewController;
	return self;
	
}

@end
