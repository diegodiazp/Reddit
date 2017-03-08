//
//  ViewController.m
//  Rappi
//
//  Created by Diego Diaz on 4/03/17.
//  Copyright © 2017 Diego Diaz. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "subredditCell.h"
#import "detailView.h"
#import "sudRedditiPadCell.h"

@interface ViewController ()
{
    Reachability* internetReachable;
    Reachability* hostReachable;
    BOOL internetActive;
    BOOL hostActive;
    
    NSArray *arrayChildren;
}

@end

@implementation ViewController

static NSString *jsonUrl = @"https://www.reddit.com/reddits.json";

-(void) viewWillAppear:(BOOL)animated
{
    // check for internet connection
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"Reddits";

}

-(void)viewDidAppear:(BOOL)animated
{
    [_activityLoading startAnimating];

    [self checkConnection];
    
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        BOOL alreadyAdded = [self.view viewWithTag:10] != nil;
        
        if (!alreadyAdded) {
            _tableCategories = [[UITableView alloc] initWithFrame:CGRectMake(0, _lblTitle.frame.origin.y + _lblTitle.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.height -_lblTitle.frame.size.height - 40) style:UITableViewStylePlain];
            _tableCategories.delegate = self;
            _tableCategories.dataSource = self;
            _tableCategories.tag = 10;
            [self.view addSubview:_tableCategories];
        }

    }
    else
    {
        BOOL alreadyAdded = [self.view viewWithTag:20] != nil;
        
        if (!alreadyAdded) {
            
            UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
            _collectionSubReddits=[[UICollectionView alloc] initWithFrame:CGRectMake(0, _lblTitleiPad.frame.origin.y + _lblTitleiPad.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.height -_lblTitleiPad.frame.size.height - 100) collectionViewLayout:layout];
            [_collectionSubReddits setDataSource:self];
            [_collectionSubReddits setDelegate:self];
            _collectionSubReddits.tag = 20;
            _collectionSubReddits.backgroundColor = [UIColor clearColor];

            UINib *nib = [UINib nibWithNibName:@"sudRedditiPadCell" bundle:nil];
            [_collectionSubReddits registerNib:nib forCellWithReuseIdentifier:@"_redditiPadCell"];
            
            [self.view addSubview:_collectionSubReddits];
        }
    }
    
    if (!internetActive) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Información" message:@"No tienes acceso a internet" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                  {
                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
        [alert addAction:aceptar];
        [self presentViewController:alert animated:YES completion:nil];
        
        arrayChildren = [self loadInfo];
        
    }
    else
    {
        //Arrays para Apps
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonUrl]];
        NSMutableDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        arrayChildren = [[dictJson objectForKey:@"data"] objectForKey:@"children"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"jsonData"];
        
        [NSKeyedArchiver archiveRootObject:arrayChildren toFile:filePath];

    }
    


}

-(void)stopHideLoading
{
    [_activityLoading stopAnimating];
    _viewLoading.hidden = YES;
}

-(void)starShowLoading
{
    [_activityLoading startAnimating];
    _viewLoading.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkConnection
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            internetActive = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            hostActive = YES;
            
            break;
        }
    }

}

-(NSArray *)loadInfo
{
    NSArray *savedData;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"jsonData"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    return savedData;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayChildren count] ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"subredditCell";
    
    subredditCell *cell = (subredditCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"subredditCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *urlImg = [[[arrayChildren objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"icon_img"];
    UIImage *iconImage = urlImg ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImg]]]: nil;
    cell.iconImg.image = iconImage;
    cell.title.text =[[[arrayChildren objectAtIndex:indexPath.row] objectForKey: @"data"] objectForKey:@"display_name"];
    cell.descriptionLbl.text = [[[arrayChildren objectAtIndex:indexPath.row] objectForKey: @"data"] objectForKey:@"public_description"];
    cell.suscriptors.text = [NSString stringWithFormat:@"%@ Suscriptores",[[[arrayChildren objectAtIndex:indexPath.row] objectForKey: @"data"] objectForKey:@"subscribers"]];

    [self stopHideLoading];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self starShowLoading];
    detailView *_detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    _detail.dictReddit = [[arrayChildren objectAtIndex:indexPath.row] objectForKey:@"data"];
    [self.navigationController pushViewController:_detail animated:YES];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [arrayChildren count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *_iPadcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"_redditiPadCell" forIndexPath:indexPath];
    _iPadcell.layer.borderWidth = 1;
    _iPadcell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _iPadcell.layer.cornerRadius = 3;

    NSString *urlImg = [[[arrayChildren objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"icon_img"];
    UIImage *iconImage = urlImg ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImg]]]: nil;
    UIImageView *imgIcon = (UIImageView *)[_iPadcell viewWithTag:2];
    imgIcon.image = iconImage;
    
    UILabel *lblTitle = (UILabel *)[_iPadcell viewWithTag:1];
    lblTitle.text =[[[arrayChildren objectAtIndex:indexPath.row] objectForKey: @"data"] objectForKey:@"display_name"];

    UILabel *lblDescription = (UILabel *)[_iPadcell viewWithTag:3];
    lblDescription.text = [[[arrayChildren objectAtIndex:indexPath.row] objectForKey: @"data"] objectForKey:@"public_description"];
    
    UILabel *lblSuscriptors = (UILabel *)[_iPadcell viewWithTag:4];
    lblSuscriptors.text = [NSString stringWithFormat:@"%@ Suscriptores",[[[arrayChildren objectAtIndex:indexPath.row] objectForKey: @"data"] objectForKey:@"subscribers"]];
    
    [self stopHideLoading];
    return _iPadcell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 150);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self starShowLoading];

    detailView *_detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    _detail.dictReddit = [[arrayChildren objectAtIndex:indexPath.row] objectForKey:@"data"];
    [self.navigationController pushViewController:_detail animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        NSIndexPath*selection = [_tableCategories indexPathForSelectedRow];
        if (selection)
        {
            [_tableCategories deselectRowAtIndexPath:selection animated:YES];
        }
        [_tableCategories reloadData];
    }
    else
    {
        
        for (NSIndexPath *indexPath in [_collectionSubReddits indexPathsForSelectedItems])
        {
            [_collectionSubReddits deselectItemAtIndexPath:indexPath animated:NO];
        }

        [_collectionSubReddits reloadData];
    }

}

@end
