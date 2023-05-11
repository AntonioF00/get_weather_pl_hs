
:- dynamic latitudine/1, longitudine/1, url/1.

inizializza_lat_lon(Latitudine, Longitudine) :-
    assertz(latitudine(Latitudine)),
    assertz(longitudine(Longitudine)).

crea_url :-
    latitudine(Lat),
    longitudine(Lon),
    atom_concat('https://api.openweathermap.org/data/2.5/weather?lat=', Lat, Url1),
    atom_concat(Url1,'&lon=',Url2),
    atom_concat(Url2,Lon,Url3),
    atom_concat(Url3,'&appid=9525a467ef22974bc25346d4bc02de69',Url),
    assertz(url(Url)).

:- use_module(library(http/http_client)).

calcola_meteo() :-
    url(Url),
    http_get(Url, Response, []),
    atom_codes(Data, Response),
    write(Data).

%%test

%%1
%| ?- inizializza_lat_lon('45.46', '9.19').
%yes

%| ?- crea_url.
%yes

%| ?- calcola_meteo.
%{ "coord": { "lon": 9.19, "lat": 45.46 }, "weather": [ { "id": 802, "main": "Clouds", "description": "scattered clouds", "icon": "03d" } ], "base": "stations", "main": { "temp": 290.95, "feels_like": 290.6, "temp_min": 289.45, "temp_max": 292.46, "pressure": 1020, "humidity": 66 }, "visibility": 10000, "wind": { "speed": 1.34, "deg": 160 }, "clouds": { "all": 44 }, "dt": 1651727253, "sys": { "type": 2, "id": 2009385, "country": "IT", "sunrise": 1651695405, "sunset": 1651748492 }, "timezone": 7200


%%2

%?- inizializza_lat_lon('45.4642', '9.1900').
%true.

%?- crea_url.
%true.

%?- calcola_meteo.
%{ "coord":{ "lon":9.19, "lat":45.4642 }, "weather":[ { "id":800, "main":"Clear", "description":"clear sky", "icon":"01d" } ], "base":"stations", "main":{ "temp":292.87, "feels_like":291.52, "temp_min":291.15, "temp_max":294.59, "pressure":1012, "humidity":43 }, "visibility":10000, "wind":{ "speed":2.06, "deg":120 }, "clouds":{ "all":0 }, "dt":1620814447, "sys":{ "type":2, "id":2014603, "country":"IT", "sunrise":1620786364, "sunset":1620842344 }, "timezone":7200, "id":3169070, "name":"Milan", "cod":200 }
%true.
