//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Игорь Верхов on 26.10.2023.
//

import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query() var prospects: [Prospect]
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var body: some View {
        List(prospects, selection: $selectedProspects) { prospect in
            NavigationLink {
                EditView(prospect: prospect)
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAdress)
                            .foregroundStyle(.secondary)
                    }
                    
                    if prospect.isContacted && filter == .none {
                        Spacer()
                        Image(systemName: "person")
                            .font(.title2)
                            .padding(.trailing, 10)
                    }
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect)
            }
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Scan", systemImage: "qrcode.viewfinder") {
                    isShowingScanner = true
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            
            if selectedProspects.isEmpty == false {
                ToolbarItem(placement: .bottomBar) {
                    Button("Delete selected", action: delete)
                }
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Igor Verkhov\nigor@mysite.com", completion: handleScan)
        }
        
        .onAppear() {
            selectedProspects = []
        }
        
        
    }
    
    init(filter: FilterType, sort: SortDescriptor<Prospect>) {
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            
            _prospects = Query(filter: #Predicate { $0.isContacted == showContactedOnly },
                               sort: [sort] )
        } else {
            _prospects = Query(sort: [sort])
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: .newlines)
            guard details.count == 2 else { return }
            
            let newPerson = Prospect(name: details[0], emailAdress: details[1], isContacted: false)
            modelContext.insert(newPerson)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAdress
            content.sound = UNNotificationSound.default
            
            //            var dateComponents = DateComponents()
            //            dateComponents.hour = 9
            //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .none, sort: SortDescriptor(\Prospect.name))
        .modelContainer(for: Prospect.self)
}
