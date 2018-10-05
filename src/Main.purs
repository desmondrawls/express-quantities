
module Main where

import Prelude hiding (apply)
import Effect (Effect)
import Foreign (renderForeignError)
import Effect.Console (log)
import Data.Tuple
import Data.Array
import Data.Maybe
import Data.Either
import Node.Express.App (App, listenHttp, post, get, use, useExternal)
import Node.Express.Handler (Handler)
import Node.Express.Middleware.Static
import Node.Express.Request (getBodyParam, getQueryParam, getBody)
import Node.Express.Response (send, sendJson, setStatus, setResponseHeader)
import Node.HTTP (Server)
import Quantities (quantities)
import Quantities.BodyParser (jsonBodyParser)
import Oak.Cmd.Http.Conversion (defaultDecode, defaultEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Foreign.Class (class Decode, class Encode)
import Data.Function.Uncurried (Fn1, runFn1)
import Quantities.Models

foreign import staticPath ::  Fn1 String String

createTodoHandler :: Handler
createTodoHandler = do
    padding <- getBodyParam "padding"
    size <- getBodyParam "size"
    limit <- getBodyParam "limit"
    randomness <- getBodyParam "randomness"
    centers <- getBodyParam "centers"
    sendJson {quantities: (maybeQuantities size padding limit randomness centers)}

respond :: Maybe TransportModel -> Handler
respond (Just t) = sendJson t
respond _ = sendJson {x: "failed"}

maybes :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int -> String
maybes (Just size) (Just padding) (Just limit) (Just randomness)
    = show {size, padding, limit, randomness}
maybes _ _ _ _ = "nope"

maybeQuantities :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int -> Maybe (Centers (Array Center)) -> (Centers (Array Center))
maybeQuantities (Just size) (Just padding) (Just limit) (Just randomness) (Just (Centers centers))
    = (Centers $ quantities {size, padding, limit, randomness} centers)
maybeQuantities _ _ _ _ _ = []

cors :: Handler
cors = do
  setResponseHeader "Access-Control-Allow-Origin" "*"
  setResponseHeader "Access-Control-Allow-Methods" "GET, POST, OPTIONS"
  setResponseHeader "Access-Control-Allow-Headers" "User-Agent, Origin, X-Requested-With, Content-Type, Accept"

app :: App
app = do
    use $ static $ (runFn1 staticPath) "public"
    useExternal jsonBodyParser
    post "/" createTodoHandler

main :: Effect Server
main = do
    listenHttp app 8080 \_ ->
        log $ "Listening on " <> show 8080

