# get_weather_pl_hs

Creation of an HTTP Client in Prolog and Haskell language capable of obtaining weather information based on the Latitude and Longitude data inserted in Input, the service will use the APIs made available by OpenWeather


SWI-Prolog

https://www.haskell.org/ghcup/

cabal install --lib http-simple
cabal update && cabal new-install --lib parallel
stack install http-simple
stack install wreq
stack install --lib http-client-tls
