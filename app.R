library(shiny)
library(Gmisc)
library(bitops)

ui <- fluidPage(
    mainPanel(
        tabsetPanel(
            tabPanel('ASCII',
                h4('This tool converts text to ASCII codes and vise versa.  It also has the side-effect of converting larger numbers between binary, decimal, and hexadecimal.  Remember to leave a space or colon (:) between the numbers that represent each character.   (i.e., group binary and hex numbers into groups of 8 and 2, respectively.)'),
                textAreaInput('asciiText', 'Text', '', rows=5, cols=80, width='auto'),
                actionButton('asciiEncode', 'Encode'),
                textAreaInput('asciiBin', 'Binary', '', rows=5, cols=80, width='auto'),
                actionButton('asciiDecodeBin', 'Decode'),
                textAreaInput('asciiDec', 'Decimal', '', rows=5, cols=80, width='auto'),
                actionButton('asciiDecodeDec', 'Decode'),
                textAreaInput('asciiHex', 'Hex', '', rows=5, cols=80, width='auto'),
                actionButton('asciiDecodeHex', 'Decode')
            ),
            tabPanel('Base64',
                h4('This tool converts text to Base64 and vise versa.'),
                textAreaInput('base64Text', 'Text', '', rows=5, cols=80, width='auto'),
                actionButton('base64Encode', 'Encode'),
                textAreaInput('base64Data', 'Base 64 Data', '', rows=5, cols=80, width='auto'),
                actionButton('base64Decode', 'Decode')
            ),
            tabPanel('QR',
                h4('This tool decodes a string of QR alphanumeric bits.'),
                textAreaInput('qrData', 'QR Alphanumeric Bits', '', rows=5, cols=80, width='auto'),
                actionButton('qrDecode', 'Decode'),
                textAreaInput('qrText', 'Text', '', rows=5, cols=80, width='auto'),
                actionButton('qrEncode', 'Encode')
            ),
            tabPanel('XOR',
                h4('This tool performs bitwise XOR of two strings of 1s and 0s, ignoring spaces.'),
                textAreaInput('xorA', 'A', '', rows=6, cols=80, width='auto'),
                textAreaInput('xorB', 'B', '', rows=6, cols=80, width='auto'),
                textAreaInput('xorResult', 'Result', '', rows=6, cols=80, width='auto'),
                actionButton('xor', 'XOR')
            ),
            tabPanel('Mongo ID',
                h4('This tool decodes and encodes the timestamp portion of Mongo database IDs.'),
                textInput('mongoID', 'Mongo ID', '000000000123456789abcdef'),
                actionButton('decodeMongo', 'Decode'),
                textInput('mongoDatetime', 'Date (YYYY-MM-DD HH:MM:SS)', '1970-01-01'),
                textInput('mongoRest', 'the rest (16 characters)', '0123456789abcdef'),
                actionButton('encodeMongo', 'Encode'),
                h5('Note: all dates and times are UTC.')
            )
        )
    )
)

server <- function(input, output, session) {
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
}

shinyApp(ui=ui, server=server)
