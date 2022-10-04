import Foundation

enum LocalizedString {

    // MARK: - Tab Bars
    
    enum TabBar {

        static let createTitle = NSLocalizedString(
            "tabBar-createTitle",
            value: "Create",
            comment: "Title of create tab bar item."
        )
        static let coversTitle = NSLocalizedString(
            "tabBar-coversTitle",
            value: "Covers",
            comment: "Title of collection tab bar item."
        )
        static let settingsTitle = NSLocalizedString(
            "tabBar-settingsTitle",
            value: "Settings",
            comment: "Title of settings tab bar item."
        )
    }

    // MARK: - Create Tab
    
    enum Create {

        static let navBarTitle = NSLocalizedString(
            "create-navBarTitle",
            value: "Create",
            comment: "Title of navigation bar on the create tab."
        )
        static let backButtonTitle = NSLocalizedString(
            "buttons-backButtonTitle",
            value: "Back",
            comment: "Title of back button shown when editing album cover."
        )
        static let addToCollectionTitle = NSLocalizedString(
            "buttons-addToCollectionButtonTitle",
            value: "Add Cover",
            comment: "Title of add to collection button shown when editing album cover."
        )
    }

    // MARK: - Collection Tab
    
    enum Covers {

        static let navBarTitle = NSLocalizedString(
            "covers-navBarTitle",
            value: "Covers",
            comment: "Title of navigation bar on the collection tab."
        )
    }

    // MARK: - Settings Tab

    enum Settings {

        // MARK: Main Screen

        static let navBarTitle = NSLocalizedString(
            "settings-mainScreen-navBarTitle",
            value: "Settings",
            comment: "Title of navigation bar on the settings tab."
        )
        static let tipJarTitle = NSLocalizedString(
            "settings-mainScreen-tipJarTitle",
            value: "Tip",
            comment: "Title of tip jar cell on the settings tab."
        )
        static let tipJarDescription = NSLocalizedString(
            "settings-mainScreen-tipJarDescription",
            value: "Like the app? Help support (me) the dev make more apps like this.",
            comment: "Description in tip jar cell on the settings tab."
        )

        // MARK: Tip Jar Screen

        static let tipJarNavBarTitle = NSLocalizedString(
            "settings-tipJarScreen-tipJarNavBarTitle",
            value: "Tip Jar",
            comment: "Title of navigation bar on the tip jar view."
        )
        static let aboutMeMessageIntro = NSLocalizedString(
            "settings-tipJarScreen-aboutMeMessageIntro",
            value: "First off, thank you",
            comment: "First portion of message in about me component on tip jar screen."
        )
        static let aboutMeAfterIntro = NSLocalizedString(
            "settings-tipJarScreen-aboutMeAfterIntro",
            value: " for checking out my app! My name is Aman Ketebo, I design and develop my own apps outside of work. I hope to make more apps in the future and any support to help me get my dreams out is greatly appreciated. ❤️",
            comment: "Second portion of message in about me component on tip jar screen."
        )
    }
}
