//
//  MapLearn.swift
//  SwiftUILearn
//
//  Created by Augus on 2023/9/7.
//
//  地图

import SwiftUI
import MapKit

struct MapLearn: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct MapLearn_Previews: PreviewProvider {
    static var previews: some View {
        MapLearn()
    }
}
