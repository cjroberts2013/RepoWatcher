//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Charles Roberts on 10/17/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> GitUserEntry {
        GitUserEntry(date: Date(), user: .mock)
    }

    func getSnapshot(in context: Context, completion: @escaping (GitUserEntry) -> ()) {
        let entry = GitUserEntry(date: Date(), user: .mock)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds.
            
            do {
                let user = try await NetworkManager.shared.getUser(urlString: UserURL.myUser)
                let entry = GitUserEntry(date: .now, user: user)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("Error - \(error.localizedDescription)")
            }
        }
    }
}

struct GitUserEntry: TimelineEntry {
    let date: Date
    let user: GitUser
}

struct RepoWatcherWidgetEntryView : View {
    var entry: Provider.Entry
    let formatter = ISO8601DateFormatter()
    var daysSinceLastPush: Int {
        calculateLastPush(dateString: entry.user.updated_at)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Circle()
                        .frame(width: 50, height: 50)
                    
                    Text(entry.user.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                
                Text("Last Pushed: \(daysSinceLastPush) days ago.")
                    .font(.caption)
                    .padding(.bottom, 6)
                
                HStack {
                    Label(
                        title: {
                            Text("\(entry.user.followers)")
                                .font(.footnote)
                        },
                        icon: {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(.green)
                        }
                    )
                    .fontWeight(.medium)
                }
            }
            
            Spacer()
            
            VStack {
                Text("\(entry.user.public_repos)")
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .bold()
                
                Text("public repositories")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(4)
    }
    
    func calculateLastPush(dateString: String) -> Int {
        let lastPushDate = formatter.date(from: dateString) ?? .now
        let daysSinceLastPush = Calendar.current.dateComponents([.day], from: lastPushDate, to: .now).day ?? 0
        return daysSinceLastPush
    }
}

struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RepoWatcherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RepoWatcherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    RepoWatcherWidget()
} timeline: {
    GitUserEntry(date: .now, user: .mock)
}
