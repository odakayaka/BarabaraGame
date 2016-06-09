//
//  GameViewController.swift
//  BarabaraGame
//
//  Created by 尾高文香 on 2016/06/08.
//  Copyright © 2016年 com.odakaayaka. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var imgView1: UIImageView! //上の画像
    @IBOutlet var imgView2: UIImageView! //真ん中の画像
    @IBOutlet var imgView3: UIImageView! //下の画像
    
    @IBOutlet var resultLabel: UILabel! //スコア表示のラベル
    
    var timer : NSTimer! //画像を動かすためのタイマー
    var score: Int = 1000 //スコアの値
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults() //スコアの保存をするための変数
    
    let width : CGFloat = UIScreen.mainScreen().bounds.size.width //画面幅
    var positionX : [CGFloat] = [0.0,0.0,0.0] //画像の位置の配列
    var dx: [CGFloat] = [1.0,0.5, -1.0] //画像の動かす幅の配列
    
    func start(){
        resultLabel.hidden = true //結果ラベルを隠す
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: "up" , userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func up(){
        for i in 0..<3 {
            //端にきたら動かす向きを逆にする
            if positionX[i] > width || positionX[i] < 0{
                dx[i] = dx[i] * (-1)
            }
            positionX[i] = positionX[i] + dx[i] //画像の真ん中をdx分ずらす
        }
        imgView1.center.x = positionX[0]
        imgView2.center.x = positionX[1]
        imgView3.center.x = positionX[2]
    }
    
    @IBAction func stop(){ //ストップボタンを押したとき
        if timer.valid == true{ //もしタイマーが動いていたら
            timer.invalidate() //タイマーを無効にする
            
        }
        
        for i in 0..<3 {
            score = score - abs(Int(width/2 - positionX[i]))*2 //画像のずれた分だけスコアから値をひく
        }
        resultLabel.text = "Score : " + String(score) //結果ラベルにスコアを表示する
        resultLabel.hidden = false //結果ラベルを隠さない
        
        var highScore1: Int = defaults.integerForKey("score1") //score1というキーの値を取得
        var highScore2: Int = defaults.integerForKey("score2")
        var highScore3: Int = defaults.integerForKey("score3")
        
        if score > highScore1{ //ランキング1位の記録を更新したら
            defaults.setInteger(score , forKey: "score1") //score1という名前でscoreを保存
            defaults.setInteger(highScore1, forKey: "score2")
            defaults.setInteger(highScore2, forKey: "score3")
        }else if score > highScore2 && score != highScore1{
            defaults.setInteger(score, forKey: "score2")
            defaults.setInteger(highScore2, forKey:  "score3")
        }else if score > highScore3 && score != highScore1 && score != highScore2{
            defaults.setInteger(score, forKey: "score3")
        }
        defaults.synchronize()
        
    }

    @IBAction func retry(){
            score  = 1000 //スコアの値をリセットする
            positionX = [width/2, width/2, width/2] //真ん中に戻す
            self.start() //スタートメソッドを呼び出す
        }
    
    @IBAction func toTOP(){
        self.dismissViewControllerAnimated(true, completion:nil )
    }
    


    override func viewDidLoad() {
        
        positionX = [width/2, width/2 , width/2] // 画面幅の中心
        self.start() //startメソッドを呼び出す
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
