Param(
    $pfadJSON = "C:\users\sem204\Desktop",
    $pfadCSV = "C:\users\sem204\Desktop",
    $Print = $true
    )

#CSV-Export

Get-Service | Export-Csv $pfadCSV -Delimiter ";" #standartmäßig ist Komma

if($Print -eq $true)
{
    echo "Service in $pfad wird in CSV exportiert"
}

echo "$pfadCSV - $Print"

#JSON-Export

Get-Service | ConvertTo-JSON | Out-File $pfadJSON

#import geht auch