$defaultErrorActionState=$ErrorActionPreference
$ErrorActionPreference="SilentlyContinue"

# Wird immer aufgerufen, wenn irgendwo im Code ein Fehler auftritt
# Ausführung kehrt danach zurück zur nächsten Anweisung
trap {
    # Hier ging was schief
    Write-Host "Fehler gefangen: " $_.Exception.Message  | Tee-Object -FilePath 'C:\tmp\Powershell\ps.log' -Append
    
    $Error.Clear()
}

function Copy-File {
    param (
        $Quelle,
        $Ziel
    )
    
    Copy-Item -Path $Quelle -Destination $Ziel
}
# Code, der nicht funktioniert
Copy-File -Quelle .\Test.txt -Ziel c:\ABC\Test.txt

# Code, der funktioniert
Copy-File -Quelle .\Test.txt -Ziel Test.neu.txt

$ErrorActionPreference = $defaultErrorActionState