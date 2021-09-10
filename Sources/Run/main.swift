import App
import Vapor

// What's our environment?
var env = try Environment.detect()
// Setup logging
try LoggingSystem.bootstrap(from: &env)
// Create our App
let app = Application(env)
// Always shutdown app upon scope exit
defer { app.shutdown() }
// Try to configure app (can throw error that defer shuts down)
try configure(app)
// Try to run app (can throw error that defer shuts down)
try app.run()
