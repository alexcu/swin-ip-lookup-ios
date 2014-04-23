//
//  Assignment 6
//  COS30007 - CDDMA
//
//  Alex Cummaudo, 1744070
//  2014-04-22
//

#import "IPViewController.h"
#import "IPGetInfoRequest.h"
#import "IPAddress.h"

@interface IPViewController ()

/// Generates and loads a new random IP address infomation
-(void) newIPAddress;
/// Gets information based on IP address given
-(void) beginLoadingInfoForIPAddress:(IPAddress*) ip;
/// Called when getting IP address details request fails
-(void) didGetInfoForIPAddress:(NSNotification*) notif;
/// Called when getting IP address details request fails
-(void) didFailToGetIP:(NSNotification*) notif;
/// Called when IP address details request recieves data
-(void) didUpdateProgress:(NSNotification*) notif;
/// Stops listening for notifications from notification center
-(void) stopListeningForNotifications;
/// The table for displaying IP address info
@property (strong, nonatomic) IBOutlet UITableView *ipDetailTableView;
/// The loader for progress when request is made
@property (weak, nonatomic) IBOutlet UIProgressView *progressLoader;

/// The cells for info (using **STATIC** cells since the #rows/sections will not change)
@property (weak, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *regionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *countryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cityCell;

// Map to display coordinates
@property (weak, nonatomic) IBOutlet MKMapView *coordinatesMap;

@end

@implementation IPViewController

#pragma mark - Setup

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Init the updateable cells
  _updateableCells = @[_addressCell, _regionCell, _countryCell, _cityCell];
  
  // On load of view, load me
  [self beginLoadingInfoForIPAddress:nil];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Button Interaction

- (IBAction)myIPButtonTapped:(id)sender
{
  // Use nil to signify me
  [self beginLoadingInfoForIPAddress:nil];
}

- (IBAction)reloadButtonTapped:(id)sender
{
  [self newIPAddress];
}

#pragma mark - IP Address Info

-(void) newIPAddress
{
  // And begin loading details for a random IP address
  _ipAddress = [IPAddress generateRandomIP];
  [self beginLoadingInfoForIPAddress:_ipAddress];
}

-(void) beginLoadingInfoForIPAddress:(IPAddress*) ip
{
  // Make all cells appear as "loading"
  for (UITableViewCell* cell in _updateableCells)
  {
    [[cell detailTextLabel] setText:@"Loading..."];
    [[cell detailTextLabel] setTextColor:[UIColor colorWithWhite:0.0f alpha:0.6f]];
  }
  [_ipDetailTableView reloadData];
  
  // Show progress loader
  [_progressLoader setHidden:NO];
  [_progressLoader setProgress:0 animated:NO];
  
  IPGetInfoRequest* req = [[IPGetInfoRequest alloc] initToGetDetailsForIP:ip];
  // Setup notif center listeners to listen to this request
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didUpdateProgress:)
                                               name:@"pct"
                                             object:req];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didFailToGetIP:)
                                               name:@"failed"
                                             object:req];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didGetInfoForIPAddress:)
                                               name:@"success"
                                             object:req];
}

-(void) didUpdateProgress:(NSNotification *)notif
{
  [_progressLoader setProgress:[[notif object] percentageLoaded] animated:YES];
}

-(void) didGetInfoForIPAddress:(NSNotification *)notif
{
  [self stopListeningForNotifications];
  
  // Update cells to black (since finished loading...)
  for (UITableViewCell* cell in _updateableCells)
    [[cell detailTextLabel] setTextColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
  
  // Set our IP address to display to the IP Address that was loaded (from the sender of
  // the notification (i.e., IPGetInfoRequest)
  _ipAddress = [[notif object] ipAddressLoaded];
  
  // `Glue' text labels (view objects) to details in ipAddress (model object)
  [[_addressCell detailTextLabel] setText:[_ipAddress printableAddress]];
  [[_regionCell  detailTextLabel] setText:[_ipAddress region          ]];
  [[_countryCell detailTextLabel] setText:[_ipAddress country         ]];
  [[_cityCell    detailTextLabel] setText:[_ipAddress city            ]];
  
  // Hide the map section if no coordinates could be loaded
  if ([_ipAddress hasCoords] == NO)
  {
    [_coordinatesMap setHidden:YES];
  }
  else
  {
    // Work out the appropriate dimensions to display the coord...
    MKCoordinateSpan span  = MKCoordinateSpanMake(0.01f, 0.01f);
    MKCoordinateRegion reg = MKCoordinateRegionMake([_ipAddress coord], span);
    
    [_coordinatesMap setHidden:NO];
    [_coordinatesMap setRegion:reg animated:YES];
  }
  
  [_ipDetailTableView reloadData];
  
}

-(void) didFailToGetIP:(NSNotification *)notif
{
  [self stopListeningForNotifications];
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                  message:@"Couldn't load the data for IP address!"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Retry", nil];
  [alert show];
}

-(void) stopListeningForNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Alert View Delegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  // If retry is pressed?
  if (buttonIndex == 1)
    [self beginLoadingInfoForIPAddress:_ipAddress];
}


@end
