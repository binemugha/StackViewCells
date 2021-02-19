//
//  OrderDetailsController.swift
//  DocsRchOut
//
//  Created by Nwankwo Kingsley on 6/9/20.
//  Copyright © 2020 SE Advocacy. All rights reserved.
//
import SCLAlertView
import UIKit
import SVProgressHUD

class OrderDetailsController: UIViewController {
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var itemStack: UIStackView!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var itemsCount: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var addressBox: UIView!
    @IBOutlet weak var nameAd: UILabel!
    @IBOutlet weak var addresAd: UILabel!
    @IBOutlet weak var cityAd: UILabel!
    @IBOutlet weak var stateAd: UILabel!
    @IBOutlet weak var countryAd: UILabel!
    @IBOutlet weak var numAd: UILabel!
    @IBOutlet weak var deliveryInstructionsBox: UIView!
    @IBOutlet weak var deliveryInstructions: UITextField!
    @IBOutlet weak var estimatedDateBox: UIView!
    @IBOutlet weak var estimatedDate: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var subTotalBox: UIView!
    @IBOutlet weak var deliveryFeeBox: UIView!
    @IBOutlet weak var discountBox: UIView!
    @IBOutlet weak var totalBox: UIView!
    @IBOutlet weak var scrollDetails: UIScrollView!
    
    var order: Order!
    var oId: Int!
    var isFromNotification = false
    
    var tot = 0.0
    
    var isCheckout = false
    var refreshControl = UIRefreshControl()

    var iamPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        
        cornerView.addCornerRaduis(cornerRadius: 10)
        status.addCornerRaduis(cornerRadius: 10)
        shadow.addShadow(color: UIColor.black, alpha: 0.2, radius: 2)
        
        
        //orderId.text = TimeUtils().convertTimeWithString(format: "yyyy-MM-dd'T'HH:mm:SS", time: String(order.created_at.split(separator: ".")[0]), returnStr: "dd-MM-yyyy", useDroUserTimezone: true)
        
        let width = CGFloat(0.3)
        let color = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
        
        addressBox.addRoundCorner(corner: [ .layerMaxXMinYCorner, .layerMinXMinYCorner], width: width, color: color, radius: 10)
        
        deliveryInstructionsBox.addRoundCorner(corner: [], width: width, color: color, radius: 0)
        estimatedDateBox.addRoundCorner(corner: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], width: width, color: color, radius: 10)
        
        totalBox.addRoundCorner(corner: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], width: width, color: color, radius: 10)
        subTotalBox.addRoundCorner(corner: [ .layerMaxXMinYCorner, .layerMinXMinYCorner], width: width, color: color, radius: 10)
        
        deliveryFeeBox.addBorder(width: width, color: color)
        discountBox.addBorder(width: width, color: color)
        
        if(oId == nil){
            oId = order.id
            setupdisplay()
        }else{
            loadOrder()
        }
        
    
        
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollDetails.alwaysBounceVertical = true
        scrollDetails.refreshControl = refreshControl
        
        let trackTap = UITapGestureRecognizer(target: self, action: #selector(trackTapped(gesture:)))
        cornerView.addGestureRecognizer(trackTap)
        cornerView.isUserInteractionEnabled = true
    }
    
    
    @objc func trackTapped(gesture: UIGestureRecognizer) {
           // if the tapped view is a UIImageView then set it to imageview
           print("Track Order")
           let trackController = UIStoryboard(name: StoryBoards.Orders, bundle: nil).instantiateViewController(withIdentifier: "TrackOrderController") as! TrackOrderController
           trackController.modalPresentationStyle = .overCurrentContext
        trackController.orderID = order.id
        trackController.orderOn = orderId.text!
        trackController.orderIDString = orderID.text!
        navigationController?.pushViewController(trackController, animated: true)
           
    }
    
    @objc func refresh()
    {
        OrderApi().getOrder(id: order.id) { (or, status) in
            if(status == .success && or != nil){
                self.order = or!
                self.setupdisplay()
            }
            self.refreshControl.endRefreshing()
        }
        
    }
    
    func loadOrder()
    {
        self.view.isHidden = true
        SVProgressHUD.show(withStatus: "Loading order")
        OrderApi().getOrder(id: oId) { (or, status) in
            self.view.isHidden = false
            SVProgressHUD.dismiss()
            if(status == .success && or != nil){
                self.order = or!
                self.setupdisplay()
            }else{
                SCLAlertView().showError("Error", subTitle: "Could not load order, Try again later")
            }
        }
        
    }
    
    @objc func trackOrder(gesture: UIGestureRecognizer){
        SCLAlertView().showInfo("", subTitle: "Coming Soon")
    }
    
    func setStatus(stats: String, display_status: String){
        switch (stats) {
        case "pending":
            status.backgroundColor = DROColors.grey
            break;
        case "processing":
            status.backgroundColor = .black
            break;
        case "awaiting_pickup":
            status.backgroundColor = UIColor(named: "ColorStatusBlue")
            break;
        case "picked_up":
            status.backgroundColor = UIColor(named: "ColorStatusBlue")
            break;
        case "pharmacy_cancelled":
            status.backgroundColor = .red
            break;
        case "declined":
            status.backgroundColor = .red
            break;
        case "delivered":
            status.backgroundColor = DROColors.goldBrown
            break;
        case "out_to_depot":
            status.backgroundColor = UIColor(named: "ColorStatusBlue")
            break;
        case "at_depot":
            status.backgroundColor = UIColor(named: "ColorStatusBlue")
            break;
        case "accepted":
            status.backgroundColor = DROColors.turquoise
            break;
        case "confirmed":
            status.backgroundColor = DROColors.turquoise
            break;
        case "out_for_delivery":
            status.backgroundColor = DROColors.purple
            break;
        default:
            
            break;
        }
        status.text = display_status
    }
    
    func addCoupon(){
        if(order.coupon != nil){
            var off = 0.0
            if(order.coupon!.discountType == "percentage"){
                //proResultTxt.text = "\(order.coupon.amount)% off"
                off = tot - (Double((Double(order.coupon!.amount)/100.0)) * tot)
               }else{
                //proResultTxt.text = "\(Double(order.coupon.amount).toCurrencyNoKobo()) off"
                off = tot - (Double(order.coupon!.amount))
               }
               if(off < 0.0){
                   total.text = 0.0.toCurrencyNoKobo()
                   discount.text = "- "+tot.toCurrencyNoKobo()
                   //discounted = tot
               }else{
                   total.text = off.toCurrencyNoKobo()
                   discount.text = "- "+(tot - off).toCurrencyNoKobo()
                   //discounted = tot - off
               }
               
           }
    }
    
    func setupdisplay(){
        orderID.text = order.order_id
        setStatus(stats: order.status, display_status: order.get_status_display)
        
        var delFee = 0.0
        
        if(order.delivery_type != nil){
            delFee = Double(order.delivery_type!.fee)!
        }else{
            delFee = Double(order.order_items[0].delivery_fee)!
        }
        
        tot = 0.0
        for i in order.order_items{
            tot += (Double(i.price)! * Double(i.quantity))
        }
        subTotal.text = tot.toCurrencyNoKobo()
        tot += delFee
        
        total.text = tot.toCurrencyNoKobo()
        deliveryFee.text = delFee.toCurrencyNoKobo()
        discount.text = "- \(0.0.toCurrencyNoKobo())"
   
        let date = TimeUtils().getDate(fromString: String(order.created_at.split(separator: ".")[0]), format: "yyyy-MM-dd'T'HH:mm:SS")!
        let now = Calendar.current.dateComponents(in: .current, from: date)
        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + (order.delivery_type == nil ? 1 : order.delivery_type!.delivery_time))
        let today = DateComponents(year: now.year, month: now.month, day: now.day!)
        let dateTomorrow = Calendar.current.date(from: tomorrow)!
        let createdDate = Calendar.current.date(from: today)
        
        orderId.text = "\(TimeUtils().getCurrentDateWithStringFormat(date: createdDate!)) - \(TimeUtils().getTime(withFormat: "h:mma", time: date))"
        
        estimatedDate.text = (order.delivery_type != nil && !order.delivery_type!.time_restrictions) ?  "On or before \(TimeUtils().getCurrentDateWithStringFormat(date: dateTomorrow))" : (TimeUtils().getCurrentDateWithStringFormat(date: dateTomorrow))
        
        itemsCount.text = order.order_items.count > 1 ? "Items (\(order.order_items.count))" : "Item (\(order.order_items.count))"
        addCoupon()
        itemStack.removeAllSubviews()
        for item in order.order_items{
            let itemView: OrderItems = Bundle.main.loadNibNamed("OrderItems", owner: self, options: nil)?.first as! OrderItems
            itemView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64.0).isActive = true
            itemView.widthAnchor.constraint(lessThanOrEqualToConstant: itemStack.bounds.width).isActive = true
            var strength = ""
            if(item.product.strength != nil){
                if(item.product.dosage_route.isEmpty){
                    strength = "\(item.product.strength!)\(item.product.strength_measurement_unit)"
                }else{
                    strength = "\(item.product.dosage_route.capitalized) - \(item.product.strength!)\(item.product.strength_measurement_unit)"
                }
            }else{
                strength = item.product.dosage_route.capitalized
            }
            
            if(item.fulfillment_status == "accepted"){
                itemView.fullfilmentImage.image = UIImage(named: "tick")
            }else if(item.fulfillment_status == "declined" || item.fulfillment_status == "pharmacy_cancelled" ){
                itemView.fullfilmentImage.image = UIImage(named: "close-1")
            }else{
                itemView.fullfilmentImage.isHidden = true
                itemView.endLine.constant = 8
            }
            
            print(item.fulfillment_status)
            
            itemView.bgView.addCornerRaduis(cornerRadius: 10)
            itemView.firstTxt.text = strength
            itemView.secondTxt.text = "Quantity: \(item.quantity)"
            itemView.imageBg.addCornerRaduis(cornerRadius: 4)
            itemView.itemImage.kf.indicatorType = .activity
            itemView.pricetxt.text = (Double(item.price)!*Double(item.quantity)).toCurrencyNoKobo()
            let url = URL(string: item.photo)
            itemView.itemImage.kf.setImage(with: url)
            itemView.mainTxt.text = item.product.name.capitalized
            itemStack.addArrangedSubview(itemView)
        }
        
        let ad = order.delivery_address
        stateAd.text = ad.state
        nameAd.text = "\(ad.first_name) \(ad.last_name)"
        numAd.text = ad.primary_phone
        cityAd.text = ad.city
        countryAd.text = ad.country
        addresAd.text = ad.address
        deliveryInstructions.text = order.delivery_instructions//ad.delivery_instructions
        
        let trackorder = UITapGestureRecognizer(target: self, action: #selector(trackOrder(gesture:)))
        // add it to the image view;
        cornerView.addGestureRecognizer(trackorder)
        // make sure imageView can be interacted with by user
        cornerView.isUserInteractionEnabled = true
    }
    
    @IBAction func back(_ sender: Any) {
        if(isFromNotification){
            goHome()
        }else if(isCheckout){
            dismiss(animated: true){
                NotificationCenter.default.post(name: .checkoutComplete, object: nil)
            }
        }else{
            print("is Ben presented ", isBeingPresented)
            if iamPresented {
                self.dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    static func instance() ->  OrderDetailsController{
        return UIStoryboard(name: StoryBoards.Orders, bundle: nil).instantiateViewController(withIdentifier: OrderDetailsController.identifier) as! OrderDetailsController
    }

}
