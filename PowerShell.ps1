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

Get-Help <#cmdlets#>
Set-Alias -Name <#eigener Alias#> -value <#Cmdlets#>
<#Aliasse nur für Sitzung! man kann quasi einen Befehl ein erstezen#>

get-alias

Write-Host #schreibe etwas
echo

Read-Host -Prompt "Geben Sie etwas ein." #input

clear <#leere die Commandozeile#>

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

$($A) #interpretiere als PowerShell-Befehl
"$(Get-Service -n vss) + 3" #Bsp.
$vss = Get-Service -n vss
$vss.Name #kann auch ein Objekt sein

<#Pipeline: | #>
#Ausgabe als Eingabe weiterführen
$var | Format-List *

ft #als table
ft spalte1, spalte2 #gibt nur das aus

# * Kleenscher-Stern

Get-service | get-member #Aufbau eines Objekts !!Auch Methoden!!

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

Get-ExecutionPolicy #Schauen, ob ps1 ausgeführt werden darf

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
    #$i ist eine automatische Variable zum DUrchzählen
    <# Action that will repeat until the condition is met #>
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
:Springezu

:Springezu {$var = 0}