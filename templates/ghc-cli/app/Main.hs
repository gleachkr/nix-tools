module Main (main) where

import Data.Text (Text)
import Data.Text.IO qualified as Text
import Data.Void (Void)
import System.Exit (exitFailure)
import System.IO (hPutStr, stderr)
import Text.Megaparsec (Parsec, eof, errorBundlePretty, parse, sepEndBy)
import Text.Megaparsec.Char (space, space1)
import Text.Megaparsec.Char.Lexer qualified as Lexer

type Parser = Parsec Void Text

-- A small example grammar: signed integers separated by whitespace.
integers :: Parser [Integer]
integers = space *> (integer `sepEndBy` space1) <* eof
  where
    integer = Lexer.signed (pure ()) Lexer.decimal

main :: IO ()
main = do
  input <- Text.getContents
  case parse integers "<stdin>" input of
    Left err -> hPutStr stderr (errorBundlePretty err) >> exitFailure
    Right values -> print (sum values)
