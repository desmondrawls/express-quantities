
module Main where

import Prelude hiding (apply)
import Effect (Effect)
import Effect.Console (log)
import Node.Express.App (App, listenHttp, get)
import Node.Express.Handler (Handler)
import Node.Express.Request (getQueryParam)
import Node.Express.Response (sendJson)
import Node.Express.Response (send)
import Node.HTTP (Server)
import Quantities (quantities)

createTodoHandler :: Handler
createTodoHandler = do
  x <- getQueryParam "desc"
  sendJson {status: "OK", x}

app :: App
app = get "/" createTodoHandler

main :: Effect Server
main = do
    listenHttp app 8080 \_ ->
        log $ "Listening on " <> show 8080
