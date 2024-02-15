//
//  Enums.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/13/24.
//

import Foundation

public enum SeniorReviewResult: CustomStringConvertible, Identifiable{
    
    case success(details: String);
    case failure(details: String);

    public var description: String{
        switch self{
        case .success(let details): return "SUCCESS - \(details)"
        case .failure(let details): return "FAILURE - \(details)"
        }
    }
    
    public var id: String{
        return self.description
    }
}

/// Represents the model of the Mac.
///
/// When calling the initialization method, provide the model identifier for the raw value and it will return the corresponding Mac model.
public enum MacModel: CustomStringConvertible{
    case imac_24_M3_2023_fourUSBC
    case imac_24_M3_2023_twoUSBC
    case imac_24_M1_2021_fourUSBC
    case imac_24_M1_2021_twoUSBC
    case imac_retina5k_27_2020
    case imac_retina5k_27_2019
    case imacpro_2017
    case imac_retina5k_27_2017
    case imac_retina4k_21_5_2017
    case imac_21_5_2017
    case imac_retina5k_27_late2015
    case imac_retina4k_21_5_late2015
    case imac_21_5_late2015
    case imac_retina5k_27_mid2015
    case macbookpro_14_M3_november2023
    case macbookpro_14_M3_pro_max_november2023
    case macbookpro_16_M3_pro_max_november2023
    case macbookpro_14_M2_pro_max_2023
    case macbookpro_16_M2_pro_max_2023
    case macbookpro_13_M2_2022
    case macbookpro_14_M1_pro_max_2021
    case macbookpro_16_M1_pro_max_2021
    case macbookpro_13_M1_2020
    case macbookpro_13_2020_twoUSBC
    case macbookpro_13_2020_fourUSBC
    case macbookpro_16_2019
    case macbookpro_13_2019_twoUSBC
    case macbookpro_15_2019
    case macbookpro_13_2019_2018_fourUSBC
    case macbookpro_15_2019_2018
    case macbookpro_15_2017
    case macbookpro_13_2017_fourUSBC
    case macbookpro_13_2017_twoUSBC
    case macbookpro_15_2016
    case macbookpro_13_2016_fourUSBC
    case macbookpro_13_2016_twoUSBC
    case macbookpro_retina_15_mid2015
    case macbookpro_retina_13_early2015
    case macbookair_15_M2_2023
    case macbookair_13_M2_2022
    case macbookair_13_M1_2020
    case macbookair_retina_13_2020
    case macbookair_retina_13_2019
    case macbookair_retina_13_2018
    case macbookair_13_2017_early2015
    case macbookair_11_early2015
    case macmini_m2_2023
    case macmini_m2pro_2023
    case macmini_m1_2020
    case macmini_2018
    case macmini_late2014
    case macstudio_m2max_2023
    case macstudio_m2ultra_2023
    case macstudio_m1max_2022
    case macstudio_m1ultra_2022
    case unknown(modelIdentifier: String)
    
    /// Returns the corresponding Mac model for the given model identifier.
    /// - Parameter rawValue: The model identifier of the Mac.
    public init(rawValue: String) {
        
        if rawValue == "Mac15,5"{
            self = .imac_24_M3_2023_fourUSBC
        }else if rawValue == "Mac15,4"{
            self = .imac_24_M3_2023_twoUSBC
        }else if rawValue == "iMac21,1" {
            self = .imac_24_M1_2021_fourUSBC
        }else if rawValue == "iMac21,2"{
            self = .imac_24_M1_2021_twoUSBC
        }else if rawValue == "iMac20,1" || rawValue == "iMac20,2"{
            self = .imac_retina5k_27_2020
        }else if rawValue == "iMac19,1" || rawValue == "iMac19,2"{
            self = .imac_retina5k_27_2019
        }else if rawValue == "iMacPro1,1"{
            self = .imacpro_2017
        }else if rawValue == "iMac18,3"{
            self = .imac_retina5k_27_2017
        }else if rawValue == "iMac18,2"{
            self = .imac_retina4k_21_5_2017
        }else if rawValue == "iMac18,1"{
            self = .imac_21_5_2017
        }else if rawValue == "iMac17,1"{
            self = .imac_retina5k_27_late2015
        }else if rawValue == "iMac16,2"{
            self = .imac_retina4k_21_5_late2015
        }else if rawValue == "iMac16,1"{
            self = .imac_21_5_late2015
        }else if rawValue == "iMac15,1"{
            self = .imac_retina5k_27_mid2015
        }else if rawValue == "Mac15,3"{
            self = .macbookpro_14_M3_november2023
        }else if rawValue == "Mac15,6" || rawValue == "Mac15,8" || rawValue == "Mac15,10"{
            self = .macbookpro_14_M3_pro_max_november2023
        }else if rawValue == "Mac15,7" || rawValue == "Mac15,9" || rawValue == "Mac15,11"{
            self = .macbookpro_16_M3_pro_max_november2023
        }else if rawValue == "Mac14,5" || rawValue == "Mac14,9"{
            self = .macbookpro_14_M2_pro_max_2023
        }else if rawValue == "Mac14,6" || rawValue == "Mac14,10"{
            self = .macbookpro_16_M2_pro_max_2023
        }else if rawValue == "Mac14,7"{
            self = .macbookpro_13_M2_2022
        }else if rawValue == "MacBookPro18,3" || rawValue == "MacBookPro18,4"{
            self = .macbookpro_14_M1_pro_max_2021
        }else if rawValue == "MacBookPro18,1" || rawValue == "MacBookPro18,2"{
            self = .macbookpro_16_M1_pro_max_2021
        }else if rawValue == "MacBookPro17,1"{
            self = .macbookpro_13_M1_2020
        }else if rawValue == "MacBookPro16,3"{
            self = .macbookpro_13_2020_twoUSBC
        }else if rawValue == "MacBookPro16,2"{
            self = .macbookpro_13_2020_fourUSBC
        }else if rawValue == "MacBookPro16,1" || rawValue == "MacBookPro16,4"{
            self = .macbookpro_16_2019
        }else if rawValue == "MacBookPro15,4"{
            self = .macbookpro_13_2019_twoUSBC
        }else if rawValue == "MacBookPro15,3"{
            self = .macbookpro_15_2019
        }else if rawValue == "MacBookPro15,2"{
            self = .macbookpro_13_2019_2018_fourUSBC
        }else if rawValue == "MacBookPro15,1"{
            self = .macbookpro_15_2019_2018
        }else if rawValue == "MacBookPro14,3"{
            self = .macbookpro_15_2017
        }else if rawValue == "MacBookPro14,2"{
            self = .macbookpro_13_2017_fourUSBC
        }else if rawValue == "MacBookPro14,1"{
            self = .macbookpro_13_2017_twoUSBC
        }else if rawValue == "MacBookPro13,3"{
            self = .macbookpro_15_2016
        }else if rawValue == "MacBookPro13,2"{
            self = .macbookpro_13_2016_fourUSBC
        }else if rawValue == "MacBookPro13,1"{
            self = .macbookpro_13_2016_twoUSBC
        }else if rawValue == "MacBookPro11,4" || rawValue == "MacBookPro11,5"{
            self = .macbookpro_retina_15_mid2015
        }else if rawValue == "MacBookPro12,1"{
            self = .macbookpro_retina_13_early2015
        }else if rawValue == "Mac14,15"{
            self = .macbookair_15_M2_2023
        }else if rawValue == "Mac14,2"{
            self = .macbookair_13_M2_2022
        }else if rawValue == "MacBookAir10,1"{
            self = .macbookair_13_M1_2020
        }else if rawValue == "MacBookAir9,1"{
            self = .macbookair_retina_13_2020
        }else if rawValue == "MacBookAir8,2"{
            self = .macbookair_retina_13_2019
        }else if rawValue == "MacBookAir8,1"{
            self = .macbookair_retina_13_2018
        }else if rawValue == "MacBookAir7,2"{
            self = .macbookair_13_2017_early2015
        }else if rawValue == "MacBookAir7,1"{
            self = .macbookair_11_early2015
        }else if rawValue == "Mac14,3"{
            self = .macmini_m2_2023
        }else if rawValue == "Mac14,12"{
            self = .macmini_m2pro_2023
        }else if rawValue == "Macmini9,1"{
            self = .macmini_m1_2020
        }else if rawValue == "Macmini8,1"{
            self = .macmini_2018
        }else if rawValue == "Macmini7,1"{
            self = .macmini_late2014
        }else if rawValue == "Mac14,13"{
            self = .macstudio_m2max_2023
        }else if rawValue == "Mac14,14"{
            self = .macstudio_m2ultra_2023
        }else if rawValue == "Mac13,1"{
            self = .macstudio_m1max_2022
        }else if rawValue == "Mac13,2"{
            self = .macstudio_m1ultra_2022
        }else{
            self = .unknown(modelIdentifier: rawValue)
        }
        
    }
    
    /// A human readable description of the Mac Model.
    public var description: String{
        switch self{
        case .imac_24_M3_2023_fourUSBC: return "iMac (24-inch, 2023) w/ Four USB-C"
        case .imac_24_M3_2023_twoUSBC: return "iMac (24-inch, 2023) w/ Two USB-C"
        case .imac_24_M1_2021_fourUSBC: return "iMac (24-inch, 2021) w/ Four USB-C"
        case .imac_24_M1_2021_twoUSBC: return "iMac (24-inch, 2021) w/ Two USB-C"
        case .imac_retina5k_27_2020: return "iMac (Retina 5K, 27-inch, 2020)"
        case .imac_retina5k_27_2019: return "iMac (Retina 5K, 27-inch, 2019)"
        case .imacpro_2017: return "iMac Pro (2017)"
        case .imac_retina5k_27_2017: return "iMac (Retina 5K, 27-inch, 2017)"
        case .imac_retina4k_21_5_2017: return "iMac (Retina 4K, 21.5-inch, 2017)"
        case .imac_21_5_2017: return "iMac (21.5-inch, 2017)"
        case .imac_retina5k_27_late2015: return "iMac (Retina 5K, 27-inch, Late 2015)"
        case .imac_retina4k_21_5_late2015: return "iMac (Retina 4K, 21.5-inch, Late 2015)"
        case .imac_21_5_late2015: return "iMac (21.5-inch, Late 2015)"
        case .imac_retina5k_27_mid2015: return "iMac (Retina 5K, 27-inch, Mid 2015)"
        case .macbookpro_14_M3_november2023: return "MacBook Pro (14-inch, M3, Nov 2023)"
        case .macbookpro_14_M3_pro_max_november2023: return "MacBook Pro (14-inch, Nov 2023)"
        case .macbookpro_16_M3_pro_max_november2023: return "MacBook Pro (16-inch, Nov 2023)"
        case .macbookpro_14_M2_pro_max_2023: return "MacBook Pro (14-inch, 2023)"
        case .macbookpro_16_M2_pro_max_2023: return "MacBook Pro (16-inch, 2023)"
        case .macbookpro_13_M2_2022: return "MacBook Pro (13-inch, 2022)"
        case .macbookpro_14_M1_pro_max_2021: return "MacBook Pro (14-inch, 2021)"
        case .macbookpro_16_M1_pro_max_2021: return "MacBook Pro (16-inch, 2021)"
        case .macbookpro_13_M1_2020: return "MacBook Pro (13-inch, 2020)"
        case .macbookpro_13_2020_twoUSBC: return "MacBook Pro (13-inch, 2020, Two Thunderbolt 3 ports)"
        case .macbookpro_13_2020_fourUSBC: return "MacBook Pro (13-inch, 2020, Four Thunderbolt 3 ports)"
        case .macbookpro_16_2019: return "MacBook Pro (16-inch, 2019)"
        case .macbookpro_13_2019_twoUSBC: return "MacBook Pro (13-inch, 2019, Two Thunderbolt 3 ports)"
        case .macbookpro_15_2019: return "MacBook Pro (15-inch, 2019)"
        case .macbookpro_13_2019_2018_fourUSBC: return "MacBook Pro (13-inch, 2019/2018, Four Thunderbolt 3 ports)"
        case .macbookpro_15_2019_2018: return "MacBook Pro (15-inch, 2019/2018)"
        case .macbookpro_15_2017: return "MacBook Pro (15-inch, 2017)"
        case .macbookpro_13_2017_fourUSBC: return "MacBook Pro (13-inch, 2017, Four Thunderbolt 3 ports)"
        case .macbookpro_13_2017_twoUSBC: return "MacBook Pro (13-inch, 2017, Two Thunderbolt 3 ports)"
        case .macbookpro_15_2016: return "MacBook Pro (15-inch, 2016)"
        case .macbookpro_13_2016_fourUSBC: return "MacBook Pro (13-inch, 2016, Four Thunderbolt 3 ports)"
        case .macbookpro_13_2016_twoUSBC: return "MacBook Pro (13-inch, 2016, Two Thunderbolt 3 ports)"
        case .macbookpro_retina_15_mid2015: return "MacBook Pro (Retina, 15-inch, Mid 2015)"
        case .macbookpro_retina_13_early2015: return "MacBook Pro (Retina, 13-inch, Early 2015)"
        case .macbookair_15_M2_2023: return "MacBook Air (15-inch, 2023)"
        case .macbookair_13_M2_2022: return "MacBook Air (13-inch, 2022)"
        case .macbookair_13_M1_2020: return "MacBook Air (13-inch, 2020)"
        case .macbookair_retina_13_2020: return "MacBook Air (Retina, 13-inch, 2020)"
        case .macbookair_retina_13_2019: return "MacBook Air (Retina, 13-inch, 2019)"
        case .macbookair_retina_13_2018: return "MacBook Air (Retina, 13-inch, 2018)"
        case .macbookair_13_2017_early2015: return "MacBook Air (13-inch, 2017/Early 2015)"
        case .macbookair_11_early2015: return "MacBook Air (11-inch, Early 2015)"
        case .macmini_m2_2023: return "Mac mini (2023)"
        case .macmini_m2pro_2023: return "Mac mini (2023)"
        case .macmini_m1_2020: return "Mac mini (2020)"
        case .macmini_2018: return "Mac mini (2018)"
        case .macmini_late2014: return "Mac mini (Late 2014)"
        case .macstudio_m2max_2023: return "Mac Studio (2023)"
        case .macstudio_m2ultra_2023: return "Mac Studio (2023)"
        case .macstudio_m1max_2022: return "Mac Studio (2022)"
        case .macstudio_m1ultra_2022: return "Mac Studio (2022)"
        case .unknown(let modelIdentifier): return modelIdentifier
        }
    }
}


enum Song: String, CaseIterable{
    case lifeIsAHighway = "Life is a Highway"
    case noPomegranates = "No Pomegranates Trap Remix"
    case smashMouthAllStar = "Smash Mouth - All Star"
    case theHomeDepotBeat = "The Home Depot Beat"
    case oldTimeRockNRoll = "Old Time Rock N' Roll"
    case ballForMePostMalone = "Ball For Me - Post Malone"
    case hitMeWithYourBestShot = "Hit Me With Your Best Shot"
    case youMakeMeFeel = "You Make Me Feel"
    case ninteyTwoExplorer = "92 Explorer"
    case goosebumps = "Goosebumps"
    case georgeWashintonTypeBeat = "George Washington Type Beat"
    case boing = "Boing!"
    case undertaleMegalovania = "Undertale - Megalovania"
    case cbat = "Cbat"
    case ceeLoGreenFYou = "Cee Lo Green - FUCK YOU"
    
    static func randomCase() -> Song{
        let allCases = Self.allCases;
        let randomIndex = Int.random(in: 0..<allCases.count)
        return allCases[randomIndex]
    }
}
