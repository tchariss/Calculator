//
//  ViewController.swift
//  Calculator
//
//  Created by Виктория Шеховцова on 06.11.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayResultLabel: UILabel!
    var stillTyping = false // Первое или следующее число "Все еще печатаю"
    var firstOperand: Double = 0 // Первый операнд
    var secondOperand: Double = 0 // Второй операнд
    var operationSign: String = "" // Знак оператора / кнопки
    var dotIsPlaced = false // Точка размещена
    
    var currentInput: Double {
        get { // получить
            return Double(displayResultLabel.text!)!
        }
        
        set { // установить
            let value = "\(newValue)" // сохраняем newValue
            // Разделить запись 25.0
            let valueArray = value.components(separatedBy: ".")
            // Если правая часть ноль, запишем без неё значение
            if valueArray[1] == "0" {
                displayResultLabel.text = "\(valueArray[0])"
            } else {
                displayResultLabel.text = "\(newValue)"
            }
            
            stillTyping = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.darkContent
    }
    
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        // sender - указатель
        let number = sender.titleLabel?.text
        
        if number != nil {
            if stillTyping {
                // stillTyping == true
                // Добавляем текущую цифру на наш экран
                if displayResultLabel.text!.count < 20 {
                    displayResultLabel.text = displayResultLabel.text! + number!
                }
            }
            else {
                // Содержимое label меняем на number
                displayResultLabel.text = number
                stillTyping = true
            }
        }
    }

    
    @IBAction func twoOperandsSignPressed(_ sender: UIButton) {
        // Какое - то действие между (1) и (2) операндом
        
        if let checkOperator = sender.titleLabel?.text {
            operationSign = checkOperator
//            print(" My operationSign - \(operationSign)")
        }
        firstOperand = currentInput
        stillTyping = false
        dotIsPlaced = false
        
    }
    
    func operateWithTwoOperands(operation: (Double, Double) -> Double) {
        currentInput = operation(firstOperand, secondOperand)
        stillTyping = false // Нельзя добавлять цифры, будет писать с новой строки
//        return currentInput
    }
    
    @IBAction func equalitySignPressed(_ sender: UIButton) {

        if stillTyping {
            secondOperand = currentInput
        }
        
        dotIsPlaced = false
        
        switch operationSign {
        case "+" :
// $0 - это первый параметр, переданный в закрытие; $1 - это второй параметр
            operateWithTwoOperands {($0) + ($1)} // функция принимает 2 аргумента и выполняет действие
        case "-" :
            operateWithTwoOperands {($0) - ($1)}
        case "×" :
            operateWithTwoOperands {($0) * ($1)}
        case "÷" :
            operateWithTwoOperands {($0) / ($1)}
        default: break
        }
    }
    
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        displayResultLabel.text = "0"
        stillTyping = false // Нельзя добавлять цифры, будет писать с новой строки
        operationSign = ""
        dotIsPlaced = false
    }
    
    @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
    // Меняет на противоположный знак
        currentInput = -currentInput
    }
    
    @IBAction func percentageButtonPressed(_ sender: UIButton) {
        //  Остаток от деления
        if firstOperand == 0 {
            currentInput = currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput / 100
        }
        
    }
    
    @IBAction func squareRootButtonPressed(_ sender: UIButton) {
       // Квадратный корень
        currentInput = sqrt(currentInput)
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        // Дробная и целая часть (1 раз dot)
        if stillTyping && !dotIsPlaced {
            displayResultLabel.text = displayResultLabel.text! + "."
            dotIsPlaced = true
        }
        else if !stillTyping && !dotIsPlaced {
            displayResultLabel.text = "0."
            stillTyping = true
            dotIsPlaced = true
        }
    }
}

