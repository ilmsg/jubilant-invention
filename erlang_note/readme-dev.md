
##### refer: https://www.youtube.com/watch?v=cASS3R-SAgs&list=PLdOYTlKwc71ljrfUqrKYoULxRjqI0p8it

##### รัน interactive cli

    $ erl
    $ 2 + 2 .

##### สร้างไพล์

    $ touch hello.erl

#### hello.erl source code 

    -module(hello).
    -export([start/0]).

    start() ->
        io:format("Hello World\n").

##### รัน hello ใน cli

    $ erl
    $ 1> c(hello).
    {ok,hello}

    $ 2> hello:start() .

##### compile hello.erl

    $ erlc hello.erl

##### รัน hello.beam
    
    $ erl -noshell -s hello start -s init stop

