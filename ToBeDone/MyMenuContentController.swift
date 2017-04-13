
import UIKit

class MyMenuContentController: UITableViewController, CariocaMenuDataSource {
    
    var iconNames = Array<String>()
    var menuNames = Array<String>()
    weak var cariocaMenu:CariocaMenu?
    var cellTypeIdentifier = "cellLeft"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.scrollsToTop = false
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
       iconNames.append("intro")
        iconNames.append("inbox")
        iconNames.append("today")
        iconNames.append("scheduled")
        iconNames.append("logbook")
        iconNames.append("trash")
        iconNames.append("setting")
        
        
        menuNames.append("intro")
        menuNames.append("Inbox")
        menuNames.append("Today")
        menuNames.append("Schuduled")
        menuNames.append("Log book")
        menuNames.append("Trash")
         menuNames.append("setting")
        
        
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTypeIdentifier, for: indexPath) as! MyMenuTableViewCell
        //set the title in the cell
        cell.titleLabel.text = menuNames[(indexPath as NSIndexPath).row]
        
        if (indexPath == cariocaMenu?.selectedIndexPath){
//            CariocaMenu.Log("cellForRow : selected")
            cell.applyStyleSelected()
        }
        else{
//            CariocaMenu.Log("cellForRow : normal")
            cell.applyStyleNormal()
        }
        
        cell.iconImageView.image = UIImage(named: "\(iconNames[(indexPath as NSIndexPath).row])_menu")!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
//MARK: - Cell styles and selection/preselection
    
    func unselectRowAtIndexPath(_ indexPath: IndexPath) -> Void {
//        CariocaMenu.Log("unselectRowAtIndexPath \(indexPath.row)")
        if (indexPath == cariocaMenu?.selectedIndexPath){
            getCellFor(indexPath).applyStyleSelected()
        }else {
            getCellFor(indexPath).applyStyleNormal()
        }
    }
    
    func preselectRowAtIndexPath(_ indexPath: IndexPath) -> Void {
//        CariocaMenu.Log("preselectRowAtIndexPath \(indexPath.row)")
        getCellFor(indexPath).applyStyleHighlighted()
    }
    
    func setSelectedIndexPath(_ indexPath: IndexPath) -> Void {
//        CariocaMenu.Log("setSelectedIndexPath \(indexPath.row)")
        getCellFor(indexPath).applyStyleSelected()
    }
    
    //Called when the user releases the gesture on a menu item
    func selectRowAtIndexPath(_ indexPath: IndexPath) -> Void {
//        CariocaMenu.Log("selectRowAtIndexPath \(indexPath.row)")
        self.tableView(self.tableView, didSelectRowAt: indexPath)
    }
    
// MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        CariocaMenu.Log("didSelectRowAtIndexPath \(indexPath.row)")
        //Transfer the event to the menu, so that he can manage the selection
        cariocaMenu?.didSelectRowAtIndexPath(indexPath, fromContentController:true)
    }
    
    // MARK: - Get the Cell
    
    fileprivate func getCellFor(_ indexPath:IndexPath)->MyMenuTableViewCell {
        return self.tableView.cellForRow(at: indexPath) as! MyMenuTableViewCell
    }
    
    // MARK: - Data source protocol
    
    func getMenuView()->UIView{        
        return self.view
    }
    
    func heightByMenuItem()->CGFloat {
        return self.tableView(self.tableView, heightForRowAt: IndexPath(item: 0, section: 0))
    }
    
    func numberOfMenuItems()->Int {
        return self.tableView(self.tableView, numberOfRowsInSection: 0)
    }
    
    func iconForRowAtIndexPath(_ indexPath:IndexPath)->UIImage {
      //  return UIImage(named: "\(iconNames[(indexPath as NSIndexPath).row])_indicator.png")!
        return UIImage(named: "\(iconNames[(indexPath as NSIndexPath).row])_menu")!

    }
    
    func setCellIdentifierForEdge(_ identifier:String)->Void {
        cellTypeIdentifier = identifier
        self.tableView.reloadData()
    }
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
