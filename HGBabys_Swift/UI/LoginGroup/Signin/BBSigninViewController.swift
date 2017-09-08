

//
//  BBSigninViewController.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/8/30.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit

class BBSigninViewController: UIViewController {



	let customAn = { () -> HGViewControllerAnimatedTransitioning in
		let cusoman = HGViewControllerAnimatedTransitioning()
//		cusoman.showHostAnimate = true
		return cusoman
	}()

	let animateTime = 0.3

	@IBOutlet weak var alphaView: UIView!
	@IBOutlet weak var wellcomGroupView: UIView!

	@IBOutlet weak var signGroup: UIView!
	@IBOutlet weak var loveLabel: UILabel!


	@IBOutlet weak var textFieldGroupTopLayoutConstraint: NSLayoutConstraint!
	@IBOutlet weak var buttonGroupTopLayoutConstraint: NSLayoutConstraint!

	@IBOutlet weak var provisionViewLayoutConstraint: NSLayoutConstraint!
	@IBOutlet weak var babynameTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		navigationController?.setNavigationbarClear()
		addEndEditingTap()
		configUI()
		checkIfAutoSign()

	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}

	func configUI()  {

		//
		babynameTF.text = BBSignin.currenLogin.babyname
		passwordTF.text = BBSignin.currenLogin.password

		//
		babynameTF.attributedPlaceholder = NSAttributedString(string: "用户名", attributes: [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
		passwordTF.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])


		//
		func createRightButton(image: UIImage? = #imageLiteral(resourceName: "Some/close")) -> UIButton{
			let button = UIButton(type: .custom)
			button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
			button.setImage(image, for: .normal)
			return button
		}

		func setRightView(_ textF: UITextField){
			let rightButton = createRightButton()
			rightButton.addTarget(self, action: #selector(BBSigninViewController.cleartText(_:)), for: .touchUpInside)
			textF.rightView = rightButton
			textF.rightViewMode = .whileEditing
		}
		setRightView(babynameTF)
		setRightView(passwordTF)

		//
		if BBSignin.currenLogin.babyname?.isEmpty == false{
			showTextFeildAnimate(withDuration: 0)
		}

	}
	@objc func cleartText(_ button: UIButton){
		if let tf = button.superview as? UITextField {
			tf.text = nil
		}
	}

	@discardableResult
	func checkIfAutoSign() -> Bool {
		if (BBSignin.currenLogin.babyname?.isEmpty) ?? true || (BBSignin.currenLogin.password?.isEmpty) ?? true || !BBSignin.isSignin{
			return false
		}else{
			requestLogin()
			return true
		}
	}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	// MARK: - IBAction

	@IBAction func babynameTextChangeAction(_ sender: UITextField) {
		BBSignin.currenLogin.babyname = sender.text
	}
	@IBAction func passwordTextChangeAction(_ sender: UITextField) {
		BBSignin.currenLogin.password = sender.text
	}
	@IBAction func sgininButtonAction(_ sender: UIButton) {
		requestLogin()
	}

	@IBAction func showOrHiddenSecretButtonAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		passwordTF.isSecureTextEntry = sender.isSelected
	}
	@IBAction func showSignButtonAction(_ sender: UIButton) {

		showTextFeildAnimate()
	}


	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
		segue.destination.transitioningDelegate = self
	}

}



// MARK: - 登录框动画
extension BBSigninViewController{
	func showTextFeildAnimate(withDuration: TimeInterval = 1.0)  {
		alphaView.isHidden = false
		wellcomGroupView.isHidden = true
		signGroup.isHidden = false
		//
		loveLabel.snp.updateConstraints { (make) in
			make.leading.equalToSuperview().offset(20)
		}
		textFieldGroupTopLayoutConstraint.constant = 0
		buttonGroupTopLayoutConstraint.constant = 20
		provisionViewLayoutConstraint.constant = 20

		UIView.animate(withDuration: withDuration) {
			self.view.layoutIfNeeded()
		}
	}
}
// MARK: - 网络请求
extension BBSigninViewController{

	/// 登录请求
	func requestLogin() {
		if let msg = BBSignin.currenLogin.checkSignupData() {
			toast(msg)
			return
		}
		showLoading()
		HGNetWork.default.request(HTTPType.baseUrl(APIManager.api_baby_login), method: .post, parameters: BBSignin.currenLogin.toParams) { (respose, data, hgerror) in
			self.endLoading()
			if hgerror != nil{
				self.toast(hgerror?.message)
			}else if let data = data as? Dictionary<String, Any> , let userDict = data["data"] as? Dictionary<String, Any> {
				BBSignin.currenLogin.saveSignin()
				BBSignin.saveSignData(userDict )
				AppDelegate.default.switchToTabBarViewController()
			}else {
				self.toast("登录失败")
			}

		}
	}
}


// MARK: - UITextFieldDelegate
extension BBSigninViewController: UITextFieldDelegate{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if textField === babynameTF {
			passwordTF.becomeFirstResponder()
		}else{
			requestLogin()
		}

		return true
	}
}

// MARK: - 自定义过场动画
extension BBSigninViewController: UIViewControllerTransitioningDelegate{
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		customAn.presenting = true
		return customAn

	}
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		customAn.presenting = false
		return customAn
	}
}

