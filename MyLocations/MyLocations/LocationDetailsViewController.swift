//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Seab on 10/16/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter
}()

class LocationDetailsViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                placemark = location.placemark
            }
        }
    }
    var descriptionText = ""
    var categoryName = "No Category"
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var date = NSDate()
    var image: UIImage?
    var observer: AnyObject!
    let compressionQuality: CGFloat = 0.5
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    @IBAction func done() {
        let hudView = HudView.hudInView(navigationController!.view, animated: true)
        let location: Location
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else {
            hudView.text = "Tagged"
            location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedObjectContext) as! Location
            location.photoID = nil
        }
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID()
            }
            
            if let data = UIImageJPEGRepresentation(image, compressionQuality) {
                do {
                    try data.writeToFile(location.photoPath, options: .DataWritingAtomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalCoreDataError(error)
        }
        
        // delay time in seconds
        afterDelay(0.6) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func categoryPickerDidPickCategoryWithSegue(segue: UIStoryboardSegue) {
        let controller = segue.sourceViewController as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up the appearance of the table view
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
        tableView.indicatorStyle = .White
        
        descriptionTextView.textColor = UIColor.whiteColor()
        descriptionTextView.backgroundColor = UIColor.blackColor()
        
        addPhotoLabel.textColor = UIColor.whiteColor()
        addPhotoLabel.highlightedTextColor = addPhotoLabel.textColor
        addressLabel.textColor = UIColor(white: 1.0, alpha: 0.4)
        addressLabel.highlightedTextColor = addressLabel.textColor

        if let location = locationToEdit {
            title = "Edit Location"
            if location.hasPhoto {
                if let image = location.photoImage {
                    showImage(image)
                }
            }
        }
        listenForBackgroundNotification()
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = stringFromPlacemark(placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = formatDate(date)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationDetailsViewController.hideKeyboard(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destinationViewController as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        var line = ""
        line.addText(placemark.subThoroughfare)
        line.addText(placemark.thoroughfare, withSeparator: " ")
        line.addText(placemark.locality, withSeparator: ", ")
        line.addText(placemark.administrativeArea, withSeparator: ", ")
        line.addText(placemark.postalCode, withSeparator: " ")
        line.addText(placemark.country, withSeparator: ", ")
        return line
    }
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
    func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        
        descriptionTextView.resignFirstResponder()
        
    }
    
    
    // MARK: - UITableViewDelegate
    
    // dictate how tall each cell should be
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        
            // in section 0, row 0 set the height of the cell to 88
        case (0, 0):
            return 88
        // in section 1, any row set the height to 44 if the image is hidden, and 280 otherwise
        case (1, _):
            return imageView.hidden ? 44 : 280
        // in section 2, row 2 set up the height for the address label
        case (2, 2):
            addressLabel.frame.size = CGSize(width: view.bounds.size.width - 115, height: 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 15
            return addressLabel.frame.size.height + 20
            
        default:
            return 44
        }
    }
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            pickPhoto()
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
       cell.backgroundColor = UIColor.blackColor()
        if let textLabel = cell.textLabel {
            textLabel.textColor = UIColor.whiteColor()
            textLabel.highlightedTextColor = textLabel.textColor
        }
        
        if let detailLabel = cell.detailTextLabel {
            detailLabel.textColor = UIColor(white: 1.0, alpha: 0.4)
            detailLabel.highlightedTextColor = detailLabel.textColor
        }
        
        let selectionView = UIView(frame: CGRect.zero)
        selectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        cell.selectedBackgroundView = selectionView
        
        if indexPath.row == 2 {
            let addressLabel = cell.viewWithTag(100) as! UILabel
            addressLabel.textColor = UIColor.whiteColor()
            addressLabel.highlightedTextColor = addressLabel.textColor
        }
    }
    
    func showImage(image: UIImage) {
        imageView.image = image
        imageView.hidden = false
        imageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
        addPhotoLabel.hidden = true
    }
    
    func listenForBackgroundNotification() {
        observer = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil, queue: .mainQueue()) { [weak self] _ in
            if let strongSelf = self {
                if strongSelf.presentedViewController != nil {
                    strongSelf.dismissViewControllerAnimated(false, completion: nil)
                }
                strongSelf.descriptionTextView.resignFirstResponder()
            }
        }
    }
    
    deinit {
        print("*** deinit \(self)")
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
}

extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePhotoWithCamera() {
        let imagePicker = MyImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibray() {
        let imagePicker = MyImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibray()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // add cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // add the take photo action
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: { _  in self.takePhotoWithCamera() })
        alertController.addAction(takePhotoAction)
        
        // add the choose photo from library action
        let chooseFromLibraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: { _ in self.choosePhotoFromLibray() })
        alertController.addAction(chooseFromLibraryAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        if let image = image {
            showImage(image)
        }
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
