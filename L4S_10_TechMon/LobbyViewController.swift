//
//  LobbyViewController.swift
//  L4S_10_TechMon
//
//  Created by 鍋島 由輝 on 2019/02/11.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel: UILabel!

    let techMonManeger = TechMonManager.shared

    var stamina: Int = 100
    var staminaTimer: Timer!

    //アプリが起動した時一度だけ呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()

        // UIの設定
        nameLabel.text = "勇者"
        staminaLabel.text = " \(stamina) / 100"

        // タイマーの設定
        staminaTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateStaminaValue), userInfo: nil, repeats: true)

        staminaTimer.fire()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManeger.playBGM(fileName: "lobby")
    }

    // ロビー画面が見えなくなるときき呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManeger.stopBGM()
    }

    @IBAction func toBattle() {
        //スタミナ50以上あればスタミナ50を消費しいて戦闘画面へ
        if stamina >= 50 {
            stamina -= 50
            staminaLabel.text = "\(stamina) / 100"
            performSegue(withIdentifier: "toBattle", sender: nil)

        } else {
            let aleat = UIAlertController (
                title: "バトルに行けません",
                message: "スタミナを貯めてください",
                preferredStyle: .alert)

            aleat.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(aleat, animated: true, completion: nil)
        }
    }

    //スタミナ回復

    @objc func updateStaminaValue() {
        if stamina < 100 {
            stamina += 1
            staminaLabel.text = "\(stamina) / 100"
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
