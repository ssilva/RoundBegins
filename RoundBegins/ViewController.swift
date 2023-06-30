//
//  ViewController.swift
//  RoundBegins
//
//  Created by Saulo Silva on 2023-6-28.
//

import UIKit

class ViewController: UIViewController {

    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.allowsSelection = true
        table.isUserInteractionEnabled = false
        
        return table
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        button.backgroundColor = .systemGreen
        button.setTitle("Next step", for: .normal)
        button.setTitleColor(.black, for: .normal)

        return button
    }()
    
    private let darkBrown = UIColor.init(
        _colorLiteralRed: 82/255,
        green: 50/255,
        blue: 29/255,
        alpha: 1)
    
    private let darkRed = UIColor.init(
        _colorLiteralRed: 105/255,
        green: 17/255,
        blue: 20/255,
        alpha: 1)
    
    var steps = [Step]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        
        initSteps()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.dataSource = self
        table.frame = CGRect(x: view.bounds.minX,
                             y: view.bounds.minY,
                             width: view.bounds.width,
                             height: view.bounds.height - 60)
        
        var currentRow = 0
        if UserDefaults().bool(forKey: "wasInit") {
            currentRow = UserDefaults().integer(forKey: "currentRow")
        } else {
            UserDefaults().set(true, forKey: "wasInit")
            UserDefaults().set(currentRow, forKey: "currentRow")
        }
        
        table.selectRow(at: IndexPath.init(row: currentRow, section: 0), animated: true, scrollPosition: .middle)
        
        view.addSubview(table)
        
        button.frame = CGRect(x: view.bounds.minX,
                              y: view.bounds.maxY - 60,
                              width: view.bounds.width,
                              height: 50)
        view.addSubview(button)
    }
    
    @objc private func didTapNext() {
        guard let indexPath = table.indexPathForSelectedRow else {
            return
        }
        
        let rowsInSection = table.numberOfRows(inSection: indexPath.section)
        let newRow = indexPath.row + 1 > rowsInSection - 1 ? 0 : indexPath.row + 1
        let newIndexPath = IndexPath(row: newRow, section: indexPath.section)
        
        UserDefaults().set(newRow, forKey: "currentRow")
        
        table.selectRow(at: newIndexPath, animated: true, scrollPosition: .middle)
    }
    
    private func initSteps() {
        let actionWindow = Step(text: "ACTION WINDOW", type: .ACTION_WINDOW)
        steps.append(Step(text: "RESOURCE PHASE", type: .PHASE))
        steps.append(Step(text: "Gain resources"))
        steps.append(Step(text: "Draw cards"))
        steps.append(actionWindow)
        
        steps.append(Step(text: "PLANNING PHASE", type: .PHASE))
        steps.append(Step(text: "Special action window"))
        steps.append(Step(text: "Next player becomes active"))
        
        steps.append(Step(text: "QUEST PHASE", type: .PHASE))
        steps.append(actionWindow)
        steps.append(Step(text: "Commit characters"))
        steps.append(actionWindow)
        steps.append(Step(text: "Staging"))
        steps.append(actionWindow)
        steps.append(Step(text: "Quest resolution"))
        steps.append(actionWindow)
        
        steps.append(Step(text: "TRAVEL PHASE", type: .PHASE))
        steps.append(Step(text: "Travel opportunity"))
        steps.append(actionWindow)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        steps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentStep = steps[indexPath.row]

        cell.textLabel?.text = currentStep.text
        cell.textLabel?.textAlignment = .center
        let colorView = UIView()
        colorView.backgroundColor = .systemBrown
        cell.selectedBackgroundView = colorView
        
        switch currentStep.type {
        case .NORMAL:
            cell.backgroundColor = darkBrown
            cell.textLabel?.textColor = .white
        case .PHASE:
            cell.backgroundColor = .white
            cell.textLabel?.textColor = darkRed
            cell.textLabel?.font = .boldSystemFont(ofSize: 14)
        case .ACTION_WINDOW:
            cell.backgroundColor = darkRed
            cell.textLabel?.textColor = .white
        }

        return cell
    }
}

//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.bottom)
//    }
    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell  = tableView.cellForRow(at: indexPath)
//        cell?.textLabel?.highlightedTextColor = UIColor.init(
//            _colorLiteralRed: 243/255,
//            green: 222/255,
//            blue: 179/255,
//            alpha: 1)
//    }
//}
