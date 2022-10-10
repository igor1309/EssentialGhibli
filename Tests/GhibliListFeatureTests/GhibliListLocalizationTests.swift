//
//  GhibliListLocalizationTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

@testable import GhibliListFeature
import XCTest

final class GhibliListLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle: Bundle = .module
        
        let localizationBundles = allLocalizationBundles(in: bundle)
        let localizedStringKeys = allLocalizedStringKeys(in: localizationBundles, table: table)

        localizationBundles.forEach { (bundle, localization) in
            localizedStringKeys.forEach { key in
                let localizedString = bundle.localizedString(forKey: key, value: nil, table: table)

                if localizedString == key {
                    let language = Locale.current.localizedString(forLanguageCode: localization) ?? ""

                    XCTFail("Missing \(language) (\(localization)) localized string for key: '\(key)' in table: '\(table)'")
                }
            }
        }
    }

    // MARK: - Helpers
    
    private typealias LocalizedBundle = (bundle: Bundle, localization: String)

    private func allLocalizationBundles(
        in bundle: Bundle,
        file: StaticString = #file,
        line: UInt = #line
    ) -> [LocalizedBundle] {
        XCTAssertEqual(bundle.localizations, ["en", "ru"])
        
        return bundle.localizations.compactMap { localization in
            guard
                let path = bundle.path(forResource: localization, ofType: "lproj"),
                let localizedBundle = Bundle(path: path)
            else {
                XCTFail("Couldn't find bundle for localization: \(localization)", file: file, line: line)
                return nil
            }

            return (localizedBundle, localization)
        }
    }

    private func allLocalizedStringKeys(
        in bundles: [LocalizedBundle],
        table: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Set<String> {
        return bundles.reduce([]) { (acc, current) in
            guard
                let path = current.bundle.path(forResource: table, ofType: "strings"),
                let strings = NSDictionary(contentsOfFile: path),
                let keys = strings.allKeys as? [String]
            else {
                XCTFail("Couldn't load localized strings for localization: \(current.localization)", file: file, line: line)
                return acc
            }

            return acc.union(Set(keys))
        }
    }
}
