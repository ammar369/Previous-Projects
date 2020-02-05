Sub account()

Dim category As String
Dim ty_pe As String
Dim amount As Double
Dim paid_by As String
Dim paid_for As String
Dim status As String
Dim first As String

Dim bill As Double
Dim grocery As Double
Dim dining As Double
Dim shopping As Double
Dim entertainment As Double
Dim recreation As Double
Dim allowance As Double
Dim travel As Double
Dim other As Double

Dim critical As Double
Dim essential As Double
Dim non_essential As Double
Dim luxury As Double
Dim adjustment As Double
Dim n_a As Double

Dim counter As Integer

Dim current_date As Date
Dim start_date As Date
Dim end_date As Date

start_date = Range("V1").Value
end_date = Range("V2").Value

For counter = 0 To 100

current_date = Range("A2").Offset(counter, 0).Value
category = Range("B2").Offset(counter, 0).Value
ty_pe = Range("C2").Offset(counter, 0).Value
amount = Range("E2").Offset(counter, 0).Value
paid_by = Range("F2").Offset(counter, 0).Value
paid_for = Range("G2").Offset(counter, 0).Value
status = Range("H2").Offset(counter, 0).Value
first = Range("I2").Offset(counter, 0).Value

If current_date >= start_date And current_date <= end_date Then

If paid_for = "Ammar" Then

    Select Case ty_pe
    Case "Bill"
        bill = bill + amount
    Case "Grocery"
        grocery = grocery + amount
    Case "Dining"
        dining = dining + amount
    Case "Shopping"
        shopping = shopping + amount
    Case "Entertainment"
        entertainment = entertainment + amount
    Case "Recreation"
        recreation = recreation + amount
    Case "Allowance"
        allowance = allowance + amount
    Case "Travel"
        travel = travel + amount
    Case "Other"
        other = other + amount
    End Select
    
    Select Case category
    Case "Critical"
        critical = critical + amount
    Case "Essential"
        essential = essential + amount
    Case "Non-essential"
        non_essential = non_essential + amount
    Case "Luxury"
        luxury = luxury + amount
    Case "Adjustment"
        adjustment = adjustment + amount
    Case "N/A"
        n_a = n_a + amount
    End Select
    
ElseIf paid_for = "Multiple x2" And first = "Ammar" Then
    
    Select Case ty_pe
    Case "Bill"
        bill = bill + (amount / 2)
    Case "Grocery"
        grocery = grocery + (amount / 2)
    Case "Dining"
        dining = dining + amount / 2
    Case "Shopping"
        shopping = shopping + amount / 2
    Case "Entertainment"
        entertainment = entertainment + amount / 2
    Case "Recreation"
        recreation = recreation + amount / 2
    Case "Allowance"
        allowance = allowance + amount / 2
    Case "Travel"
        travel = travel + amount / 2
    Case "Other"
        other = other + amount / 2
    End Select
    
    Select Case category
    Case "Critical"
        critical = critical + amount / 2
    Case "Essential"
        essential = essential + amount / 2
    Case "Non-essential"
        non_essential = non_essential + amount / 2
    Case "Luxury"
        luxury = luxury + amount / 2
    Case "Adjustment"
        adjustment = adjustment + amount / 2
    Case "N/A"
        n_a = n_a + amount / 2
    End Select
    
ElseIf paid_for = "Multiple x3" And first = "Ammar" Then
    
    Select Case ty_pe
    Case "Bill"
        bill = bill + (amount / 3)
    Case "Grocery"
        grocery = grocery + (amount / 3)
    Case "Dining"
        dining = dining + amount / 3
    Case "Shopping"
        shopping = shopping + amount / 3
    Case "Entertainment"
        entertainment = entertainment + amount / 3
    Case "Recreation"
        recreation = recreation + amount / 3
    Case "Allowance"
        allowance = allowance + amount / 3
    Case "Travel"
        travel = travel + amount / 3
    Case "Other"
        other = other + amount / 3
    End Select
    
    Select Case category
    Case "Critical"
        critical = critical + amount / 3
    Case "Essential"
        essential = essential + amount / 3
    Case "Non-essential"
        non_essential = non_essential + amount / 3
    Case "Luxury"
        luxury = luxury + amount / 3
    Case "Adjustment"
        adjustment = adjustment + amount / 3
    Case "N/A"
        n_a = n_a + amount / 3
    End Select
    
ElseIf paid_for = "Multiple x4" And first = "Ammar" Then
    
    Select Case ty_pe
    Case "Bill"
        bill = bill + (amount / 4)
    Case "Grocery"
        grocery = grocery + (amount / 4)
    Case "Dining"
        dining = dining + amount / 4
    Case "Shopping"
        shopping = shopping + amount / 4
    Case "Entertainment"
        entertainment = entertainment + amount / 4
    Case "Recreation"
        recreation = recreation + amount / 4
    Case "Allowance"
        allowance = allowance + amount / 4
    Case "Travel"
        travel = travel + amount / 4
    Case "Other"
        other = other + amount / 4
    End Select
    
    Select Case category
    Case "Critical"
        critical = critical + amount / 4
    Case "Essential"
        essential = essential + amount / 4
    Case "Non-essential"
        non_essential = non_essential + amount / 4
    Case "Luxury"
        luxury = luxury + amount / 4
    Case "Adjustment"
        adjustment = adjustment + amount / 4
    Case "N/A"
        n_a = n_a + amount / 4
    End Select
    
ElseIf paid_for = "Multiple x5" And first = "Ammar" Then
    
    Select Case ty_pe
    Case "Bill"
        bill = bill + (amount / 5)
    Case "Grocery"
        grocery = grocery + (amount / 5)
    Case "Dining"
        dining = dining + amount / 5
    Case "Shopping"
        shopping = shopping + amount / 5
    Case "Entertainment"
        entertainment = entertainment + amount / 5
    Case "Recreation"
        recreation = recreation + amount / 5
    Case "Allowance"
        allowance = allowance + amount / 5
    Case "Travel"
        travel = travel + amount / 5
    Case "Other"
        other = other + amount / 5
    End Select
    
    Select Case category
    Case "Critical"
        critical = critical + amount / 5
    Case "Essential"
        essential = essential + amount / 5
    Case "Non-essential"
        non_essential = non_essential + amount / 5
    Case "Luxury"
        luxury = luxury + amount / 5
    Case "Adjustment"
        adjustment = adjustment + amount / 5
    Case "N/A"
        n_a = n_a + amount / 5
    End Select
    
End If
End If
Next counter

Range("V3").Value = bill
Range("V4").Value = grocery
Range("V5").Value = dining
Range("V6").Value = shopping
Range("V7").Value = entertainment
Range("V8").Value = recreation
Range("V9").Value = allowance
Range("V10").Value = travel
Range("V11").Value = other

Range("V13").Value = critical
Range("V14").Value = essential
Range("V15").Value = non_essential
Range("V16").Value = luxury
Range("V17").Value = adjustment
Range("V18").Value = n_a

End Sub
