{-# LANGUAGE OverloadedStrings #-}

import Network.HTTP.Conduit (simpleHttp)
import qualified Data.ByteString.Lazy.Char8 as L

concatenaStringhe :: String -> String -> String
concatenaStringhe stringa1 stringa2 = stringa1 ++ stringa2

main :: IO ()
main = do
    putStrLn "Inserisci la Latitudine:"
    latitudine <- getLine
    putStrLn "Inserisci la Longitudine:"
    longitudine <- getLine
    putStrLn $ "Hai inserito: " ++ latitudine ++ " e " ++ longitudine
    let stringa1 = "https://api.openweathermap.org/data/2.5/weather?lat="
        stringa2 = "&lon="
        stringa3 = "&appid=9525a467ef22974bc25346d4bc02de69"
        stringaConcatenata = concatenaStringhe (concatenaStringhe stringa1 latitudine) (concatenaStringhe stringa2 longitudine ++ stringa3)
    response <- simpleHttp stringaConcatenata
    L.putStrLn response
