//
//  MainTabView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            
            Tab("Trans", systemImage: "list.bullet.rectangle.portrait") {
                TransactionsView()
            }
            
            Tab("Stats", systemImage: "chart.bar.fill") {
                StatsView()
            }
            
            Tab("Goals", systemImage: "target") {
                GoalsView()
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
