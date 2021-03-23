import SwiftUI

public struct DataPoint: Identifiable, Codable {
    public let id: UUID
    let label: String
    let value: Float
    
    public init(label: String, value: Float) {
        self.id = UUID()
        self.label = label
        self.value = value
    }
}

public struct DataSeries {
    let dataPoints: [DataPoint]
    
    public init(dataPoints: [DataPoint]) {
        self.dataPoints = dataPoints
    }
    
    var max: Float {
        dataPoints.reduce(5.0) { (prev, dp) -> Float in
            Swift.max(prev, dp.value)
        }
    }
}

struct BarView: View {
    let point: DataPoint
    let height: Float
    let maxValue: Float
    
    var body: some View {
        let yValue = CGFloat(Swift.min(self.height*point.value/self.maxValue, self.height))
        
        return VStack {
            Text(String(format: "%.0f", point.value))
                .foregroundColor(.secondary)
            
            Rectangle()
                .fill(Color.accentColor)
                .frame( maxHeight: yValue)
                .cornerRadius(10.0)
            // .frame(width: 80, height: CGFloat(yValue))
            
            Text(point.label)
                .foregroundColor(.primary)
        }
    }
}

public struct BarChart: View {
    let data: DataSeries
    let height: Float
    
    public init(data: DataSeries, height: Float) {
        self.data = data
        self.height = height
    }
    
    public var body: some View {
        let maxValue = self.data.max
        return HStack(alignment:.bottom) {
            ForEach(self.data.dataPoints) { dataPoint  in
                BarView(point: dataPoint, height: self.height, maxValue: maxValue)
            }
        }.padding()
    }
}
