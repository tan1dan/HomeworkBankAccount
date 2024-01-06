//
//  ViewController.swift
//  HomeworkBankAccount
//
//  Created by Иван Знак on 02/01/2024.
//

import UIKit

class ViewController: UIViewController {
    
    class BankAccount {
        var balance: Double = 0
        let name: String
        let lock = NSRecursiveLock()
        
        func deposit(amount: Double){
            lock.lock()
            defer { lock.unlock() }
            balance += amount
            print("Пополнение счета на сумму: \(amount). Баланс \(name): \(balance)")
        }
        
        func withdraw(amount: Double){
            lock.lock()
            defer { lock.unlock() }
            
            if balance >= amount {
                balance -= amount
                print("На счету \(name) осталось: \(balance)")
            }
            else {
                print("На счету \(name) недостаточно средств")
            }
        }
        init(name: String) {
            self.name = name
        }
    }
    
    func transferFromTo(from firstAccount: BankAccount, to secondAccount: BankAccount, amount: Double){
        if firstAccount.balance >= amount {
            firstAccount.lock.lock()
            secondAccount.lock.lock()
            defer {
                firstAccount.lock.unlock()
                secondAccount.lock.unlock()
            }
            firstAccount.balance -= amount
            secondAccount.balance += amount
            print("С баланса \(firstAccount.name) на баланс \(secondAccount.name) было переведено \(amount)")
            print("Баланс \(firstAccount.name): \(firstAccount.balance) ")
            print("Баланс \(secondAccount.name): \(secondAccount.balance)")
        }
        else{ print("Недостаточно средств")}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let account = BankAccount(name: "Vladimir")
        let secondAccount = BankAccount(name: "Julia")
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
        let thread = Thread{
            self.transferFromTo(from: account, to: secondAccount, amount: 100)
        }
        thread.start()
    }


}

