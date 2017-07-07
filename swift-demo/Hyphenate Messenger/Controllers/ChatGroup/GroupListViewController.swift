
import Foundation
import HyphenateLite
import SlimeRefresh

class GroupListViewController:UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate, EMGroupManagerDelegate, SRRefreshDelegate{
 
    var dataSource:[AnyObject]!
    var slimeView:SRRefreshView!
    var searchBar:EMSearchBar!
    var searchController:EMSearchDisplayController!
    
}
