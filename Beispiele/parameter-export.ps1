
Param(
        $strDatei     = "",
        $strDateiJSON = "",
        $Print        = $true
)

Function Test( $strDatei )
{
    Write-Host "Funktion Test : $strDatei"
}

Test -strDatei $strDatei

# CSV Export

#Get-Service | Export-Csv $strDatei -Delimiter ";"

if($Print -eq $true)
{
    Write-Host "Services in $strDatei als CSV exportiert"
}

# Export als JSON

#Get-Service | ConvertTo-JSON | Out-File $strDateiJSON

