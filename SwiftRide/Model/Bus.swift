import Foundation
import SwiftUI

struct Bus: Identifiable, Decodable{
    let id: UUID
    let name: String
    let number: Int
    let licensePlate: String
    let color: Color
    var schedule: [BusSchedule]
    
    enum Codnames: String, CodingKey {
        case name = "bus_name"
        case number = "bus_number"
        case licensePlate = "license_plate"
        case color = "bus_color"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Codnames.self)
        id = UUID()
        name = try container.decode(String.self, forKey: .name)
        number = try container.decode(Int.self, forKey: .number)
        licensePlate = try container.decode(String.self, forKey: .licensePlate)
        color = Color.fromString(try container.decode(String.self, forKey: .color))
        schedule = []
    }
    
    func assignSchedule(schedules: [BusSchedule]) -> Bus {
        var updatedSelf = self
        
        for schedule in schedules {
            if schedule.busNumber != self.number { continue }
            updatedSelf.schedule.append(schedule)
        }
        return updatedSelf
    }
    
    func getClosestArrivalTime(from timestring: String) -> TimeInterval? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let today = Date()
        let calendar = Calendar.current
        
        guard let timeDate = formatter.date(from: timestring) else { return nil }
        
        let components = calendar.dateComponents([.hour, .minute], from: timeDate)
        
        guard let todayWithTime = calendar.date(
            bySettingHour: components.hour ?? 0,
            minute: components.minute ?? 0,
            second: 0,
            of: today
        ) else { return nil }
        
        // returns time interval in seconds
        return todayWithTime.timeIntervalSinceNow
    }
}

extension Color {
    static func fromString(_ input: String) -> Color {
        switch input.lowercased() {
        case "red":
            return .red
        case "blue":
            return .blue
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "orange":
            return .orange
        case "mint":
            return .mint
        case "indigo":
            return .indigo
        case "cyan":
            return .cyan
        case "purple":
            return .purple
        case "pink":
            return .pink
        case "gray":
            return .gray
        case "black":
            return .black
        case "white":
            return .white
        default:
            return .teal
        }
    }
}

func loadBuses() -> [Bus] {
    guard let url = Bundle.main.url(forResource: "Bus", withExtension: "json") else {
        print("Bus.json not found")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let buses = try JSONDecoder().decode([Bus].self, from: data)
        return buses
    } catch {
        print("Error reading Bus.json: \(error)")
        return[]
    }
}
