# <#
# ## POWERSHELL RL
# ## Homelaufwerk für neue AD-User hinzufügen
# ## Beim verlassen - HL löschen
# ## Berechtigungen Prüfen und korrigieren
# #>

# <#Module ---------------------------------------------------------#>

# Import-Module ActiveDirectory #für AD-Verwaltung

# <#Konst ----------------------------------------------------------#>

# $strHomePfad = "C:\Home" #Homelaufwerkpfad

# <#Home anlegen -----------------------------------------------------------#>

# #leeren Bildschirm
# cls

# #AD-User filtern: Nur aktive Accounts, nur in dem Ordner (nach rechts immer einen Ordner hoch
# $objUsers = Get-ADUSER -f * -SearchBase "OU=sem-user,OU=sem,DC=shdecheschulung,DC=local"  | where{ $_.enabled -eq $true}

# #für Entwicklung, dass nicht so viel macht
# #$iZ = 0 #TODO

# #jeden Nutzer ansehen
# Foreach ($objUser in $objUsers)
# {
#     #$objUser | fl *

#     #so muss Pfad aussehen
#     $strUserHome = $strHomePfad + "\" + $objUser.SamAccountName

#     #legt Eigenschaften des Ordners in Var (wenn nicht da, dann leer)
#     $objOrdner = Get-Item $strUserHome -ErrorAction:SilentlyContinue

#     #wenn Ordner leer, dann
#     if($objOrdner -eq $null)
#     {
#         #Kontrollausgabe
#         echo "$strUserHome - Ordner anlegen"

#         #Neuer Pfad wird angelegt
#         New-Item -n $objUser.SamAccountName -ItemType directory -p "$strHomePfad\"

#         #Berechtigungen

#         #aktuellen Rechte werden geladen
#         $objRight = Get-acl -path "$strUserHome"

#         #neue Rechte setzen
#         $objNewRight = New-Object System.Security.AccessControl.FileSystemAccessRule($objUser.SamAccountName, "FullControl", "Allow")
       
#         #Nutzerberechtigung hinzufügen
#         $objRight.SetAccessRule($objNewRight)
       
#         #Rechte am Homelaufwerk setzen / speichern
#         $objRight | Set-Acl -path $strUserHome

#         #Entwicklungsvar
#         #$iZ++ #TODO
#     }
#     else
#     {
#         #zeige Ordner als Liste an
#         #$objOrdner | fl *
#     }

#     #für Entwicklung: bricht nach drei Elementen ab
#     <#if($iZ -gt 3) #TODO
#     {
#         $iZ = 0
#         break
#     }#>
# }

# <#herrenlose Ordner löschen -----------------------------------------------------------#>

# $objUserFolder = dir $strHomePfad -Directory

# #für jeden Ordner im Verzeichnis tue das:
# foreach ($objUserFolderTEMP in $objUserFolder)
# {
#     #$objUserFolderTEMP | fl *

#     #speichert Ordnername
#     $strHomeName = $objUserFolderTEMP.Name

#     #prüft, ob User zu Ordner schon vorhanden ist
#     $ivorhanden = 0 #0 Nein
#     foreach ($objUser in $objUsers)
#     {
#         #gibt es den User in der User Liste
#         if($objUser.SamAccountName -eq $strHomeName) 
#         {
#             $ivorhanden = 1
#             break
#         }
#     }

#     #wenn nicht, lösche Ordner
#     if($ivorhanden -eq 0)
#     {
#         echo "$($objUserFolderTEMP.Fullname) - Ordner wird gelöscht"
#         Remove-Item -path $objUserFolderTEMP.Fullname
#     }
# <#Berechtigungen prüfen -----------------------------------------------------------#>
#     else
#     {
#         echo "$($objUserFolderTEMP.Fullname) - Berechtigungen prüfen..."

#         $objHomeACL = Get-Acl -path $objUserFolderTEMP.Fullname

#         $ivorhanden = 0
#         foreach($strHomeAccesstoString in $objHomeACL.accesstostring)
#         {
#             if($strHomeAccesstoString -match "FullControl" -and $strHomeAccesstoString -match "\\$strHomeName")
#             {
#                 $ivorhanden = 1
#                 break
#             }
#         }

#         if ($ivorhanden -eq 0)
#         {
#             echo "$($objUserFolderTEMP.Fullname) - Berechtigungen setzen"

#             #neue Rechte setzen
#             $objNewRight = New-Object System.Security.AccessControl.FileSystemAccessRule($objUser.SamAccountName, "FullControl", "Allow")
       
#             #Nutzerberechtigung hinzufügen
#             $objHomeACL.SetAccessRule($objNewRight)
       
#             #Rechte am Homelaufwerk setzen / speichern
#             $objHomeACL | Set-Acl -path $objUserFolderTEMP.fullname
#         }
#      }
# }
