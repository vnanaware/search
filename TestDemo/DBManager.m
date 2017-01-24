//
//  DBManager.m
//  weStudiez
//
//  Created by Bhimashankar Vibhute on 1/16/15.
//  Copyright (c) 2015 Syneotek Software Solutions. All rights reserved.
//

#import "DBManager.h"
#import "AppDelegate.h"
static DBManager *sharedInstance=nil;
static sqlite3_stmt *statment=nil;
static sqlite3 *database=nil;
@implementation DBManager

+(DBManager*)getSharedInstance
{
    if (!sharedInstance) {
        sharedInstance=[[DBManager allocWithZone:NULL] init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}
+(BOOL)closeDB
{
    sqlite3_close(database);
    return true;
}
#pragma mark - createDB

NSString *docDir;
NSArray *dirPath;
NSString *insertQuery;
BOOL isSuccess;

const char *Localquery;
char *errorMsg;
const char *dbPath;

#pragma mark -database creation

-(BOOL)createDB
{
    dirPath=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,NSUserDomainMask,YES);
    docDir=dirPath[0];
    isSuccess=true;
    databasePath=[docDir stringByAppendingString:@"Snapbet.db"];
    
  NSLog(@"Directory Path:%@",databasePath);
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    //-----below code check if database file is exists or not if not then create new

    if ([fileManager fileExistsAtPath:databasePath]==NO) {
        
        const char *dbPath=[databasePath UTF8String];
    
    //----------------below code create databse & open that-----------------//
        
         if (sqlite3_open(dbPath, &database)==SQLITE_OK) {
          //  char *errorMsg;
             isSuccess=true;
   //-----if databse created successfully then enterd into this if ---------//

           }
    //--------------if error while creating databse then enter into else part-----//
        else
        {
            isSuccess=false;
            NSLog(@"Failed to create database");
        }
        
    }
    sqlite3_close(database);
    return isSuccess;
}

#pragma  mark -create tables with query

-(BOOL)createTableWithQuery:(NSString *)query
{
    if (isSuccess) {
        Localquery=[query UTF8String];
        //--------------------------open databse----------------------------------//
        const char *dbPath=[databasePath UTF8String];
        if (sqlite3_open(dbPath, &database)==SQLITE_OK) {
            NSLog(@"databse is open");
        }
        else
        {
            NSLog(@"Failed to open databse");
            return false;
        }
        //------------create new table once databse is created -------------------//
        if (sqlite3_exec(database, Localquery, NULL, NULL, &errorMsg)!=SQLITE_OK) {
            //------error while creating new table------//
            NSLog(@"Failed to create table with error \n%s",errorMsg);
            return false;
        }
        //--------------if table created then close databse & return success-----//
        NSLog(@"Table is created");
        sqlite3_close(database);
        return true;
    }
    else
    {
        NSLog(@" Error While creating databse");
        sqlite3_close(database);
        return false;
    }
}

#pragma mark -select method with query

-(NSArray*)selectTableDataWithQuery:(NSString*)query
{
    const char *sql=[query UTF8String];
    NSMutableArray *requestedList=[[NSMutableArray alloc] init];
    
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
 
        if (sqlite3_prepare_v2(database, sql, -1, &statment, NULL)==SQLITE_OK) {
            
            for (int i=0;sqlite3_step(statment)==SQLITE_ROW;i++) {
                NSMutableArray *row=[[NSMutableArray alloc] init];
                for (int j=0; j<sqlite3_column_count(statment); j++) {
                    NSString *str=[NSString stringWithFormat:@"%s",sqlite3_column_text(statment, j)];
                    [row addObject:str];
                    }
                [requestedList addObject:row];

                 NSLog(@"Dala Loaded Succesfully");
            }
            sqlite3_close(database);
            return requestedList;
            }
        else
        {
            sqlite3_close(database);
            NSLog(@"%s",errorMsg);
            return nil;
        }
  }
    sqlite3_close(database);
    return nil;
}
#pragma mark- add Record to DB
-(BOOL) insertDataWithQuery:(NSString*)query
{
    //query = [query stringByReplacingOccurrencesOfString:@"'''" withString:@"''"];
    
    statment=nil;
    if(sqlite3_open([databasePath UTF8String],&database)==SQLITE_OK)
        @try {
           // int res=sqlite3_prepare_v2(database, [query UTF8String], [query length], &statment,NULL);
            int calLength=(int)query.length;
            NSLog(@"%d",calLength);
            NSInteger res = sqlite3_prepare_v2(database,[query UTF8String], -1,&statment,NULL);
            
         //  NSLog(@"result code is %",res);
           if(res==SQLITE_OK)
            
                   
            {
                if(sqlite3_step(statment)==SQLITE_DONE)
                {
                     NSLog(@"Successfully adding record");
                    sqlite3_finalize(statment);
                    sqlite3_close(database);
                    statment=nil;
                    return true;
                }
                NSLog(@"Error while adding record");
                sqlite3_finalize(statment);
                sqlite3_close(database);
                statment=nil;
                return false;
            }
            NSLog(@"Error while opning db at task adding record %s",errorMsg);
            sqlite3_finalize(statment);
            sqlite3_close(database);
            statment=nil;
            return false;

        }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
        }
-(BOOL)deleteFromTableWithQuery:(NSString*)query
{
    if (isSuccess) {
        Localquery=[query UTF8String];
        //--------------------------open databse----------------------------------//
        const char *dbPath=[databasePath UTF8String];
        if (sqlite3_open(dbPath, &database)==SQLITE_OK) {
            NSLog(@"databse is open");
        }
        else
        {
            NSLog(@"Failed to open databse");
            return false;
        }
        //------------create new table once databse is created -------------------//
        if (sqlite3_exec(database, Localquery, NULL, NULL, &errorMsg)!=SQLITE_OK) {
            //------error while creating new table------//
            NSLog(@"Failed to delete reminder \n%s",errorMsg);
            return false;
        }
        //--------------if table created then close databse & return success-----//
        NSLog(@"reminder is deleted");
        
        sqlite3_close(database);
        return true;
    }
    else
    {
        NSLog(@" Error While deleting reminder");
        sqlite3_close(database);
        return false;
    }

    return false;
}
-(BOOL)updateDataWithQuery:(NSString *)query
{
    statment=nil;
    const char *sql=[query UTF8String];
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        sqlite3_prepare_v2(database, sql, -1, &statment, NULL);
        int res=sqlite3_step(statment);
        NSLog(@"result=%d",res);
        if(res==SQLITE_DONE)
        {
            NSLog(@"1 row updated");
            sqlite3_close(database);
            return true;
        }
        else
            NSLog(@"Error %s",sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    return false;
}

/*
-(UIImage*)getVideoThumbnailFromURL:(NSString*)stringURL delegate:(id)senderDelegate
{
    @try
    {
        
        if (stringURL)
        {
            self.delegate=senderDelegate;
            
            NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *directory=path[0];
            NSString *strImageName=[stringURL stringByReplacingOccurrencesOfString:@"http://www.mobile.mylib.ug/video" withString:@""];
            strImageName=[strImageName stringByReplacingOccurrencesOfString:@".mp4" withString:@".png"];
            
            NSString *strImagePath=[directory stringByAppendingString:strImageName];
            UIImage *thumbnail=[UIImage imageNamed:strImagePath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:strImagePath])
            {
                //url = [[NSURL alloc]initWithString:strVideoPath];
                thumbnail=[[UIImage alloc]initWithContentsOfFile:strImagePath];
            }
            else
            {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSURL *partOneUrl = [[NSURL alloc]initWithString:stringURL];
                    
                    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:partOneUrl options:nil];
                    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
                    generate1.appliesPreferredTrackTransform = YES;
                    NSError *err = NULL;
                    CMTime time = CMTimeMake(1, 2);
                    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
                    UIImage *thumbnail = [[UIImage alloc] initWithCGImage:oneRef];
                    
                    NSData *imgData=UIImagePNGRepresentation(thumbnail);
                    [imgData writeToFile:strImagePath atomically:YES];
                    thumbnail=[UIImage imageNamed:strImagePath];
                    
                    if (thumbnail.images == nil) {
                        //thumbnail=[UIImage imageNamed:@"myLibNewLogo"];
                    }
                    if ([self.delegate respondsToSelector:@selector(akVideoThumbnailDidFinishDownloading:)])
                    {
                        [self.delegate akVideoThumbnailDidFinishDownloading:thumbnail];
                    }
                });
                
            }
            return thumbnail;
        }
        return nil;
    }
    @catch (NSException *exception)
    {
        
    } @finally
    {
        
    }
}*/
  @end
