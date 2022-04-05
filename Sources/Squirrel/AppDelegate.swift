import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

  var statusBarItem: NSStatusItem!
  var counter: Int = 0

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let statusBar = NSStatusBar.system
    statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
    statusBarItem.button?.title = "🌰 \(counter)"

    let statusBarMenu = NSMenu(title: "Counter Bar Menu")
    statusBarItem.menu = statusBarMenu

    statusBarMenu.addItem(
      withTitle: "Increase",
      action: #selector(AppDelegate.increaseCount),
      keyEquivalent: ""
    )

    statusBarMenu.addItem(
      withTitle: "Decrease",
      action: #selector(AppDelegate.decreaseCount),
      keyEquivalent: ""
    )
      
      statusBarMenu.addItem(
        withTitle: "Get public IP",
        action: #selector(AppDelegate.xpcCall),
        keyEquivalent: ""
      )
      
      statusBarMenu.addItem(
        withTitle: "Show Counter",
        action: #selector(AppDelegate.showCounter),
        keyEquivalent: ""
      )

    statusBarMenu.addItem(
      withTitle: "Quit",
      action: #selector(AppDelegate.quit),
      keyEquivalent: ""
    )
  }

  @objc private func showCounter() {
    statusBarItem.button?.title = "🌰 \(counter)"
  }
    
    @objc func xpcCall() {
        let connection = NSXPCConnection(serviceName: "com.rderik.ServiceProviderXPC")
        connection.remoteObjectInterface = NSXPCInterface(with: ServiceProviderXPCProtocol.self)
        connection.resume()
        
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Received error:", error)
        } as? ServiceProviderXPCProtocol
        
        service!.getPublicIp() { (texto) in
            DispatchQueue.main.async {
                self.statusBarItem.button?.title = "\(texto)"
            }
        }
    }

  @objc func increaseCount() {
    counter += 1
    showCounter()
  }

  @objc func decreaseCount() {
    counter -= 1
    showCounter()
  }

  @objc func quit() {
    NSApplication.shared.terminate(self)
  }
}
