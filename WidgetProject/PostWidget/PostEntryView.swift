//
//  PostView.swift
//  WidgetProject
//
//  Created by BC on 2020-09-28.
//

import SwiftUI

struct PostEntryView: View {
	let model: DefaultPublishableEntry
	let layout = [GridItem(.adaptive(minimum: 150))
	]
	@Environment(\.widgetFamily) var family

	@ViewBuilder
	var body: some View {
		LazyVGrid(columns: layout) {
			let data = (family == .systemSmall ? [model.defaultPublishables.first!] : (family == .systemMedium ? Array(model.defaultPublishables.prefix(2)) : model.defaultPublishables) )
			ForEach(data, id: \.self) { publishable in
				ZStack {
					HStack {
						Image(publishable.thumbUrl ?? "")
							.resizable()
							.scaledToFit()
							.clipped()
							.cornerRadius(10)
					}
					VStack(alignment: .trailing) {
						Image((publishable.postType == "" ? "iconIg" : publishable.postType))
							.padding(.top, 10)
							.scaledToFit()
						Spacer()
						Text(verbatim: publishable.caption)
							.lineLimit(1)
							.foregroundColor(.white)
						Text(verbatim: publishable.getFormattedDate())
							.foregroundColor(.white)
							.bold()
					}
				}
			}
		}

	}
}

struct PostView_Previews: PreviewProvider {
	static let model = DefaultPublishableEntry(date: Date(), defaultPublishables: [DefaultPublishable( postId: "123233", thumbUrl: "https://dogeo4ne9xfxq.cloudfront.net/sized/a90578fb7558bf-AE158090/med_thumbnail.jpg?1600901629", scheduledAt: Date(), caption: "Post caption!!")])
    static var previews: some View {

		Group {

			PostEntryView(model: model)
				.previewLayout(.fixed(width: 160, height: 160))
		}
	}

}
