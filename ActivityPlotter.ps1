function Get-NextDaysOffset ($dayNumber) {
    $weekNumber = [Math]::Floor($dayNumber / 7);
    return ($weekNumber + 2) * 7;
}

function Read-Font ($fontFilePath) {
    # Create a hash table with case-sensitive keys
    $characterLetterDays = New-Object Collections.Hashtable ([StringComparer]::CurrentCulture)

    $fontFileContents = Get-Content $fontFilePath;
    
    $blockIndex = -1;
    $char = '';
    $days = @();
    foreach ($line in $fontFileContents) {
        try {
            if ($blockIndex -eq -1) {
                $char = $line[0].ToString().Trim();
                $days = @();
                $blockIndex++;
                continue;
            }

            $numberOfColumns = $line.Length;
            for ($column = 0; $column -lt $numberOfColumns; $column++) {
                if ($line[$column] -eq 'X') {
                    $days += $blockIndex + $column * 7;
                }
            }

            $blockIndex++;

            if ($line -eq '---') {
                $characterLetterDays.Add($char, ($days | Sort-Object));
                $blockIndex = -1;
                continue;
            }
        }
        catch {
            Write-Error "Error reading line: $line";
        }
    }

    return $characterLetterDays;
}

function Get-ActivityDays ([String] $text, [Collections.Hashtable] $fontDefinition) {

    if (!$fontDefinition) {
        $fontDefinition = Read-Font ".\default-font.txt";
    }

    $days = @();
    $daysOffset = 0;
    foreach ($char in $text.ToCharArray() | ForEach-Object { $_.ToString() }) {
        if ($char -eq ' ') {
            # special case for spaces
            $daysOffset += 7;
            continue;
        }

        $charDay = $fontDefinition[$char];
        $offsetCharDay = ($charDay | ForEach-Object { $daysOffset + $_ })
        $days += $offsetCharDay;
        $maxDayNumber = ($offsetCharDay | Sort-Object -Descending)[0];
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
