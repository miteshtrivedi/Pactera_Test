//
//  NewsViewController.m
//  Pactera_test_MT
//
//  Created by Mitesh Trivedi on 20/11/2016.
//  Copyright (c) 2016 Mitesh. All rights reserved.
//

#import "NewsViewController.h"


#define TITLE_FONT_SIZE 14.0f
#define DESC_FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface NewsViewController ()

@end

@implementation NewsViewController
@synthesize tblNews,arrNews;
@synthesize imageDict,isDecliring_msg,isDragging_msg;
- (void)viewDidLoad {
    
    
//Method to programmatically allocate tableview and call webservice.
    [self loadAllComponents];

    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LoadView

-(void)loadAllComponents
{
//********* Tableview intialization **************************************
    self.tblNews=[[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-30, self.view.frame.size.height)];
    self.tblNews.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tblNews.delegate = self;
    self.tblNews.dataSource = self;
    [self.view addSubview:self.tblNews];
    
//***************************************************************************
    
//***************** Referesh button intialization *****************************
    UIBarButtonItem *btnRefresh=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh_Click:)];
    self.navigationItem.rightBarButtonItem=btnRefresh;
//***************************************************************************
    
    
//***************** Lazy Loading Image Dictionary intialization *****************************
    self.imageDict=[[NSMutableDictionary alloc]init];
//***************************************************************************


//******************* Web API calling Method *******************************************
    [self webAPICall];
//***************************************************************************
    
}


#pragma mark Button Click
-(IBAction)refresh_Click:(id)sender
{
    [self webAPICall];
}

#pragma mark webservice call

-(void)webAPICall
{
//******************* Start Activity Indicator *******************************************
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//***************************************************************************************
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error == nil)
        {
            
            NSString *iso = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
            NSData *dutf8 = [iso dataUsingEncoding:NSUTF8StringEncoding];
            NSError *JsonError = nil;

            NSDictionary *JSON =
            [NSJSONSerialization JSONObjectWithData: dutf8
                                            options: NSJSONReadingMutableContainers
                                              error: &JsonError];
            
            if(error!=nil)
            {
//******************* Stop Activity Indicator *******************************************
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//***************************************************************************************
            }
            else
            {
                self.arrNews=[JSON objectForKey:@"rows"];
                self.navigationItem.title=[JSON objectForKey:@"title"];
                [self.tblNews reloadData];
                
//******************* Stop Activity Indicator *******************************************
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//***************************************************************************************

            }
            
           
        }
        else{
            
//******************* Stop Activity Indicator *******************************************
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//***************************************************************************************
            NSLog(@"Error : %@",error.description);
            
        }
        
        
    }];
    
    
    [postDataTask resume];
}




#pragma mark UITableViewDelegate-Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrNews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"NewTableIdentifier";
    
    UITableViewCell * cell = nil;
    if(cell == nil)
    {
//******************* UITableViewCell Intialization *******************************************

        
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:SimpleTableIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
//******************************** Title Label *************************************************
        
        UILabel *lblTitle=[[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.tblNews.frame.size.width-50, [self getDynamicTextHeight:[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"title"]isTitle:YES])] autorelease];
        lblTitle.lineBreakMode=NSLineBreakByWordWrapping;
        lblTitle.numberOfLines=0;
        [lblTitle setFont:[UIFont systemFontOfSize:TITLE_FONT_SIZE]];
        lblTitle.textColor=[UIColor blueColor];
        if (![[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"title"] isEqual:[NSNull null]])
        {
            lblTitle.text=[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"title"];
            
        }
        else
            lblTitle.text=@"No Title Found";

        [cell.contentView addSubview:lblTitle];
        
//******************************** Desc Label *************************************************
        
        UILabel *lblDescription=[[[UILabel alloc]initWithFrame:CGRectMake(10, lblTitle.frame.size.height + 20, self.tblNews.frame.size.width-90, [self getDynamicTextHeight:[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"description"]isTitle:NO])] autorelease];
        lblDescription.lineBreakMode=NSLineBreakByWordWrapping;
        lblDescription.numberOfLines=0;
        [lblDescription setFont:[UIFont systemFontOfSize:DESC_FONT_SIZE]];
        lblDescription.textColor=[UIColor blackColor];
        if (![[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"description"] isEqual:[NSNull null]])
        {
            lblDescription.text=[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"description"];
            
        }
        else
            lblDescription.text=@"No Description Found";
        
        [cell.contentView addSubview:lblDescription];

        
//******************************** Lazy Load Image **********************************************
        
        UIImageView *imgView=[[[UIImageView alloc]initWithFrame:CGRectMake(self.tblNews.frame.size.width-70, lblTitle.frame.size.height + 20, 60, 40)] autorelease];
        imgView.contentMode=UIViewContentModeScaleAspectFit;
        if ([[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"imageHref"] isEqual:[NSNull null]])
        {
            [self.imageDict setObject:[UIImage imageNamed:@"LoadingImg@2x.png"] forKey:@"NoImage"];
            imgView.image=[UIImage imageNamed:@"LoadingImg@2x.png"];
        }
        else
        {
            if ([imageDict valueForKey:[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"imageHref"]])
            {
                imgView.image=[imageDict valueForKey:[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"imageHref"]];
            }
            else
            {
                if (!self.isDragging_msg && !self.isDecliring_msg)
                {
                    [self.imageDict setObject:[UIImage imageNamed:@"LoadingImg@2x.png"] forKey:[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"imageHref"]];
                    [self performSelectorInBackground:@selector(lazyDownloadImage:) withObject:indexPath];
                }
                else
                {
                    imgView.image=[UIImage imageNamed:@"LoadingImg@2x.png"];
                }
            }
        }
        
        
        [cell.contentView addSubview:imgView];
        
   	}
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    CGFloat rowHeight=0.0;

    rowHeight +=[self getDynamicTextHeight:[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"title"] isTitle:YES] + [self getDynamicTextHeight:[[self.arrNews objectAtIndex:indexPath.row] objectForKey:@"description"] isTitle:NO];
    
    return rowHeight + 20.0;
    
}

#pragma mark getDynamicTextHeight

-(CGFloat)getDynamicTextHeight:(NSString *)strText isTitle:(BOOL)isTitle
{
    if (![strText isEqual:[NSNull null]])
    {
        CGSize maximumLabelSize ;
        CGRect textSize;
        if (isTitle)
        {
            maximumLabelSize= CGSizeMake(self.tblNews.frame.size.width - 20, CGFLOAT_MAX);
           textSize = [ strText boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TITLE_FONT_SIZE]}
                                     context:nil];

        }
        else
        {
            maximumLabelSize= CGSizeMake(self.tblNews.frame.size.width - 90, CGFLOAT_MAX);
            textSize = [ strText boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:DESC_FONT_SIZE]}
                                              context:nil];

        }
        
        CGFloat height = MAX(textSize.size.height, 20.f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
        
    }
    return 44.0;
}

#pragma mark LazyLoading Image

-(void)lazyDownloadImage:(NSIndexPath *)path
{
    NSAutoreleasePool *pl = [[NSAutoreleasePool alloc] init];
    
    NSString *str=[[self.arrNews objectAtIndex:path.row] objectForKey:@"imageHref"];
    
    UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
    if(img==nil)
    {
        [self.imageDict setObject:[UIImage imageNamed:@"LoadingImg@2x.png"] forKey:[[self.arrNews objectAtIndex:path.row] objectForKey:@"imageHref"]];
    }
    else
    {
        [self.imageDict setObject:img forKey:[[self.arrNews objectAtIndex:path.row] objectForKey:@"imageHref"]];
    }

    
    
    [self.tblNews performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    [pl release];
}


#pragma mark ScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.isDragging_msg = FALSE;
    [self.tblNews reloadData];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isDecliring_msg = FALSE;
    [self.tblNews reloadData];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isDragging_msg = TRUE;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.isDecliring_msg = TRUE;
}


#pragma mark Dealloc

-(void)dealloc
{
    [self.tblNews release];
    [self.arrNews release];
    [self.imageDict release];
    [super dealloc];
    
}

@end
