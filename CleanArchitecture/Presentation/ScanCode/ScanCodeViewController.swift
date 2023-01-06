//
//  ScanCodeViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 28.12.2022.
//

import UIKit
import AVFoundation
import InputMask

class ScanCodeViewController: UIViewController, MaskedTextFieldDelegateListener {
    
    var viewModel: ScanCodeViewModelProtocol?
    var listener: MaskedTextFieldDelegate? = MaskedTextFieldDelegate()
    private var session: AVCaptureSession?
    private var recipeId: String?
   
    private var backgroundGrayView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.scanTitleLabel
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.scanSubTitleLabel
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private var recipeIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.recipeIdPlaceholder
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 15
        textField.textColor = .black
        textField.textAlignment = .center
        return textField
    }()
    
    private var scanView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        if requestMediaPermissions() {
            setupCaptureSession()
        }
        listener!.affinityCalculationStrategy = .prefix
        listener!.affineFormats = [ "[000] [000]" ]
        listener!.listener = self
        recipeIdTextField.delegate = listener
        keyboardNotifications()
    }

    private func setupView() {
        view.addSubview(backgroundGrayView)
        backgroundGrayView.addSubview(titleLabel)
        backgroundGrayView.addSubview(subTitleLabel)
        backgroundGrayView.addSubview(lineView)
        backgroundGrayView.addSubview(titleLabel)
        backgroundGrayView.addSubview(recipeIdTextField)
        backgroundGrayView.addSubview(scanView)
        titleLabel.textAlignment = .center
        navigationController?.setStatusBar(backgroundColor: .systemGray6)
        navigationController?.navigationBar.backgroundColor = .systemGray6
    }
   
    private func setupConstraints() {
        backgroundGrayView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        recipeIdTextField.translatesAutoresizingMaskIntoConstraints = false
        scanView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundGrayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backgroundGrayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: backgroundGrayView.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: backgroundGrayView.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.centerXAnchor.constraint(equalTo: backgroundGrayView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subTitleLabel.centerXAnchor.constraint(equalTo: backgroundGrayView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            lineView.centerXAnchor.constraint(equalTo: backgroundGrayView.centerXAnchor),
            lineView.centerYAnchor.constraint(equalTo: backgroundGrayView.centerYAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 4),
            lineView.widthAnchor.constraint(equalTo: backgroundGrayView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            scanView.centerXAnchor.constraint(equalTo: backgroundGrayView.centerXAnchor),
            scanView.centerYAnchor.constraint(equalTo: backgroundGrayView.centerYAnchor),
            scanView.heightAnchor.constraint(equalToConstant: 252),
            scanView.widthAnchor.constraint(equalToConstant: 252)
        ])
        NSLayoutConstraint.activate([
            recipeIdTextField.leadingAnchor.constraint(equalTo: backgroundGrayView.leadingAnchor, constant: 16),
            recipeIdTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            backgroundGrayView.trailingAnchor.constraint(equalTo: recipeIdTextField.trailingAnchor, constant: 16),
            recipeIdTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
        self.view.layoutIfNeeded()
    }
}
// MARK: - KeyBoard
extension ScanCodeViewController {
    
    private func keyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
               view.frame.origin.y -= keyboardSize.height
                lineView.isHidden = true
           }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            lineView.isHidden = false
        }
    }
}
    
// MARK: - UITextFieldDelegate
extension ScanCodeViewController: UITextFieldDelegate {
    
    open func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        recipeId = value
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let recipeId = recipeId,
              let idNumber = Int(recipeId) else {
            textField.resignFirstResponder()
            return
        }
        viewModel?.didSelectItem(at: Int(idNumber))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - ScanCode
extension ScanCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    private func requestMediaPermissions() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: return true
        case .notDetermined:
            var result: Bool = false
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    result = true
                }
            }
            return result
        case .denied:  return false
        case .restricted: return false
        default: return false
        }
    }
    
    private func setupCaptureSession() {
        session = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let session = session
        else { return }
        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            fatalError("Cannot access camera device")
        }
        if session.canAddInput(input) == true {
            session.addInput(input)
        } else {
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) == true {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = scanView.bounds
        scanView.layer.addSublayer(previewLayer)
        previewLayer.videoGravity = .resizeAspectFill
        backgroundGrayView.bringSubviewToFront(lineView)
        DispatchQueue.global().async {
            session.startRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session?.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            viewModel?.didSelectItem(at: Int(stringValue) ?? 0)
        }
    }
}
