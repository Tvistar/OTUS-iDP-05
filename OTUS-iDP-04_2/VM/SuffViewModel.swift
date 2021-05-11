//
//  RamViewModel.swift
//  OTUS-iDP-03
//
//  Created by Igor Andryushenko on 14.04.2021.
//


import Foundation
import Combine



struct SuffAll: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
}


final class SuffViewModel: ObservableObject {
    
    @Published private(set) var allSuffList: [SuffAll] = [SuffAll]()
    @Published private(set) var suf3xList: [SuffAll] = [SuffAll]()
    @Published private(set) var suf5xList: [SuffAll] = [SuffAll]()
    
    
    @Published var isASC: Bool = false
    @Published var type: Int = 0
    
    @Published var debouncedText = ""
    @Published var searchText = ""
    private var subscriptions = Set<AnyCancellable>()
    
    var text: String = ""
    var suff3x = [String]()
    var suff5x = [String]()
    
    init() {
        loadAll()
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink(receiveValue: { t in
                self.debouncedText = t
                self.showGlobalList(isASC: self.isASC)
            } )
            .store(in: &subscriptions)
    }
    
    func loadPage() {
        
        if type == 0 {
            showGlobalList(isASC: isASC)
        } else if type == 1 {
            showTop10_3x()
            
        } else if type == 2 {
            showTop10_5x()
        }
    }
    
    func showGlobalList(isASC: Bool){
        var suffList: [SuffAll] = [SuffAll]()
        allSuffList.removeAll()
        //List ASC/DESC
        var allSuff = [String]()
        allSuff = suff3x + suff5x
        
        
        if !isASC{
            let setAllASC = NSCountedSet()
            setAllASC.addObjects(from: allSuff)
            var dictAllASC = [String: Int]()
            setAllASC.forEach { (item) in
                dictAllASC[item as! String] = setAllASC.count(for: item)
            }
            
            let ascAll = dictAllASC.sorted(by: { $0 < $1 })
            
            
            for item in ascAll {
                let name: String = "\(item.key)"
                let count: Int = Int(item.value)
                suffList.append(SuffAll(name: name, count: count))
            }
        } else {
            let setAllDesc = NSCountedSet()
            setAllDesc.addObjects(from: allSuff)
            var dictAllDESC = [String: Int]()
            setAllDesc.forEach { (item) in
                dictAllDESC[item as! String] = setAllDesc.count(for: item)
            }
            
            let descAll = dictAllDESC.sorted(by: { $0 > $1 })
            
            for item in descAll {
                let name: String = "\(item.key)"
                let count: Int = Int(item.value)
                suffList.append(SuffAll(name: name, count: count))
            }
        }
        
        if debouncedText != ""{
            let filteredStrings = suffList.filter({(item: SuffAll) -> Bool in

                let stringMatch = item.name.lowercased().range(of: debouncedText.lowercased())
                return stringMatch != nil ? true : false
            })
            allSuffList = filteredStrings
        } else {
            allSuffList = suffList
        }
        
        
    }
    
    func showTop10_3x(){
        suf3xList.removeAll()
        //Top10 3x by count
        let set3x = NSCountedSet()
        set3x.addObjects(from: suff3x)
        var dict3x = [String: Int]()
        set3x.forEach { (item) in
            dict3x[item as! String] = set3x.count(for: item)
        }
        
        print(dict3x)
        
        let sortTop10_3x = dict3x
            .filter { $1 > 1 }
            .sorted { $0.1 > $1.1 }
        
        
        let list = sortTop10_3x.prefix(9)
        print(list)
        
        for item in list {
            let name: String = "\(item.key)"
            let count: Int = Int(item.value)
            self.suf3xList.append(SuffAll(name: name, count: count))
        }
        
    }
    
    func showTop10_5x(){
        suf5xList.removeAll()
        //Top10 5x by count
        let set5x = NSCountedSet()
        set5x.addObjects(from: suff5x)
        var dict5x = [String: Int]()
        set5x.forEach { (item) in
            dict5x[item as! String] = set5x.count(for: item)
        }
        
        print(dict5x)
        
        let sortTop10_5x = dict5x
            .filter { $1 > 1 }
            .sorted { $0.1 > $1.1 }
        
        let list = sortTop10_5x.prefix(9)
        
        print(list)
        
        for item in list {
            let name: String = "\(item.key)"
            let count: Int = Int(item.value)
            self.suf5xList.append(SuffAll(name: name, count: count))
        }
        
    }
    
    
    
    func loadAll(){
        //        let defaults = UserDefaults.standard
        //        text =  defaults.string(forKey: "shared") ?? ""
        
        let defaults = UserDefaults(suiteName: "group.otus.idp.04") // Your App Group name
        text = defaults!.string(forKey: "shared") ?? ""
        
        //text = "Привіт, мене звати Сергій, я працюю DevOps-інженером у компанії Luxoft. Хочу розповісти про появу одного з найперших MMORPG-серверів в Україні та загалом на пострадянському просторі в ті часи, коли інтернет ще був тільки на модемі. Ця стаття може бути цікава усім, хто грав у MMORPG і полюбляє читати історії, які трапилися багато років тому, на початку поширення інтернету. Гадаю, особливо вона «зайде» тим, хто навчався в КПІ приблизно у 1998–2004 роках. Друга половина дев’яностих На території колишнього СРСР інтернет ще тільки починає розвиватись. Комерційних сайтів практично немає (а якщо і є, то лише айтішного напряму: простенькі сторінки з можливістю завантажити прайс). Web ще не став тим місцем, де користувачі проводять більшу частину часу. Провідна технологія — dial-up. Користувачі переважно читають електронну пошту і сидять в ICQ. Але ентузіасти-айтішники вже користуються «ньюсами» (Usenet Newsgroups) і IRC тощо. І, звичайно, грають у мережеві ігри, про які й поговоримо."
        
        print(text)
        
        if !text.isEmpty{
            let sequence = text.split(separator: " ")
            let iterText = sequence.makeIterator()
            
            for word in iterText{
                let s3: String = String(word.suffix(3))
                let s5: String = String(word.suffix(5))
                if word.count >= 3{
                    suff3x.append(s3)
                }
                if word.count >= 5{
                    suff5x.append(s5)
                }
                
                
                
            }
        }
        
    }
}


