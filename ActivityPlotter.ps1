function Get-NextDaysOffset ($dayNumber) {
    $weekNumber = [Math]::Floor($dayNumber / 7);
    return ($weekNumber + 2) * 7;
}

function Get-ActivityDays ($text) {
    $upperCaseLetterDays = @{
        'A' = @(1, 2, 3, 4, 5, 8, 10, 15, 16, 17, 18, 19)
        'B' = @(1, 2, 3, 4, 5, 8, 10, 12, 15, 16, 18, 19)
        'C' = @(2, 3, 4, 8, 12, 15, 19)
        'D' = @(1, 2, 3, 4, 5, 8, 12, 16, 17, 18)
        'E' = @(1, 2, 3, 4, 5, 8, 10, 12, 15, 17, 19)
        'F' = @(1, 2, 3, 4, 5, 8, 10, 15, 17)
        'G' = @(2, 3, 4, 8, 12, 15, 18, 19)
        'H' = @(1, 2, 3, 4, 5, 10, 15, 16, 17, 18, 19)
        'I' = @(1, 2, 3, 4, 5)
        'J' = @(1, 5, 8, 12, 15, 16, 17, 18)
        'K' = @(1, 2, 3, 4, 5, 10, 15, 16, 18, 19)
        'L' = @(1, 2, 3, 4, 5, 12, 19)
        'M' = @(1, 2, 3, 4, 5, 9, 17, 23, 29, 30, 31, 32, 33)
        'N' = @(1, 2, 3, 4, 5, 9, 17, 22, 23, 24, 25, 26)
        'O' = @(1, 2, 3, 4, 5, 8, 12, 15, 16, 17, 18, 19)
        'P' = @(1, 2, 3, 4, 5, 8, 10, 15, 16, 17)
        'Q' = @(2, 3, 4, 8, 12, 15, 18, 19, 22, 26, 30, 31, 32, 34)
        'R' = @(1, 2, 3, 4, 5, 8, 10, 11, 15, 16, 17, 19)
        'S' = @(1, 2, 3, 5, 8, 10, 12, 15, 17, 18, 19)
        'T' = @(1, 8, 9, 10, 11, 12, 15)
        'U' = @(1, 2, 3, 4, 5, 12, 15, 16, 17, 18, 19)
        'V' = @(1, 2, 3, 4, 12, 15, 16, 17, 18)
        'W' = @(1, 2, 3, 4, 5, 11, 17, 25, 29, 30, 31, 32, 33)
        'X' = @(1, 2, 4, 5, 10, 15, 16, 18, 19)
        'Y' = @(1, 2, 5, 10, 12, 15, 16, 17, 18)
        'Z' = @(1, 4, 5, 8, 10, 12, 15, 16, 19)
    }

    $lowerCaseLetterDays = @{
        'a' = @(1, 3, 4, 5, 8, 10, 12, 16, 17, 18, 19)
        'b' = @(1, 2, 3, 4, 5, 10, 12, 17, 18, 19)
        'c' = @(4, 10, 12, 17, 19)
        'd' = @(3, 4, 5, 10, 12, 15, 16, 17, 18, 19)
        'e' = @(3, 4, 5, 9, 11, 13)
        'f' = @(3, 4, 5, 6, 9, 11)
        'g' = @(3, 6, 9, 11, 13, 16, 17, 18, 19)
        'h' = @(1, 2, 3, 4, 5, 10, 17, 18, 19)
        'i' = @(1, 3, 4, 5)
        'j' = @(6, 8, 10, 11, 12)
        'k' = @(1, 2, 3, 4, 5, 11, 17, 19)
        'l' = @(1, 2, 3, 4, 5)
        'm' = @(3, 4, 5, 10, 18, 24, 31, 32, 33)
        'n' = @(3, 4, 5, 10, 17, 18, 19)
        'o' = @(3, 4, 5, 10, 12, 17, 18, 19)
        'p' = @(3, 4, 5, 6, 10, 12, 17, 18, 19)
        'q' = @(3, 4, 5, 10, 12, 17, 18, 19, 20)
        'r' = @(3, 4, 5, 10)
        's' = @(2, 3, 5, 9, 11, 12)
        't' = @(2, 3, 4, 5, 10, 12)
        'u' = @(3, 4, 5, 12, 17, 18, 19)
        'v' = @(3, 4, 12, 17, 18)
        'w' = @(3, 4, 5, 12, 18, 26, 31, 32, 33)
        'x' = @(3, 5, 11, 17, 19)
        'y' = @(3, 4, 6, 12, 13, 17, 18, 19)
        'z' = @(2, 4, 5, 9, 10, 12)
    }

    $days = @();
    $daysOffset = 0;
    foreach ($letter in $text.ToCharArray() | ForEach-Object { $_.ToString() }) {
        $letterDay = if ($letter -ceq $letter.ToUpper()) {
            $upperCaseLetterDays[$letter] 
        }
        else {
            $lowerCaseLetterDays[$letter]
        }

        $offsetLetterDay = ($letterDay | ForEach-Object { $daysOffset + $_ })
        $days += $offsetLetterDay;
        $maxDayNumber = ($offsetLetterDay | Sort-Object -Descending)[0];
        $daysOffset = Get-NextDaysOffset($maxDayNumber);
    }
    return $days;
}

function Invoke-Activity () {
    Write-Host "Invoking Activity...";

    # do 100 commits of an arbitrary change
    for ($i = 0; $i -lt 100; $i++) {
        Add-Content readme.txt "." -NoNewLine;
        git commit -am ".";
    }
    git push;
    Write-Host "Done.";
}

function Invoke-ActivityPlotter ([Parameter(Mandatory = $true)][DateTime] $firstSunday,
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $textToPlot) {
    if ($firstSunday.DayOfWeek -ne "Sunday") {
        throw "Start date must be a Sunday. $($firstSunday.ToShortDateString()) is a $($firstSunday.DayOfWeek).";
    }

    $daysSinceFirstSunday = ([DateTime]::Today - $firstSunday).TotalDays;
    Write-Host "Days since first Sunday: $daysSinceFirstSunday";

    $activityDays = Get-ActivityDays($textToPlot);
    Write-Host "Activity Days for '$textToPlot': $activityDays";

    if ($activityDays -contains $daysSinceFirstSunday) {
        Write-Host "Today is an Activity Day!";
        Invoke-Activity;
        Write-Host "Goodbye!";
    }
    else {
        Write-Host "Today is not an Activity Day. Goodbye!";
    }
}
