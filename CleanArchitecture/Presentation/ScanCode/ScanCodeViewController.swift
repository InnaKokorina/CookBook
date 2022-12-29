//
//  ScanCodeViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 28.12.2022.
//

import UIKit
import AVFoundation

class ScanCodeViewController: UIViewController {
    var viewModel: ScanCodeViewModelProtocol?
    private var session: AVCaptureSession?
   
    private var backgroundGrayView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сканировать"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Наведите камеру на QR-код"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private var manuallyInsertButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.cornerRadius = 15
        button.setTitle("Ввести Id вручную", for: .normal)
        return button
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
    }
    private func setupView() {
        view.addSubview(backgroundGrayView)
        backgroundGrayView.addSubview(titleLabel)
        backgroundGrayView.addSubview(subTitleLabel)
        backgroundGrayView.addSubview(lineView)
        backgroundGrayView.addSubview(titleLabel)
        backgroundGrayView.addSubview(manuallyInsertButton)
        backgroundGrayView.addSubview(scanView)
        titleLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        backgroundGrayView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        manuallyInsertButton.translatesAutoresizingMaskIntoConstraints = false
        scanView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundGrayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backgroundGrayView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
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
            manuallyInsertButton.leadingAnchor.constraint(equalTo: backgroundGrayView.leadingAnchor, constant: 16),
            manuallyInsertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            backgroundGrayView.trailingAnchor.constraint(equalTo: manuallyInsertButton.trailingAnchor, constant: 16),
            manuallyInsertButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        self.view.layoutIfNeeded()
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
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session?.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  var stringValue = readableObject.stringValue else { return }
//            switch scanReason {
//            case .loadClaimItem:
//                self.presenter.loadClaimItem(scanDataMatrixValue: stringValue, docNumber: wayBillNumber)
//            case .unreadabbleCode:
//                self.presenter.checkDataMatrixCode(scanValue: stringValue)
//            case .none:
//                return
//            }
        }
    }
}
