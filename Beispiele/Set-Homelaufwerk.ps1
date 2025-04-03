
# Set-Homelaufwerk
#
##################################################################################################
#
# Anlegen von neuen Home-Laufwerken, löschen von nicht mehr benötigten Ordnern und Berechtigungs-
# kontrolle
#
# Parameter:
#
# Beispiel:
#
#     	.\Set-Homelaufwerk.ps1
#
##################################################################################################


# AD Modul Importieren
Import-Module ActiveDirectory

#Pfad für die Homelaufwerke
$strHomePfad = "C:\Home"

CLS

# AD Nutzer auslesen
$objUsers = Get-ADUser -Filter * -SearchBase "OU=sem-user,OU=sem,DC=shdecheschulung,DC=local" | where { $_.enabled -eq $true }

$iZ = 0

# Alle Homeorder auslesen
$objOrdnerHomeLW = Get-ChildItem $strHomePfad -Directory

# Homelaufwerke Berechtigungen prüfen gegebenfalls löschen

# durch alle Ordner durchgehen
foreach($objHome in $objOrdnerHomeLW)
{
    # Name des Ordners holen
    $strHomeName = $objHome.Name

    # Berechtigungen holen
    $objHomeACL = Get-ACL -Path $objHome.FullName

    # IstVorhanden - Variable mit 0 initiallisieren
    $iIstVorhanden = 0
    $strACLNutzer  = ""

    # Liste der Nutzer durchgehen
    Foreach($objUser in $objUsers)
    {
        # gibt es einen Nutzer zum Ordner, wenn ja IstVorhanden - Variable auf 1 setzen
        if($objUser.SamAccountName -eq $strHomeName) 
        { 
            $iIstVorhanden = 1             
        }

        # Gibt es für einen Nutzer eine Berechtigung ( außer sem201 )
        if($objUser.SamAccountName -ne "sem201")
        {
            # Berechtigungen durchgehen
            foreach($strHomeAtS in $objHomeACL.AccessToString)
            {
                # gibt es eine Berechtigung
                if($strHomeAtS -match "FullControl" -and $strHomeAtS -match "\\$($objUser.SamAccountName)")
                {
                    $strACLNutzer = $objUser.SamAccountName
                }
            }
        }

    }

    Write-Host "Ergebnis: $strHomeName - $iIstVorhanden - $strACLNutzer"

    # Wenn es keinen Nutzer gibt ( IstVorhanden - Variable == 0 und es gibt keinen Berechtigten mehr )
    if($iIstVorhanden -eq 0 -and $strACLNutzer -eq "")
    {
        Write-Host "$($objHome.FullName) - Ordner löschen"

        # lösche den Ordner
        Remove-Item -Path $objHome.FullName
    }
    
    # Wenn die Berechtigung nicht mehr stimmt ( IstVorhanden - Variable == 1 aber der Berechtigte stimmt nicht oder es gibt keine mehr )
    if( $iIstVorhanden -eq 1 -and $strACLNutzer -ne $strHomeName)
    {
        Write-Host "$($objHome.FullName) - Berechtigungen setzen"
            
        # Neue Nutzerberechtigung erstellen
        $objNEURechte = New-Object System.Security.AccessControl.FileSystemAccessRule($strHomeName,”FullControl”,”Allow”)
        # Nutzerberechtigung hinzugfügen
        $objHomeACL.SetAccessRule($objNEURechte)
            ´        # ist der berechtigte Nutzer nicht leer
        if( $strACLNutzer -ne "")
        {
            # dann lösche die berechtigung
            $objDELRechte = New-Object System.Security.AccessControl.FileSystemAccessRule($strACLNutzer,"FullControl","Allow")
            $objHomeACL.RemoveAccessRule($objDELRechte)
        }
           
        # Rechte am Homelaufwerk setzen ( abspeichern )
        $objHomeACL | Set-Acl -Path $objHome.FullName
        
    }

    # wurde der Ordner umbenannt ( IstVorhanden - Variable == 0 aber es gibt einen Berechtigten )
    if( $iIstVorhanden -eq 0 -and $strACLNutzer -ne "")
    {
        Write-Host "$($objHome.FullName) - Ordner umbenennen"
        
        #Ordner umbenennen
        Rename-Item -Path $objHome.FullName -NewName $strACLNutzer
    }
}

# Neue Homelaufwerke anlegen

# AD Nutzer durchgehen
Foreach($objUser in $objUsers)
{
    # Pfad fürs Homelaufwerk zusamensetzen    
    $strUserHome = $strHomePfad + "\" + $objUser.SamAccountName

    # Öffnen des Homelaufwerk Ordner
    $objOrdner = Get-Item $strUserHome -ErrorAction:SilentlyContinue
    
    # Gibt es diesen Ordner nicht, dann
    if($objOrdner -eq $null)
    {
        Write-Host "$strUserHome - Ordner anlegen"

        # Homelaufwerk anlegen
        New-Item -Name $objUser.SamAccountName -ItemType Directory -Path "$strHomePfad\"

        # Berechtigungen des Ordners holen
        $objRechte    = Get-ACL -Path $strUserHome
        
        # Neue Nutzerberechtigung erstellen
        $objNEURechte = New-Object System.Security.AccessControl.FileSystemAccessRule($objUser.SamAccountName,”FullControl”,”Allow”)
        
        # Nutzerberechtigung hinzugfügen
        $objRechte.SetAccessRule($objNEURechte)

        # Rechte am Homelaufwerk setzen ( abspeichern )
        $objRechte | Set-Acl -Path $strUserHome

        $iZ++
    }

    # if($iZ -gt 3) { break }
}
