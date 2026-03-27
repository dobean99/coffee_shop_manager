import Foundation

struct StaffMember: Identifiable, Hashable {
    let id: UUID
    var name: String
    var role: String

    init(id: UUID = UUID(), name: String, role: String) {
        self.id = id
        self.name = name
        self.role = role
    }
}
