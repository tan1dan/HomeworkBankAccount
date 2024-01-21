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
        let serialQueue = DispatchSerialQueue(label: "serial")
        
        func deposit(amount: Double){
            serialQueue.sync {
                self.balance += amount
                print("Пополнение счета на сумму: \(amount). Баланс \(self.name): \(self.balance)")
            }
        }
        
        func withdraw(amount: Double){
            serialQueue.sync {
                if self.balance >= amount {
                    self.balance -= amount
                    print("На счету \(self.name) осталось: \(self.balance)")
                }
                else {
                    print("На счету \(self.name) недостаточно средств")
                }
            }
        }
        init(name: String) {
            self.name = name
        }
    }
    
    func transferFromTo(from firstAccount: BankAccount, to secondAccount: BankAccount, amount: Double){
        DispatchQueue.global().sync{
            if firstAccount.balance >= amount {
                firstAccount.balance -= amount
                secondAccount.balance += amount
                print("С баланса \(firstAccount.name) на баланс \(secondAccount.name) было переведено \(amount)")
                print("Баланс \(firstAccount.name): \(firstAccount.balance) ")
                print("Баланс \(secondAccount.name): \(secondAccount.balance)")
            }
            else{ print("Недостаточно средств")}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let account = BankAccount(name: "Vladimir")
        let secondAccount = BankAccount(name: "Julia")
//        Thread.detachNewThread {
//            account.deposit(amount: 100)
//        }
//        Thread.detachNewThread {
//            account.withdraw(amount: 120)
//        }
//        Thread.detachNewThread {
//            account.deposit(amount: 300)
//        }
//        Thread.detachNewThread {
//            account.withdraw(amount: 120)
//        }
//        let thread = Thread{
//            self.transferFromTo(from: account, to: secondAccount, amount: 100)
//        }
//        thread.start()
        DispatchQueue.concurrentPerform(iterations: 10) { i in
            account.deposit(amount: 100)
            account.withdraw(amount: 120)
            account.deposit(amount: 300)
            account.withdraw(amount: 120)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print(account.balance)
        }
//        transferFromTo(from: account, to: secondAccount, amount: 100)
    }


}

