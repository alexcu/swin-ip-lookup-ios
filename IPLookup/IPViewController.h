//
//  Assignment 6
//  COS30007 - CDDMA
//
//  Alex Cummaudo, 1744070
//  2014-04-22
//

#import <UIKit/UIKit.h>

// Forward declarations
@class IPAddress;

@interface IPViewController : UITableViewController <UIAlertViewDelegate>
{
  /// The IP Address view is displaying
  IPAddress* _ipAddress;
  /// The array of static cells that will dynamically update
  NSArray* _updateableCells;
}
@end
