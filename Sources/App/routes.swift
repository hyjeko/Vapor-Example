import Vapor

let DEFAULT_MESSAGE = "It works!"

func routes(_ app: Application) throws {
    /* 
     Path Component

     Each route registration method accepts a variadic list of PathComponent. 
     This type is expressible by string literal and has four cases:
    */

    // 1.  Constant (foo)
    // responds to GET /foo/bar/baz
    app.get("foo", "bar", "baz") { req in
        return DEFAULT_MESSAGE
        // req.redirect(to: "/some/new/path", type: .permanent)
    }

    // 2. Parameter (:foo)
    // responds to GET /hello/:x
    app.get("hello", ":name") { req -> String in 
        let name = req.parameters.get("name")! // ?? "world"
        return "Hello, \(name)"
    }.description("says hello") // meta data

    // 3. Anything (*) This is very similar to parameter except the value is discarded
    // responds to GET /foo/:x/baz
    app.get("foo", "*", "baz") { req in
        return DEFAULT_MESSAGE
    }

    // 4. Catchall (**) 
    // responds to GET /foo/bar/baz/biz
    app.get("foo", "**") { req in 
        return DEFAULT_MESSAGE
    }

    // responds to GET /hola/amiga/anything/else
    app.get("hola", "**") { req -> String in
        let name = req.parameters.getCatchall().joined(separator: " ")
        return "Hello, \(name)!"
    }

    // LosslessStringConvertible example
    // responds to GET /number/42
    // responds to GET /number/1337
    // ...
    app.get("number", ":x") { req -> String in 
        guard let int = req.parameters.get("x", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "\(int) is a great number"
    }

    // Grouping, Nesting, Organizing
    let omie = app.grouped("omie") // also supports a closure syntax

    // CRUD examples
    omie.post() { req in 
        return DEFAULT_MESSAGE
    }
    omie.patch() { req in
        return DEFAULT_MESSAGE
    }
    omie.put() { req in 
        return DEFAULT_MESSAGE
    }
    omie.delete() { req in 
        return DEFAULT_MESSAGE
    }
    // Specify HTTP method as input parameter for everything else
    omie.on(.OPTIONS) { req in 
        return DEFAULT_MESSAGE
    }

    // Possible group example (notice optional parens)
    app.group("users") { users in
        // GET /users
        users.get { req in
            return DEFAULT_MESSAGE
        }
        // POST /users
        users.post { req in
            return DEFAULT_MESSAGE
        }
        users.group(":id") { user in
            // GET /users/:id
            user.get { req in
                return DEFAULT_MESSAGE
            }
            // PATCH /users/:id
            user.patch { req in
                return DEFAULT_MESSAGE
            }
            // PUT /users/:id
            user.put { req in
                return DEFAULT_MESSAGE
            }
        }
    }
}
