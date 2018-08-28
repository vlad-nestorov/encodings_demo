# encodings_demo
Powershell script to demonstrate encodings and translation, with sample input files.

This shows how to correctly translate one encoding to another. It also demonstrates how interpreting different encodings affects the result. 

# Resources
- [Great explanation of encoding and unicode](https://betterexplained.com/articles/unicode/)
- [Succinct explanation of UTF8 and UTF16](https://www.fileformat.info/info/unicode/utf8.htm)
- [Full UTF8 table](https://www.fileformat.info/info/charset/UTF-8/list.htm)


# Usage

## Generate output
1. Place .txt files in the Samples folder
2. Run EncodingDemo.ps1

## Reading the output
**file**  the sample file name.  
**encoding** What encoding was the file interpreted with  
**value** The file's contents as interpreted with the specified encoding  
**== Operator** - comparison with == operator returns true  
**String.Equals** - comparison with String.Equals function returns true  

Notes: 
- To figure out the exact contents of the file, look at the Bytes encoding. This is a HEX representation.
- A single Unicode codepoint can be stored in multiple bytes. To avoid ambiguity between little-endian and big-endian systems, the Unicode standard has a byte order mark character (BOM).
- A UTF8 + BOM file read as a string in .NET will include the BOM character at the beginning of the string. Using the string comparison operator will ignore BOM, however string.Equals compares the pointers to the objects instead.


## Included samples
All sample files contain a single character: [Á (U+00C1)](https://www.fileformat.info/info/unicode/char/00c1/index.htm). Up to [U+007F](https://www.fileformat.info/info/unicode/char/007F/index.htm) Windows-1252 and UTF8 encodings will produce the same result. Because it is larger than U+007F, U+00C1 gets encoded in 2 bytes by UTF8, and only one byte by Windows-1252.


file         | encoding
----         | --------
ASCII.txt    | Windows-1252
UTF8.txt     | utf-8
UTF8-BOM.txt | utf-8

## Sample output
file         | encoding     | value          | == Operator                                    | String.Equals
----         | --------     | -----          | -----------                                    | -------------
ASCII.txt    | Bytes        | C1 ||
ASCII.txt    | us-ascii     | ?              | {}                                             | {}
ASCII.txt    | utf-8        | �              | {}                                             | {}
ASCII.txt    | Windows-1252 | Á              | {UTF8-BOM.txt(utf-8), | UTF8.txt(utf-8)}         | {UTF8.txt(utf-8)}
UTF8.txt     | Bytes        | C3-81 ||
UTF8.txt     | us-ascii     | ??             | {}                                             | {}
UTF8.txt     | utf-8        | Á              | {ASCII.txt(Windows-1252), | UTF8-BOM.txt(utf-8)} | {ASCII.txt(Windows-1252)}
UTF8.txt     | Windows-1252 | Ã             | {}                                             | {}
UTF8-BOM.txt | Bytes        | EF-BB-BF-C3-81 ||
UTF8-BOM.txt | us-ascii     | ?????          | {}                                             | {}
UTF8-BOM.txt | utf-8        | ﻿Á             | {ASCII.txt(Windows-1252), | UTF8.txt(utf-8)}     | {}
UTF8-BOM.txt | Windows-1252 | ï»¿Ã          | {}                                             | {}