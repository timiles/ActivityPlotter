$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

function Get-PlotOfDays ($days) {
    $plot = "";
    $numberOfColumns = [Math]::Floor(($days | Sort-Object -Descending)[0] / 7);
    for ($row = 0; $row -lt 7; $row++) {
        for ($column = 0; $column -le $numberOfColumns; $column++) {
            if ($days -contains ($row + ($column * 7))) {
                $plot += "X";
            }
            else {
                $plot += " ";
            }
            if ($column -eq $numberOfColumns) {
                $plot += "`n";
            }
        }
    }
    return $plot;
}

Describe "Read-Font" {
    Context "When I read the font file" {
        $result = Read-Font ".\default-font.txt"

        It "Builds a list of characters" {
            $actualA = $result['A'];
            $expectedA = @(
                1, 2, 3, 4, 5,
                8, 10,
                15, 16, 17, 18, 19
            )
            $actualA.Length | Should Be $expectedA.Length
            For ($i = 0; $i -lt $actualA.Length; $i++) {
                $actualA[$i] | Should Be $expectedA[$i]
            }
        }
    }
}

Describe "Get-ActivityDays" {
    Context "When I request 'TIM'" {
        $result = Get-ActivityDays "TIM"

        It "Returns the correct days" {
            Write-Host $result
            $expected = @(
                1, 8, 9, 10, 11, 12, 15,
                29, 30, 31, 32, 33,
                43, 44, 45, 46, 47, 51, 59, 65, 71, 72, 73, 74, 75
            )
            $result.Length | Should Be $expected.Length
            For ($i = 0; $i -lt $result.Length; $i++) {
                $result[$i] | Should Be $expected[$i]
            }
        }
    }
    Context "When I request 'tim'" {
        $result = Get-ActivityDays "tim"

        It "Returns the correct days" {
            Write-Host $result
            $expected = @(
                2, 3, 4, 5, 10, 12,
                22, 24, 25, 26,
                38, 39, 40, 45, 53, 59, 66, 67, 68
            )
            $result.Length | Should Be $expected.Length
            For ($i = 0; $i -lt $result.Length; $i++) {
                $result[$i] | Should Be $expected[$i]
            }
        }
    }
}

Describe "Get-PlotOfDays (Not really tests, just for eye-balling)" {
    Context "Plot 'tim'" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "tim"))
    }
    Context "Plot 'TIM'" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "TIM"))
    }
    Context "Plot 'Tim'" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "Tim"))
    }
    Context "Plot 'ABCDEFGHIJKLM'" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "ABCDEFGHIJKLM"))
    }
    Context "Plot 'NOPQRSTUVWXYZ'" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "NOPQRSTUVWXYZ"))
    }
    Context "Plot 'abcdefghijklm'" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "abcdefghijklm"))
    }
    Context "Plot 'nopqrstuvwxyz'" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "nopqrstuvwxyz"))
    }
}