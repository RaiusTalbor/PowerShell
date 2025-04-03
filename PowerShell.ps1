<#PowerShell#>

<#PS:
Das Schöne: Immer und überall auf Windows, ursprünglich für Server
mit PowerShell oder ISE - oder halt hier#>

<#Aufbau:
groß/klein egal
anhand Syntax leicht erratbar
mit Tab automatisch ausfüllen
Tabs, Leerzeichen egal

Verb-Subjekt -Parameter Argument

get (lesen), set (schreiben/setzen), remove, ...
recht logisch

Parameter mit Anfangsbuchstaben abkürzbatr
#>

<#
Ausführen:
.\[Dateiname].ps1

C:\Users\sem204\[Dateiname].ps1
Im Ordner: .\[Dateiname].ps1
: für Ordner drüber
#>

#Tipp: Objekte am besten vorher anschauen, da hilft an vielen Stellen weiter

Get-ExecutionPolicy #Schauen, ob ps1 ausgeführt werden darf

#Skript Parameter übergeben, das hier sind Standartwerte, muss am Anfang der Datei stehen!
Param(
    $variable = "",
    $b = 1
)

#Aufruf, Param kann ich aber auch weg lassen, dann Standartwerte: 
.\Datei.ps1 -var "sth" -Print $false

Get-Help <#cmdlets#>
Set-Alias -Name <#eigener Alias#> -value <#Cmdlets#>
<#Aliasse nur für Sitzung! man kann quasi einen Befehl ein erstezen#>

get-alias

Write-Host #schreibe etwas
echo

Read-Host -Prompt "Geben Sie etwas ein." #input

clear <#leere die Commandozeile#>

$var.count #len() ; wenn es für Objekt da ist

<#Variablen, ähnlich wie in C nur ohne Deklaration wie in Python (auch mit Umgang) (Typecasting nicht notwendig), interpretiert im Kontext#>
<#speichert intern als Objekte und diese wieder als json#>
$var = 0
$var = "Text"
$A + $B
<#Var sind sind in allen und unterblöcken#>
$Global:var #überall
$Local:var #nur in dem Block

<#formated Strings#>
"$A + $B" <#mit doppelten, mit einfachen nicht#>

<#Bool#>
$true <#... 1#>
$false <#... 0#>

<#Typecasting#>
[int32]$var
[String]$var

<#Automatische Var: die immer da sind (wie bool), nur lesbar#>
$_ #aktuelles Element (in Schleife)
$null #leer, nicht existent

$($A) #interpretiere als PowerShell-Befehl
"$(Get-Service -n vss) + 3" #Bsp.
$vss = Get-Service -n vss
$vss.Name #kann auch ein Objekt sein

#Liste:
#https://learn.microsoft.com/de-de/powershell/scripting/learn/deep-dives/everything-about-arrays?view=powershell-7.5
$liste = @(1, 2, 3)
$liste = Write-Output 1 2 3 4
$liste[1]
$liste[1,2,3] #index 1, 2, 3 --> 3, 0, 3
$liste[1..3] #1 bis 3
$liste[-1]
$liste.count #len()
$liste[0].name #(wenn index 0 ein Objekt)
switch ($liste) {
    a {  }
    Default {}
}

<#Pipeline: | #>
#Ausgabe als Eingabe weiterführen
$var | Format-List *

ft #als table
ft spalte1, spalte2 #gibt nur das aus

# * Kleenscher-Stern

Get-service | get-member #Aufbau eines Objekts !!Auch Methoden!!

Get-Item #kann Objekt "holen" --> everything is a obj

Get-ChildItem $pfad -directory #zeigt alle Unterordner an
dir $pfad -Directory #tut dasselbe

<#Operatoren#>

-eq #==
-ne #!=
-gt #< greater than
-lt #> less than
-ge #<=
-le #>=
-and -or -xor -not ! #logische Operatoren
+ - * / %
=, += , ...
-contains -notcontains
-split -join #format für Texte
-is -isnot #datentyp
& #ausführen

<#Redirect Operatoren#>
#s. PP
> #ausgabe in Datei
>> #appends zu datei
#2 davor: error 3: warnung 4: verbose (Whatif) 5: debug
#&1 dahinter mit Kontext to same location wie standard output
#* davor: alles

-whatif #Was passiert, wenn Du den Befehl ausführst?

$var = Get-Service -Name ` <#Befehl über mehrere Zeilen#>
wuauserv

if (<#condition#>) {
    <# Action to perform if the condition is true #>
} elseif (<#condition#>) {
    <# Action when this condition is true #>
} else {
    <# Action when all if and elseif conditions are false #>
}

for ($i = 1; $i -le 10; $i++)
{
    #$i ist eine automatische Variable zum Durchzählen
    <# Action that will repeat until the condition is met #>
}

#für jedes Item dieser Liste tue das; Alias: %
foreach ($currentItemName in $collection) {
    <# $currentItemName is the current item #>
}

while (<#while#>) {
    #sth
}

do {
    
} while (<# Condition that stops the loop if it returns false #>)

<#Warum?#>
do {
    
} until (<# Condition that stops the loop if it returns true #>)

switch ($x) 
{
    condition {}
    Default {}
}

break #herausspringen aus Schleife
continue #brich ab und gehe zum nächsten Schleifendurchlauf

#goto möglich
:Springezu #spingt woanders hin
:Springezu {$var = 0} #tut genau das

function Test ($var)
{
    #dwkd
    return $var
}
$var1 = Test -var 99

#Signaturen sind möglich gegen versehentliches Ändern

-filter where{<#Bedingung#>} 
#beim Filtern, die Eigenschaft true
-ErrorAction:SilentlyContinue #mache weiter, auch wenn Fehler auftritt (bei Prüfung, wenn etwas nicht da ist)

New-Item -name $name -ItemType directory -path path #legt etwas neues an

<#über Tasks/ChromeJob/Aufgabenplanung automatisierbar#>

#Messagebox
$msg = "Hi!"
$targetPC = "sem205"

Invoke-Command -ComputerName $targetPC -ScriptBlock {
    param($message)
    msg * $message
} -ArgumentList $msg