
#ifndef Test_HeaderAndConstants_h
#define Test_HeaderAndConstants_h

//------------ Screen Size ------------------------ //
#define screenSize [UIScreen mainScreen].bounds
#define screenWidth screenSize.size.width
#define screenHeight screenSize.size.height

//----------------- Class Shared Instance ----------//
#define theAppDelegate  ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define theVNRequestOperations  [VNRequestOperation sharedInstance]

//------------- Messages -------------//
#define connectionErrorMsg @"The Internet connection to be offline."

//----- Service Request Strings ------//
#define GET_Method @"GET"
#define POST_Method @"POST"

#endif
