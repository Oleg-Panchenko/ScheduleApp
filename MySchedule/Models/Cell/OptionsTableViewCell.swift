//
//  OptionsTableViewCell.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 12.11.2021.
//

import UIKit
 
class OptionsTableViewCell: UITableViewCell {
     
    let backgroundViewCell: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameCellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repeatSwitch: UISwitch = {
        let repeatSwitch = UISwitch()
        repeatSwitch.isOn = true
        repeatSwitch.isHidden = true
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
        return repeatSwitch
    }()
    
    weak var switchRepeatDelegate: SwitchRepeatProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear
        setConstraints()
        self.selectionStyle = .none
        
        repeatSwitch.addTarget(self, action: #selector(switchChange(paramTarget:)), for: .valueChanged)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellScheduleConfigure(nameArray: [[String]], indexPath: IndexPath, hexColor: String) {
        
        nameCellLabel.text = nameArray[indexPath.section][indexPath.row]
        repeatSwitch.isHidden = (indexPath.section == 4 ? false : true)
        let color = UIColor().colorFromHex(hexColor)
        backgroundViewCell.backgroundColor = (indexPath.section == 3 ? color : .white)
        repeatSwitch.onTintColor = color
    }
    
    func cellTasksConfigure(nameArray: [String], indexPath: IndexPath, hexColor: String) {
        nameCellLabel.text = nameArray[indexPath.section]
        backgroundViewCell.backgroundColor = (indexPath.section == 3 ? UIColor().colorFromHex(hexColor) : .white)
    }
    
    func cellContactsConfigure(nameArray: [String], indexPath: IndexPath, image: UIImage?) {
        nameCellLabel.text = nameArray[indexPath.section]
        if image == nil {
            indexPath.section == 4 ? backgroundViewCell.image = UIImage(systemName: "person.fill.badge.plus") : nil
        } else {
            indexPath.section == 4 ? backgroundViewCell.image = image : nil
            backgroundViewCell.contentMode = .scaleAspectFill
        }
    }
    
    //MARK: - Switch @objc
    @objc func switchChange(paramTarget: UISwitch) {
        
        switchRepeatDelegate?.switchRepeat(value: paramTarget.isOn)
    }
    
    func setConstraints() {
        
       //backgroundViewCell
        self.addSubview(backgroundViewCell)
        NSLayoutConstraint.activate([
            backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
            ])
        
        //nameCellLabel
        
        self.addSubview(nameCellLabel)
        NSLayoutConstraint.activate([
            nameCellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameCellLabel.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor, constant: 15)
            ])
        
        self.contentView.addSubview(repeatSwitch)
        NSLayoutConstraint.activate([
            repeatSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repeatSwitch.trailingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor, constant: -20)
            ])
    }
}
