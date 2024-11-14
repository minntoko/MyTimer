//
//  ContentView.swift
//  MyTimer
//
//  Created by 松田知也 on 2024/11/09.
//

import SwiftUI

struct ContentView: View {
    // タイマーの変数を作成
    @State var timerHandler: Timer?
    // カウントの変数を作成
    @State var count = 0
    // 永続化する秒数設定（初期値は10）
    @AppStorage("timer_value") var timerValue = 10
    var body: some View {
        NavigationStack {
            ZStack{
                Image("backgroundTimer")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(spacing: 30.0) {
                    Text("残り\(timerValue - count)秒")
                        .font(.largeTitle)
                    HStack {
                        Button {
                            // ボタンをタップした時のアクション
                            startTimer()
                        } label: {
                            Text("スタート")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 140, height: 140)
                                .background(Color("startColor"))
                                .clipShape(Circle())
                        }
                        Button {
                            // ボタンをタップした時のアクション
                            if let unwrapedTimerHandler = timerHandler {
                                // もしタイマーが実行中だったら停止
                                if unwrapedTimerHandler.isValid == true {
                                    unwrapedTimerHandler.invalidate()
                                }
                            }
                        } label: {
                            Text("ストップ")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 140, height: 140)
                                .background(Color("stopColor"))
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        SettingView()
                    } label: {
                        Text("秒数設定")
                    }
                }
            }
        }
    }
    
    // 1秒ごとに実行されてカウントダウンする
    func countDownTimer() {
        count += 1
        // 設定した時間 - 現在のカウントが0になった時にタイマーを止める
        if timerValue - count <= 0 {
            // タイマー停止
            timerHandler?.invalidate()
        }
    }
    // タイマーをカウントダウン開始する関数
    func startTimer() {
        // timerHandlerをアンラップしてunwrapedTimerHandlerに代入
        if let unwrapedTimerHandler = timerHandler {
            // もしタイマーが実行中だったらスタートしない
            if unwrapedTimerHandler.isValid == true {
                // 何も処理しない
                return
            }
        }
        
        // 残り時間が0以下のとき、count（経過時間）を0に初期化する
        if timerValue - count <= 0 {
            // count（経過時間）を0に初期化する
            count = 0
        }
        
        // タイマーをスタート
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
            // タイマー実行時に呼び出される
            countDownTimer()
        }
    }
}

#Preview {
    ContentView()
}
