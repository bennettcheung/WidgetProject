//
//  DefaultPublishable.swift
//  WidgetProject
//
//  Created by BC on 2020-09-28.
//

import Foundation
import WidgetKit

struct DefaultPublishable: Decodable, Hashable {

	var postId: String?
	var thumbUrl: String?
	var scheduledAt: Date? 
	var caption: String = ""
	var postType: String = ""

	func generateRandomDate(daysBack: Int)-> Date?{
			let day = arc4random_uniform(UInt32(daysBack))+1
			let hour = arc4random_uniform(23)
			let minute = arc4random_uniform(59)

			let today = Date(timeIntervalSinceNow: 0)
			let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
			var offsetComponents = DateComponents()
			offsetComponents.day = -1 * Int(day - 1)
			offsetComponents.hour = -1 * Int(hour)
			offsetComponents.minute = -1 * Int(minute)

			let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
			return randomDate
		}
	func getFormattedDate() -> String {
//		guard let scheduledAt = self.scheduledAt else { return  "" }
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd h:mm a"
//		return formatter.string(from: scheduledAt)
		return "     " + formatter.string(from: generateRandomDate(daysBack: 2) ?? Date())
	}
}
struct DefaultPublishableEntry: TimelineEntry{
	var date: Date = Date()
	var defaultPublishables = [DefaultPublishable]()
}
