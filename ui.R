fluidPage(
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
