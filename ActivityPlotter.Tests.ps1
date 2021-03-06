$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

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
    Context "When I request 'Tim!'" {
        $result = Get-ActivityDays "Tim!"

        It "Returns the correct days" {
            Write-Host $result
            $expected = @(
                1, 8, 9, 10, 11, 12, 15,
                29, 31, 32, 33,
                45, 46, 47, 52, 60, 66, 73, 74, 75,
                85, 86, 87, 89
            )
            $result.Length | Should Be $expected.Length
            For ($i = 0; $i -lt $result.Length; $i++) {
                $result[$i] | Should Be $expected[$i]
            }
        }
    }
}

Describe "Get-PlotOfDays" {
    Context "When I request 'i' with no dayToHighlight" {
        $result = Get-PlotOfDays (Get-ActivityDays "i")

        It "Returns the expected plot" {
            $expected = " `nX`n `nX`nX`nX`n `n";
            $result | Should Be $expected
        }
    }
    Context "When I request 'i' with dayToHighlight 0" {
        $result = Get-PlotOfDays (Get-ActivityDays "i") 0

        It "Returns the expected plot" {
            $expected = "N`nX`n `nX`nX`nX`n `n";
            $result | Should Be $expected
        }
    }
    Context "When I request 'i' with no dayToHighlight 1" {
        $result = Get-PlotOfDays (Get-ActivityDays "i") 1

        It "Returns the expected plot" {
            $expected = " `nY`n `nX`nX`nX`n `n";
            $result | Should Be $expected
        }
    }
}

Describe "Get-PlotOfDays (Not really tests, just for eye-balling)" {
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
    Context "Plot '1234567890" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "1234567890"))
    }
    Context "Plot '-=!`"'#$%^&*()_+" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "-=!`"'#$%^&*()_+"))
    }
    Context "Plot '\/,.;:|<>?@~[]{}'" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "\/,.;:|<>?@~[]{}"))
    }
    Context "Plot '£'" {
        Write-Host (Get-PlotOfDays (Get-ActivityDays "£"))
    }
}