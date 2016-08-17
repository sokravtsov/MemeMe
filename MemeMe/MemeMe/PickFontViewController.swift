//
//  PickFontViewController.swift
//  MemeMe
//
//  Created by Sergey Kravtsov on 15.07.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit
protocol PickFontProtocol: class {
    func updateFont(newFontValue:String)
}



class PickFontViewController: UITableViewController   {
    
    
    var m_currentFont: String?
    var m_newFont: String?
    var globalFontValues = ["Impact","Verdana","MarkerFelt-Thin","Papyrus","Futura-Medium"]
    var checkRowIndex: NSIndexPath?
    weak var delegate: PickFontProtocol?
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return globalFontValues.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("FontPickerCell", forIndexPath: indexPath)
        
        // Set the text of the cell
        cell.textLabel?.text = globalFontValues[indexPath.row]
        
        // Set the font of the cell to show the user what the font will look like
        cell.textLabel?.font = UIFont(name: globalFontValues[indexPath.row], size: 20)
        
        // Check to see what the current font was set to and mark it appropriatley
        if m_currentFont == globalFontValues[indexPath.row]
        {
            cell.accessoryType = .Checkmark
            
            // Mark which row has been checked
            checkRowIndex = indexPath
        }
        else
        {
            cell.accessoryType = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = tableView.cellForRowAtIndexPath(indexPath)
        {
            // If the cell is not the currently selected cell, then check it, change the global font and dimiss the view controller
            if cell.accessoryType == .None
            {
                cell.accessoryType = .Checkmark
                tableView.deselectRowAtIndexPath(checkRowIndex!, animated: true)
                if let priorCheckedCell = tableView.cellForRowAtIndexPath(checkRowIndex!)
                {
                    priorCheckedCell.accessoryType = .None
                }
                checkRowIndex = indexPath
                m_newFont = globalFontValues[indexPath.row]
                
                delegate?.updateFont(m_newFont!)
                dismissViewControllerAnimated(true, completion: nil)
            }
                // Otherwise just keep the current font and dimiss the view controller.
            else
            {
                delegate?.updateFont(m_currentFont!)
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    // Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
