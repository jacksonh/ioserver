WebRequest := Object clone do(
    handleSocket := method(aSocket,
        aSocket streamReadNextChunk
        path := aSocket readBuffer betweenSeq("GET ", " HTTP") prependSeq(".")
        path = if(path == "./", "./index.html", path)
        f := File with(path)
        path println
        if(f exists,
            aSocket streamWrite("HTTP/1.1 200 OK\n\n"); f streamTo(aSocket),
            aSocket streamWrite("HTTP/1.1 404 Not Found\n\nNot Found\n")
        )
        aSocket close
    )
)

WebServer := Server clone do(
    setPort(8000)
    handleSocket := method(aSocket, 
        WebRequest clone asyncSend(handleSocket(aSocket))
    )
)

WebServer start

