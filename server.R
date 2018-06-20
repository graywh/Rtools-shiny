library(shiny)
library(Gmisc)
library(bitops)

shinyServer(function(input, output, session) {
    # ASCII
    toX <- function(x, n) { if (length(x) > 0) { strrjust(baseConvert(x, n), log(256, n), '0') } else { '' } }
    toInts <- function(x, n) { baseConvert(strsplit(x, c(' ',':'))[[1]], 10, n) }

    asciiInts <- reactiveVal(c())
    observeEvent(input$asciiEncode, { asciiInts(as.integer(charToRaw(input$asciiText))) })
    observeEvent(input$asciiDecodeBin, { asciiInts(toInts(input$asciiBin, 2)) })
    observeEvent(input$asciiDecodeHex, { asciiInts(toInts(input$asciiHex, 16)) })
    observeEvent(input$asciiDecodeDec, { asciiInts(as.numeric(strsplit(input$asciiDec, c(' ',':'))[[1]])) })

    observe({
        updateTextAreaInput(session, 'asciiText', value=paste(rawToChar(as.raw(asciiInts())), collapse=''))
        updateTextAreaInput(session, 'asciiBin',  value=paste(toX(asciiInts(), 2), collapse=' '))
        updateTextAreaInput(session, 'asciiDec',  value=paste(asciiInts(), collapse=' '))
        updateTextAreaInput(session, 'asciiHex',  value=paste(toX(asciiInts(), 16), collapse=' '))
    })

    # Base 64
    observeEvent(input$base64Encode, { updateTextAreaInput(session, 'base64Data', value=as.vector(encode64(input$base64Text))) })
    observeEvent(input$base64Decode, { updateTextAreaInput(session, 'base64Text', value=as.vector(decode64(input$base64Data))) })

    # QR
    observeEvent(input$qrDecode, { updateTextAreaInput(session, 'qrText', value=as.vector(decodeQR(input$qrData))) })
    observeEvent(input$qrEncode, { updateTextAreaInput(session, 'qrData', value=as.vector(encodeQR(input$qrText))) })

    # XOR
    observeEvent(input$xor, {
        a <- strsplit(gsub('[^01 :]', '', gsub('[ ]*$', '', gsub('[\r\n:]+', ' ', input$xorA))), ' ')[[1]]
        b <- strsplit(gsub('[^01 :]', '', gsub('[ ]*$', '', gsub('[\r\n:]+', ' ', input$xorB))), ' ')[[1]]
        l <- pmax(nchar(a), nchar(b))
        a <- baseConvert(a, 10, 2)
        b <- baseConvert(b, 10, 2)
        x <- bitXor(a, b)
        r <- if (length(x) > 0) {
            paste0(strrjust(baseConvert(x, 2), l, '0'), collapse=' ')
        } else { '' }
        updateTextAreaInput(session, 'xorResult', value=r)
    })

    # Mongo ID
    observeEvent(input$decodeMongo, {
        updateTextInput(session, 'mongoDatetime', value=format(as.POSIXct(strtoi(substr(input$mongoID, 1, 8), 16), tz='UTC', origin='1970-01-01')))
        updateTextInput(session, 'mongoRest', value=substr(input$mongoID, 9, 24))
    })
    observeEvent(input$encodeMongo, {
        updateTextInput(session, 'mongoID', value=paste0(format(as.hexmode(as.integer(as.POSIXct(input$mongoDatetime, tz='UTC'))), width=8), input$mongoRest))
    })
})
