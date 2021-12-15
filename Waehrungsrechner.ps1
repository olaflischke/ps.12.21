# Benutzer gibt eine Fremwährung und einen Betrag in Fremdwährung ein.
# Skript berechnet Euro-Betrag.

# Beispiel
# Waehrung (USD, DKK, NOK, GBP, TRL): 
# DKK
# Gib einen Betrag in DKK ein:
# 15
# 2,01 EUR

function Get-EuroBetrag {
    param (
        # Betrag in Fremdwährung
        [double]$Fremd,
        # Wechselkurs zum Euro (1 EUR = Rate)
        [double]$Rate
    )
    
    $euro = $Fremd / $Rate

    return $euro
}

function Get-EuroRatePerXml {
    param (
        $waehrung
    )
    # try {
    # aus EZB-XML die Rate zurückgeben
    [xml]$ezbDaten = Invoke-WebRequest -UseBasicParsing 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'
       
    [double]$rate = $ezbDaten.Envelope.Cube.Cube.Cube | Where-Object -FilterScript { $_.currency -eq $waehrung } | Select-Object -ExpandProperty rate

    return $rate
    # }
    # catch {
    #     Write-Host "Fehler beim Lesen der XML-Datei: " $_.Exception.Message
    #     break
    # }
    #$waehrungsCube = $ezbDaten.Envelope.Cube.Cube.Cube | Where-Object -FilterScript { $_.currency -eq $waehrung } 
    # $rate = $waehrungsCube.rate

}

function Get-EuroRate {
    param (
        $Waehrung
    )

    $rate = 0
    
    switch ($waehrung) {
        "USD" { $rate = 1.1309 }
        "DKK" { $rate = 7.4362 }
        "NOK" { $rate = 10.2475 }
        "GBP" { $rate = 0.85345 }
        "TRY" { $rate = 16.2092 }
        Default {
            throw "Keine gueltige Waehrung!"
        }
    }

    return $rate
}

$waehrung = Read-Host "Waehrung"

try {
    $rate = Get-EuroRatePerXml -Waehrung $waehrung

    if ($rate -gt 0) {
        $fremd = Read-Host "Gib einen Betrag in $waehrung ein"

        $euro = Get-EuroBetrag -Fremd $fremd -Rate $rate

        Write-Host $euro.ToString("c2") " EUR"
        #"{0:n2} {1} sind {2:c2}" -f $fremd, $symbol, $euro
    }
    else {
        "Die Rate war 0. Bist Du Dir mit der Währung sicher?"
    }
}
catch {
    Write-Host "Fehler beim Lesen der XML-Datei: " $_.Exception.Message
}
