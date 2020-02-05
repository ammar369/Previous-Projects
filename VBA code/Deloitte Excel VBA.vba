'code written and owned by Ammar Rehan
'for any queries contact ammar.rehan369@gmail.com
Sub import_data()

'----------instantiating variables-------------
Dim file_name As String
Dim username As String
Dim email As String

Dim user_input As String
Dim path_name As String
Dim extension As String
Dim file_path As String

Dim textline As String
Dim comma_pos As Integer
Dim dot_pos As Integer
Dim length As Integer
Dim counter As Integer
'------------------------------------------------
'----------------set up--------------------------
counter = 0 'instantiate counter as 0
user_input = InputBox(Prompt:="Enter folder directory", Title:="Hello Bhav/Ana") 'prompts user for input of folder directory that contains all files
path_name = user_input & "\" 'adds \ so folder can be referenced
extension = "*.txt" 'file type of files within folder directory we are looking for

file_name = Dir(path_name & extension, vbNormal) 'gets name of first file
file_path = path_name & file_name 'file path for first file is determined
'------------------------------------------------
'=================================CODE START=====================================
Do Until file_name = "" 'runs until no new file
    Open file_path For Input As #1 'file is opened
    '----------------prints results for one text file--------------------------
        Do Until EOF(1) 'runs until end of file reached
        '----------determines username and email from a one line---------------
        Line Input #1, textline 'this gets first line of text file
        length = Len(textline) 'this gets the length of the line
        If length > 3 Then 'checks if line is empty and skips it if so
            comma_pos = InStr(textline, ",") 'checks for comma in text line, returns position of comma or 0 if no comma found
            If comma_pos = 0 Then 'case if there is no comma in text line
                dot_pos = InStr(textline, ".com") 'checks for '.com' in the text line
                If dot_pos = 0 Then 'case if there is no '.com' in text line
                    username = textline 'we assume only username is given
                Else 'case if there is '.com' in text line
                    email = textline 'we assume only email is given
                End If
            Else 'case if there is a comma in text line
                username = Left(textline, comma_pos - 1) 'text to the left of the comma is the username
                email = Right(textline, length - comma_pos) 'text to the right of the comma is the email
            End If
        '------------------------------------------------------------------------
            Range("A2").Offset(counter, 0).Value = file_name 'prints file name in column A
            Range("B2").Offset(counter, 0).Value = username 'prints username in column B
            Range("C2").Offset(counter, 0).Value = email 'prints email in column C
            counter = counter + 1 'increments counter to write to next row in worksheet
        End If 'all above computes if line is not empty
        username = "" 'username is reset
        email = "" 'email is reset
        Loop 'moves to next line
    '----------------------------------------------------------------------------
Close #1 'file is closed
file_name = Dir 'sets new file name
file_path = path_name & file_name 'new file path is determined
Loop 'moves to new file
'=================================CODE END=====================================
MsgBox "Hope you have a good day :)"
End Sub


