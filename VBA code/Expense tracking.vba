Sub balance()

Dim amount As Double
Dim paid_by As String
Dim paid_for As String
Dim status As String
Dim first As String
Dim second As String
Dim third As String
Dim fourth As String
Dim fifth As String

Dim farooq_balance As Double
Dim hassan_balance As Double
Dim manya_balance As Double
Dim sahad_balance As Double
Dim farhud_balance As Double

Dim counter As Integer
Dim i As Integer

i = 2

Range("N2:N1000").Value = ""
Range("O2:O1000").Value = ""
Range("P2:P1000").Value = ""
Range("Q2:Q1000").Value = ""
Range("R2:R1000").Value = ""
Range("S2:S1000").Value = ""

For counter = 0 To 1000

If Cells(counter + 1, 8) <> "" Then

amount = Range("E2").Offset(counter, 0).Value
paid_by = Range("F2").Offset(counter, 0).Value
paid_for = Range("G2").Offset(counter, 0).Value
status = Range("H2").Offset(counter, 0).Value
first = Range("I2").Offset(counter, 0).Value
second = Range("J2").Offset(counter, 0).Value
third = Range("K2").Offset(counter, 0).Value
fourth = Range("L2").Offset(counter, 0).Value
fifth = Range("M2").Offset(counter, 0).Value

If status = "Pending" Then
    If paid_by = "Ammar" Then
        If paid_for = "Farooq" Then
            farooq_balance = farooq_balance + amount
        ElseIf paid_for = "Hassan" Then
            hassan_balance = hassan_balance + amount
        ElseIf paid_for = "Manya" Then
            manya_balance = manya_balance + amount
        ElseIf paid_for = "Sahad" Then
            sahad_balance = sahad_balance + amount
        ElseIf paid_for = "Farhud" Then
            farhud_balance = farhud_balance + amount
        ElseIf paid_for = "Multiple x2" Then
            If first = "Ammar" Then
                If second = "Farooq" Then
                    farooq_balance = farooq_balance + (amount / 2)
                ElseIf second = "Hassan" Then
                    hassan_balance = hassan_balance + (amount / 2)
                ElseIf second = "Manya" Then
                    manya_balance = manya_balance + (amount / 2)
                ElseIf second = "Sahad" Then
                    sahad_balance = sahad_balance + (amount / 2)
                ElseIf second = "Farhud" Then
                    farhud_balance = farhud_balance + (amount / 2)
                'Else: other_balance = other_balance + (amount / 2)
                End If
            End If
        ElseIf paid_for = "Multiple x3" Then
            If first = "Ammar" Then
                If second = "Farooq" Or third = "Farooq" Then
                    farooq_balance = farooq_balance + (amount / 3)
                End If
                If second = "Hassan" Or third = "Hassan" Then
                    hassan_balance = hassan_balance + (amount / 3)
                End If
                If second = "Manya" Or third = "Manya" Then
                    manya_balance = manya_balance + (amount / 3)
                End If
                If second = "Sahad" Or third = "Sahad" Then
                    sahad_balance = sahad_balance + (amount / 3)
                End If
                If second = "Farhud" Or third = "Farhud" Then
                    farhud_balance = farhud_balance + (amount / 3)
                'Else: other_balance = other_balance + (amount / 3)
                End If
            End If
        ElseIf paid_for = "Multiple x4" Then
            If first = "Ammar" Then
                If second = "Farooq" Or third = "Farooq" Or fourth = "Farooq" Then
                    farooq_balance = farooq_balance + (amount / 4)
                End If
                If second = "Hassan" Or third = "Hassan" Or fourth = "Hassan" Then
                    hassan_balance = hassan_balance + (amount / 4)
                End If
                If second = "Manya" Or third = "Manya" Or fourth = "Manya" Then
                    manya_balance = manya_balance + (amount / 4)
                End If
                If second = "Sahad" Or third = "Sahad" Or fourth = "Sahad" Then
                    sahad_balance = sahad_balance + (amount / 4)
                End If
                If second = "Farhud" Or third = "Farhud" Or fourth = "Farhud" Then
                    farhud_balance = farhud_balance + (amount / 4)
                End If
            End If
        ElseIf paid_for = "Multiple x5" Then
            If first = "Ammar" Then
                If second = "Farooq" Or third = "Farooq" Or fourth = "Farooq" Or fifth = "Farooq" Then
                    farooq_balance = farooq_balance + (amount / 5)
                End If
                If second = "Hassan" Or third = "Hassan" Or fourth = "Hassan" Or fifth = "Hassan" Then
                    hassan_balance = hassan_balance + (amount / 5)
                End If
                If second = "Manya" Or third = "Manya" Or fourth = "Manya" Or fifth = "Manya" Then
                    manya_balance = manya_balance + (amount / 5)
                End If
                If second = "Sahad" Or third = "Sahad" Or fourth = "Sahad" Or fifth = "Sahad" Then
                    sahad_balance = sahad_balance + (amount / 5)
                End If
                If second = "Farhud" Or third = "Farhud" Or fourth = "Farhud" Or fifth = "Farhud" Then
                    farhud_balance = farhud_balance + (amount / 5)
                End If
            End If
        End If
    ElseIf paid_by = "Farooq" Then
        If paid_for = "Ammar" Then
            farooq_balance = farooq_balance - amount
        ElseIf paid_for = "Multiple x2" And first = "Ammar" Then
            farooq_balance = farooq_balance - (amount / 2)
        ElseIf paid_for = "Multiple x3" And first = "Ammar" Then
            farooq_balance = farooq_balance - (amount / 3)
        ElseIf paid_for = "Multiple x4" And first = "Ammar" Then
            farooq_balance = farooq_balance - (amount / 4)
        ElseIf paid_for = "Multiple x5" And first = "Ammar" Then
            farooq_balance = farooq_balance - (amount / 5)
        End If
    'End If
    ElseIf paid_by = "Hassan" Then
        If paid_for = "Ammar" Then
            hassan_balance = hassan_balance - amount
        ElseIf paid_for = "Multiple x2" And first = "Ammar" Then
            hassan_balance = hassan_balance - (amount / 2)
        ElseIf paid_for = "Multiple x3" And first = "Ammar" Then
            hassan_balance = hassan_balance - (amount / 3)
        ElseIf paid_for = "Multiple x4" And first = "Ammar" Then
            hassan_balance = hassan_balance - (amount / 4)
        ElseIf paid_for = "Multiple x5" And first = "Ammar" Then
            hassan_balance = hassan_balance - (amount / 5)
        End If
    'End If
    ElseIf paid_by = "Manya" Then
        If paid_for = "Ammar" Then
            manya_balance = manya_balance - amount
        ElseIf paid_for = "Multiple x2" And first = "Ammar" Then
            manya_balance = manya_balance - (amount / 2)
        ElseIf paid_for = "Multiple x3" And first = "Ammar" Then
            manya_balance = manya_balance - (amount / 3)
        ElseIf paid_for = "Multiple x4" And first = "Ammar" Then
            manya_balance = manya_balance - (amount / 4)
        ElseIf paid_for = "Multiple x5" And first = "Ammar" Then
            manya_balance = manya_balance - (amount / 5)
        End If
    'End If
    ElseIf paid_by = "Sahad" Then
        If paid_for = "Ammar" Then
            sahad_balance = sahad_balance - amount
        ElseIf paid_for = "Multiple x2" And first = "Ammar" Then
            sahad_balance = sahad_balance - (amount / 2)
        ElseIf paid_for = "Multiple x3" And first = "Ammar" Then
            sahad_balance = sahad_balance - (amount / 3)
        ElseIf paid_for = "Multiple x4" And first = "Ammar" Then
            sahad_balance = sahad_balance - (amount / 4)
        ElseIf paid_for = "Multiple x5" And first = "Ammar" Then
            sahad_balance = sahad_balance - (amount / 5)
        End If
    'End If
    ElseIf paid_by = "Farhud" Then
        If paid_for = "Ammar" Then
            farhud_balance = farhud_balance - amount
        ElseIf paid_for = "Multiple x2" And first = "Ammar" Then
            farhud_balance = farhud_balance - (amount / 2)
        ElseIf paid_for = "Multiple x3" And first = "Ammar" Then
            farhud_balance = farhud_balance - (amount / 3)
        ElseIf paid_for = "Multiple x4" And first = "Ammar" Then
            farhud_balance = farhud_balance - (amount / 4)
        ElseIf paid_for = "Multiple x5" And first = "Ammar" Then
            farhud_balance = farhud_balance - (amount / 5)
        End If
    End If
End If

If status = "Pending" Or status = "Cleared" Or status = "N/A" Then
    Range("N2").Offset(counter, 0).Value = farooq_balance
    Range("O2").Offset(counter, 0).Value = hassan_balance
    Range("P2").Offset(counter, 0).Value = manya_balance
    Range("Q2").Offset(counter, 0).Value = sahad_balance
    Range("R2").Offset(counter, 0).Value = farhud_balance
Else:
    Range("N2").Offset(counter, 0).Value = ""
    Range("O2").Offset(counter, 0).Value = ""
    Range("P2").Offset(counter, 0).Value = ""
    Range("Q2").Offset(counter, 0).Value = ""
    Range("R2").Offset(counter, 0).Value = ""
End If

If paid_by <> "Ammar" And status = "Pending" And paid_by <> "Farooq" And paid_by <> "Hassan" And paid_by <> "Manya" And paid_by <> "Sahad" And paid_by <> "Farhud" And first = "Ammar" Then
    Range("S2").Offset(counter, 0).Value = "PAY UP"
ElseIf paid_by = "Ammar" And status = "Pending" And paid_for <> "Farooq" And paid_for <> "Hassan" And paid_for <> "Manya" And paid_for <> "Sahad" And paid_for <> "Farhud" And paid_for <> "Multiple x2" And paid_for <> "Multiple x3" And paid_for <> "Multiple x4" And paid_for <> "Multiple x5" Then
    Range("S2").Offset(counter, 0).Value = "TAKE"
ElseIf paid_by = "Ammar" And status = "Pending" And paid_for = "Multiple x2" And second <> "Farooq" And second <> "Hassan" And second <> "Manya" And second <> "Sahad" And second <> "Farhud" Then
    Range("S2").Offset(counter, 0).Value = "TAKE"
ElseIf paid_by = "Ammar" And status = "Pending" And paid_for = "Multiple x3" Then
    If second <> "Farooq" And second <> "Hassan" And second <> "Manya" And second <> "Sahad" And second <> "Farhud" Then
        Range("S2").Offset(counter, 0).Value = "TAKE"
    ElseIf third <> "Farooq" And third <> "Hassan" And third <> "Manya" And third <> "Sahad" And third <> "Farhud" Then
        Range("S2").Offset(counter, 0).Value = "TAKE"
    End If
ElseIf paid_by = "Ammar" And paid_for = "Multiple x4" Then
    If second <> "Farooq" And second <> "Hassan" And second <> "Manya" And second <> "Sahad" And second <> "Farhud" Then
        Range("S2").Offset(counter, 0).Value = "TAKE"
    ElseIf third <> "Farooq" And third <> "Hassan" And third <> "Manya" And third <> "Sahad" And third <> "Farhud" Then
        Range("S2").Offset(counter, 0).Value = "TAKE"
    ElseIf fourth <> "Farooq" And fourth <> "Hassan" And fourth <> "Manya" And fourth <> "Sahad" And fourth <> "Farhud" Then
        Range("S2").Offset(counter, 0).Value = "TAKE"
    End If
ElseIf paid_by = "Ammar" And paid_for = "Multiple x5" Then
    If second <> "Farooq" And second <> "Hassan" And second <> "Manya" And second <> "Sahad" And second <> "Farhud" Then
        Range("S2").Offset(counter, 0).Value = "TAKE"
    ElseIf third <> "Farooq" And third <> "Hassan" And third <> "Manya" And third <> "Sahad" And third <> "Farhud" Then
        Range("S2").Offset(counter, 0).Value = "TAKE"
    ElseIf fourth <> "Farooq" And fourth <> "Hassan" And fourth <> "Manya" And fourth <> "Sahad" And fourth <> "Farhud" Then
        Range("S2").Offset(counter, 0).Value = "TAKE"
    ElseIf fifth <> "Farooq" And fifth <> "Hassan" And fifth <> "Manya" And fifth <> "Sahad" And fifth <> "Farhud" Then
        Range("S2").Offset(counter, 0).Value = "TAKE"
    End If
End If

End If

Next counter

End Sub

