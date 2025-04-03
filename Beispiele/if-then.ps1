cls

$Service = Get-Service -Name wuauserv

Write-Host "Service : $($Service.DisplayName) - $($Service.Status)"

# Kommentar : If-Schleife
if( $Service.Status -eq "Stopped" )
{
    Write-Host " --> gestoppt"
}
elseif ( $Service.Status -eq "Running"  )
{
    Write-Host " --> gestartet"
}
else
{
    Write-Host " --> keine Angabe"
}

# For-Schleife
for( $iA = 1; $iA -le 20; $iA += 1 )
{
    if($iA -eq 9) { continue }
    Write-Host "Zahl - $iA"
    
}

# Foreach - Schleife

$objServices = Get-Service
foreach( $objServ in $objServices )
{
    Write-Host $objServ.Name
}

# andere Schreibweise

Get-Service | % { 
    Write-Host $_.Name 
}

# Umsetzung mit IF

for( $iA = 0; $iA -lt $objServices.Count; $iA++)
{
    Write-Host $objServices[$iA].Name
}


