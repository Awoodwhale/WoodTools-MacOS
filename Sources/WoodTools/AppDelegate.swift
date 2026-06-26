import AppKit
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var statusItem: NSStatusItem?
    private var mainWindow: NSWindow?
    private let popover = NSPopover()
    private let state = WoodToolsState()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        configureApplicationMenu()
        configureStatusItem()
        configurePopover()
        configureNotifications()
    }

    private func configureStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        item.button?.title = ""
        item.button?.image = menuBarImage()
        item.button?.imagePosition = .imageOnly
        item.button?.target = self
        item.button?.action = #selector(togglePopover(_:))
        item.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        statusItem = item
    }

    private func configurePopover() {
        popover.behavior = .transient
        updatePopoverSize()
        popover.contentViewController = NSHostingController(
            rootView: ContentView()
                .environmentObject(state)
        )
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openMainWindowFromNotification(_:)),
            name: .woodToolsOpenMainWindow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowSizeDidChange(_:)),
            name: .woodToolsWindowSizeDidChange,
            object: nil
        )
    }

    private func configureApplicationMenu() {
        let mainMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        let editMenuItem = NSMenuItem()

        mainMenu.addItem(appMenuItem)
        mainMenu.addItem(editMenuItem)

        let appMenu = NSMenu()
        appMenu.addItem(
            NSMenuItem(
                title: "退出 WoodTools",
                action: #selector(NSApplication.terminate(_:)),
                keyEquivalent: "q"
            )
        )
        appMenuItem.submenu = appMenu

        let editMenu = NSMenu(title: "编辑")
        editMenu.addItem(NSMenuItem(title: "撤销", action: Selector(("undo:")), keyEquivalent: "z"))
        editMenu.addItem(NSMenuItem(title: "重做", action: Selector(("redo:")), keyEquivalent: "Z"))
        editMenu.addItem(.separator())
        editMenu.addItem(NSMenuItem(title: "剪切", action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
        editMenu.addItem(NSMenuItem(title: "复制", action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
        editMenu.addItem(NSMenuItem(title: "粘贴", action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
        editMenu.addItem(NSMenuItem(title: "全选", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))
        editMenuItem.submenu = editMenu

        NSApp.mainMenu = mainMenu
    }

    @objc private func togglePopover(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else {
            showPopover(sender)
            return
        }

        if event.type == .rightMouseUp {
            showStatusMenu(sender)
            return
        }

        showPopover(sender)
    }

    private func showPopover(_ sender: NSStatusBarButton) {
        if popover.isShown {
            popover.performClose(sender)
            return
        }

        updatePopoverSize()
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func showStatusMenu(_ sender: NSStatusBarButton) {
        popover.performClose(sender)

        let menu = NSMenu()
        let openItem = NSMenuItem(title: state.localized("打开 WoodTools", "Open WoodTools"), action: #selector(openFromMenu(_:)), keyEquivalent: "")
        openItem.target = self
        menu.addItem(openItem)
        let windowItem = NSMenuItem(title: state.localized("以窗口打开", "Open as Window"), action: #selector(openWindowFromMenu(_:)), keyEquivalent: "")
        windowItem.target = self
        menu.addItem(windowItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: state.localized("退出 WoodTools", "Quit WoodTools"), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem?.menu = menu
        sender.performClick(nil)
        statusItem?.menu = nil
    }

    @objc private func openFromMenu(_ sender: NSMenuItem) {
        guard let button = statusItem?.button else {
            return
        }
        showPopover(button)
    }

    @objc private func openWindowFromMenu(_ sender: NSMenuItem) {
        openMainWindow()
    }

    @objc private func openMainWindowFromNotification(_ notification: Notification) {
        openMainWindow()
    }

    @objc private func windowSizeDidChange(_ notification: Notification) {
        updatePopoverSize()
        guard mainWindow?.isVisible == true else {
            return
        }
        mainWindow?.setContentSize(NSSize(width: state.settings.popoverWidth, height: state.settings.popoverHeight))
    }

    private func openMainWindow() {
        popover.performClose(nil)
        NSApp.setActivationPolicy(.regular)
        let window = mainWindow ?? makeMainWindow()
        mainWindow = window
        window.setContentSize(NSSize(width: state.settings.popoverWidth, height: state.settings.popoverHeight))
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func makeMainWindow() -> NSWindow {
        let window = NSWindow(
            contentViewController: NSHostingController(
                rootView: ContentView()
                    .environmentObject(state)
            )
        )
        window.title = "WoodTools"
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.minSize = NSSize(width: WoodToolsState.popoverWidthRange.lowerBound, height: WoodToolsState.popoverHeightRange.lowerBound)
        window.maxSize = NSSize(width: 1200, height: 1000)
        window.collectionBehavior = [.fullScreenPrimary]
        window.isReleasedWhenClosed = false
        window.delegate = self
        return window
    }

    func windowWillClose(_ notification: Notification) {
        guard notification.object as? NSWindow === mainWindow else {
            return
        }
        NSApp.setActivationPolicy(.accessory)
    }

    private func updatePopoverSize() {
        popover.contentSize = NSSize(width: state.settings.popoverWidth, height: state.settings.popoverHeight)
    }

    private func menuBarImage() -> NSImage? {
        if let image = NSImage(named: "MenuBarTemplate") {
            image.size = NSSize(width: 20, height: 20)
            image.isTemplate = true
            return image
        }

        let fallback = NSImage(systemSymbolName: "tree", accessibilityDescription: "WoodTools")
        fallback?.size = NSSize(width: 20, height: 20)
        fallback?.isTemplate = true
        return fallback
    }
}
