//
//  PostWidget.swift
//  PostWidget
//
//  Created by BC on 2020-09-28.
//

import WidgetKit
import SwiftUI

extension FileManager {
  static func sharedContainerURL() -> URL {
	return FileManager.default.containerURL(
	  forSecurityApplicationGroupIdentifier: "group.it.latergram.latergram.sharevia"
	)!
  }
}


struct Provider: TimelineProvider {
	func readContents() -> [DefaultPublishable] {
	  var contents: [DefaultPublishable] = []
	  let archiveURL =
		FileManager.sharedContainerURL()
		  .appendingPathComponent("contents.json")
	  print(">>> \(archiveURL)")

	  let decoder = JSONDecoder()
		if let codeData = try? String(contentsOf: archiveURL).data(using: .utf8) {
		do {
		  contents = try decoder.decode([DefaultPublishable].self, from: codeData)
		} catch {
		  print("Error: Can't decode contents \(error)")
		}
	  }
	  return contents
	}

    func placeholder(in context: Context) -> DefaultPublishableEntry {
		DefaultPublishableEntry(date: Date(), defaultPublishables: [DefaultPublishable()])
    }

    func getSnapshot(in context: Context, completion: @escaping (DefaultPublishableEntry) -> ()) {
		let data = readContents()
        let entry = DefaultPublishableEntry(date: Date(), defaultPublishables: data)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DefaultPublishableEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()

		let data = readContents()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = DefaultPublishableEntry(date: entryDate, defaultPublishables: data)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

@main
struct PostWidget: Widget {
    let kind: String = "PostWidget"

    var body: some WidgetConfiguration {
		
        StaticConfiguration(kind: kind, provider: Provider()) { model in
			PostEntryView(model: model)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.black)
        }
        .configurationDisplayName("Posts scheduled")
        .description("Posts scheduled in Later")

    }
}

struct PostWidget_Previews: PreviewProvider {
    static var previews: some View {
		let data = [DefaultPublishable(postId: "123233", thumbUrl: "med_thumbnail", scheduledAt: Date(), caption: "#Waterfall"),
					DefaultPublishable(postId: "234234", thumbUrl: "med_thumbnail2", scheduledAt: Date(), caption: "#Bali"),
					DefaultPublishable(postId: "53533", thumbUrl: "med_thumbnail3", scheduledAt: Date(), caption: "#Thailand"),
					DefaultPublishable(postId: "5352353", thumbUrl: "med_thumbnail4", scheduledAt: Date(), caption: "#Japan")
		]
		let model = DefaultPublishableEntry(date: Date(), defaultPublishables: data)
		PostEntryView(model: model)
			.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
