module MyMain (main) where

import Language.Javascript.JSaddle 
import Language.Javascript.JSaddle.Wasm qualified as JSaddle.Wasm 
import Control.Lens((^.))

foreign export javascript "hs_start" main :: IO ()

main :: IO ()
main = JSaddle.Wasm.run $ do
    doc <- jsg ("document" :: JSString)
    doc ^. js ("body" :: JSString) ^. jss ("innerHTML" :: JSString) ("<h1>Hello world</h1>" :: JSString)
