import Foundation

struct POSCompletedOrder: Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let lines: [POSCompletedOrderLine]

    init(id: UUID = UUID(), createdAt: Date = Date(), lines: [POSCompletedOrderLine]) {
        self.id = id
        self.createdAt = createdAt
        self.lines = lines
    }

    var totalAmount: Decimal {
        lines.reduce(0) { $0 + $1.lineTotal }
    }
}

struct POSCompletedOrderLine: Hashable {
    let drinkName: String
    let quantity: Int
    let lineTotal: Decimal
}
