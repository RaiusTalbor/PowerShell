<#
RL
Projektordner werden automatisch mit jeweiligen ordner angelegt
Abteilungsordner werden mit jeweiligen Projektordner angelegt
Berechtigungen werden richtig verteilt
#>

<#übernommene Parameter ---------------------------------------------------------#>

Param(
    $projektname = "Finn", #Projektname soll übergeben werden
    $projektberechtigungsgruppe = "sem205" #Projektberechtigung soll übergeben werden
)

<#Module ---------------------------------------------------------#>

Import-Module ActiveDirectory #für AD-Verwaltung

<#Konst ----------------------------------------------------------#>

$homepfad = "C:\tag3" #wo alle Ordner zu finden sein werden

#Bildschirm leeren
cls

<#Projektordner anlegen ----------------------------------------------------------#>

#lese alle Unterordner aus
$alleordner = dir $homepfad -Directory
if($alleordner -eq $null)
{
    $alleordner = @("")
}

foreach($aktuellerOrdner in $alleOrdner)
{
    if($projektname -eq $aktuellerOrdner.name)
    {
        echo "Projekt '$($projektname)' existiert schon! Projekt wird nicht angelegt"
        $projektname = ""
        $projektberechtigungsgruppe = ""
    }
}

#wenn er Ordner anlegen soll, dann lege Ordner mit Unterordnern an (Ordnername ist nicht leer -> es wurde einer übergeben)
if ($projektname -ne "")
{
    #Projektordner
    New-Item -Name $projektname -ItemType directory -Path "$homepfad\"

    #UO
    New-Item -Name Dokumentation -ItemType directory -Path "$homepfad\$projektname"
    #UO
    New-Item -Name Kalkulation -ItemType directory -Path "$homepfad\$projektname"
    #UO
    New-Item -Name Tests -ItemType directory -Path "$homepfad\$projektname"
    #UO
    New-Item -Name Vorbereitungen -ItemType directory -Path "$homepfad\$projektname"
}
elseif($projektname -eq " ")
{
    #Entspann Dich #TODO für mehrere Leerzeichen
}

#jeweilige Berechtigung wird hinzugefügt
if ($projektberechtigungsgruppe -ne "")
{
    #Berechtigung setzen

    #Berechtigung dafür holen
    $acl = Get-acl "$homepfad\$projektname"
    #Berechtigung setzen
    $berechtigung = New-Object System.Security.AccessControl.FileSystemAccessRule("$projektberechtigungsgruppe",”FullControl”,”Allow”)
    #Berechtigung anwenden
    $acl.SetAccessRule($berechtigung)
    #Berechtigung speichern
    Set-acl "$homepfad\$projektname" $acl
}

<#Abteilungsordner anlegen anlegen ----------------------------------------------------------#>

#lese alle Abteilungen aus
$abteilungen = Get-ADGroup -Filter * -SearchBase "OU=Powershell,DC=shdecheschulung,DC=local"

#prüfen, ob Ordner schon da
foreach($aktuelleAbteilung in $abteilungen)
{
    #alle Mitarbeiter der Gruppe
    $alleMitarbeiter = Get-ADGroupMember -identity $aktuelleAbteilung

    $da = 0

    #für jeden Ordner in $homepfad
    foreach($aktuellerOrdner in $alleordner)
    {
        #gibt es den Abteilungspfad schon?
        if($($aktuellerOrdner.name) -eq $($aktuelleAbteilung.name))
        {
            $da = 1
        }
    }

    #wenn es noch nicht da ist, erstelle
    if($da -eq 0)
    {
        #alle Ordner inkl. Unterordner erstellen
        
        #Abteilungsordner
        New-Item -Name $aktuelleAbteilung.name -ItemType directory -Path "$homepfad\" 

        #UO
        New-Item -Name Anweisungen -ItemType directory -Path "$homepfad\$($aktuelleAbteilung.name)" 
        #UO
        New-Item -Name Doks -ItemType directory -Path "$homepfad\$($aktuelleAbteilung.name)" 
        #UO Mitarbeiter wird dann durch Mitarbeiter erstellt
        
        foreach($aktuellerMitarbeiter in $alleMitarbeiter)
        {
            $mitarbeiterpfad = "$homepfad\$($aktuelleAbteilung.name)"
            $mitarbeiterpfad = "$mitarbeiterpfad\Mitarbeiter\"
            
            New-Item -name $aktuellerMitarbeiter.name -ItemType Directory -path $mitarbeiterpfad 
        }

        #Berechtigung setzen

        #Berechtigung dafür holen
        $acl = Get-acl "$homepfad\$($aktuelleAbteilung.name)"
        #Berechtigung setzen
        $berechtigung = New-Object System.Security.AccessControl.FileSystemAccessRule("$($aktuelleAbteilung.name)",”FullControl”,”Allow”)
        #Berechtigung anwenden
        $acl.SetAccessRule($berechtigung)
        #Berechtigung speichern
        Set-acl "$homepfad\$($aktuelleAbteilung.name)" $acl
    }
}