filter Invoke-Ternary ($decider, $ifTrue, $ifFalse) {
<#
.SYNOPSIS
    Combines if...else in short form.  Similar to the C# ? operator.

.EXAMPLE
    PS> 1..10 | ?: {$_ -gt 5} {'Greater than 5'; $_} {'Not greater than 5'; $_}
    -----------
    Description
    Not greater than 5
    1
    Not greater than 5
    2
    Not greater than 5
    3
    Not greater than 5
    4
    Not greater than 5
    5
    Greater than 5
    6
    Greater than 5
    7
    Greater than 5
    8
    Greater than 5
    9
    Greater than 5
    10

.EXAMPLE
    PS> ?: ($true) 'It's true!' 'It's false...'
    -----------
    Description
    It's true!
#>

    if($decider.GetType().Name -eq 'ScriptBlock') {
        $isTrue = (&$decider)
    } elseif($decider) {
        $isTrue = $true
    } else {
        $isTrue = $false
    }

    if($isTrue) {
        if($ifTrue.GetType().Name -eq 'ScriptBlock') {
            &$ifTrue
        } else {
            $ifTrue
        }
    } else {
        if($ifFalse.GetType().Name -eq 'ScriptBlock') {
            &$ifFalse
        } else {
            $ifFalse
        }
    }
}

Set-Alias ?: Invoke-Ternary -Option AllScope -Description 'Ternary operator'