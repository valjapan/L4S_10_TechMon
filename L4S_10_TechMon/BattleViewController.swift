//
//  BattleViewController.swift
//  L4S_10_TechMon
//
//  Created by 鍋島 由輝 on 2019/02/11.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {

    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var enemyNameLabel: UILabel!
    @IBOutlet weak var enemyHPLabel: UILabel!
    @IBOutlet weak var enemyMPLabel: UILabel!
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerHPLabel: UILabel!
    @IBOutlet weak var playerMPLabel: UILabel!
    @IBOutlet weak var playerTPLabel: UILabel!
    let techMonManager = TechMonManager.shared
    
    //    var playerHP = 100
    //    var playerMP = 0
    //    var enemyHP = 200
    //    var enemyMP = 0
    
    var player: Character!
    var enemy: Character!
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //キャラクターの読み込み
        player = techMonManager.player
        enemy = techMonManager.enemy

        //プレイヤーのステータスを反映
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(player.currentHP) / 100"
        playerMPLabel.text = "\(player.currentMP) / 20"

        //的のステータスを反映
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemy.currentHP) / 200"
        enemyMPLabel.text = "\(enemy.currentMP) / 35"

        //ゲームスタート
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)

        gameTimer.fire()
    }

    //ステータスの反映
    func updateUI(){
        //プレイヤーのステータスを反映
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP)"
        
        
        //敵のステータスを反映
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
        
    }
    
    //勝敗判定をする
    func judgeBattle(){
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        } else if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
        //TODO techMonManegerってどこで作ったの

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }

    //0.1秒ごとにゲームの状態を更新する
    @objc func updateGame() {
        //プレイヤーのステータスを更新
        player.currentMP += 1
        if player.currentMP > 20 {
            
            isPlayerAttackAvailable = true
            
            player.currentMP = 20
            
        }else {
            
            isPlayerAttackAvailable = false
            
        }
        
        enemy.currentMP += 1
        
        if enemy.currentMP > 35 {
            
            enemyAttack()
            enemy.currentMP = 0
            
        }
        
        updateUI()
        
    }

    //敵の攻撃

    func enemyAttack() {

        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= 20
        
        playerHPLabel.text = "\(player.currentHP) / 100"
        
        if player.currentHP <= 0 {
            
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
            
        }
        
    }

    //勝敗が決定した時の処理
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {

        techMonManager.vanishAnimation(imageView: vanishImageView)
        
        techMonManager.stopBGM()
        
        gameTimer.invalidate()
        
        isPlayerAttackAvailable = false
        
        var finishMessage = ""
        
        if isPlayerWin {
            
            techMonManager.playSE(fileName: "SE_fanfare")
            
            finishMessage = "勇者の勝利！！"
            
        }else {
            
            techMonManager.playSE(fileName: "SE_gameover")
            
            finishMessage = "勇者の敗北..."
            
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func judgeButtle() {
        
        if player.currentHP <= 0 {
            
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
            
        }else if enemy.currentHP <= 0 {
            
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            
        }
    }
    

    @IBAction func attackAction() {
        //攻撃できるのはMPが溜まっている時だけ
        if isPlayerAttackAvailable {
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            
            techMonManager.playSE(fileName: "SE_attack")
            
            enemy.currentHP -= player.attackPoint
            
            player.currentTP += 10
            
            if player.currentTP >= player.maxTP {
                
                player.currentTP = player.maxTP
            }
            
            player.currentMP = 0
            
            judgeBattle()
            
        }
    }
    
    
    @IBAction func tameruAction() {
        
        if isPlayerAttackAvailable {
            
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            
            if player.currentTP > player.maxTP {
                
                player.currentTP = player.maxTP
                
            }
            
            player.currentMP = 0
            
        }
        
    }
    
    @IBAction func fireAction() {
        
        if player.currentTP > 40, isPlayerAttackAvailable {
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= 100
            
            player.currentTP -= 40
            
            if player.currentTP < 0 {
                
                player.currentTP = 0
                
            }
            
            player.currentMP = 0
            
            judgeBattle()
            
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

}
