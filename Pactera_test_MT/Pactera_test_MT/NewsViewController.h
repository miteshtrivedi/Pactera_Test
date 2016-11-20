//
//  NewsViewController.h
//  Pactera_test_MT
//
//  Created by Mitesh Trivedi on 20/11/2016.
//  Copyright (c) 2016 Mitesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate,UIScrollViewDelegate>

@property (retain,nonatomic)UITableView *tblNews;
@property (retain,nonatomic)NSMutableArray *arrNews;
@property (retain,nonatomic) NSMutableDictionary *imageDict;
@property (readwrite,assign) BOOL isDragging_msg, isDecliring_msg;

/***** Method Declaration ****/
-(void)webAPICall;
-(void)lazyDownloadImage:(NSIndexPath *)path;
-(CGFloat)getDynamicTextHeight:(NSString *)strText isTitle:(BOOL)isTitle;

@end
