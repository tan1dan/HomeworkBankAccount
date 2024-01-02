//
//  ViewController.swift
//  HomeworkBankAccount
//
//  Created by Иван Знак on 02/01/2024.
//

import UIKit

class ViewController: UIViewController {
    
    class BankAccount {
        private var balance: Double = 0
        private let lock = NSRecursiveLock()
        
        func deposit(amount: Double){
            lock.lock()
            defer { lock.unlock() }
            balance += amount
            print("Пополнение счета на сумму: \(amount). Ваш баланс: \(balance)")
        }
        
        func withdraw(amount: Double){
            lock.lock()
            defer { lock.unlock() }
            
            if balance >= amount {
                balance -= amount
                print("На вашем счету осталось: \(balance)")
            }
            else {
                print("На счету недостаточно средств")
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let account = BankAccount()
        Thread.detachNewThread {
            account.deposit(amount: 100)
        }
        Thread.detachNewThread {
            account.withdraw(amount: 120)
        }
        Thread.detachNewThread {
            account.deposit(amount: 300)
        }
        Thread.detachNewThread {
            account.withdraw(amount: 120)
        }
    }


}

