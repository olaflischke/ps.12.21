function Copy-File {
    param (
        $Quelle,
        $Ziel
    )
    
    Copy-Item -Path $Quelle -Destination $Ziel
}

try {
    
    # get-dir C:\tmp

    # Code, der nicht funktioniert
    # Copy-File -Quelle .\Test.txt -Ziel c:\ABC\Test.txt

    # Code, der funktioniert
    Copy-File -Quelle .\Test.txt -Ziel Test.neu.txt

    # Trotzdem noch "händisch" eine Exception auslösen
    Throw "Patsch, daneben!"
}
catch [System.IO.DirectoryNotFoundException] {
    Write-Host "Bist Du sicher, dass der Zielpfad existiert?"
}
# Allgemeiner Catch-Block - sollte immer vorhanden sein, und immer als letzter Catch stehen
catch {
    Write-Host "Etwas ging schief: " $_.Exception.Message
}
finally {
    # Wird immer ausgeführt, egal ob Try erfolgreich oder Catch angesprungen wurde
}



