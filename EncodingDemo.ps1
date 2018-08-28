$TextFiles = (gci "$PSScriptRoot\Samples\*.txt")


$EncodingCollection = @(
    [System.Text.Encoding]::UTF8,
    [System.Text.Encoding]::ASCII,
    [System.Text.Encoding]::GetEncoding("Windows-1252")
)

$ResultCollection = @()
foreach ($file in $TextFiles) 
{
    $FileName = $file.Name

    $bytes = [System.IO.File]::ReadAllBytes( $file.FullName )

    
    $ResultCollection += New-Object psobject -Property @{ 
        file = $FileName
        encoding = "Bytes"
        value = [System.BitConverter]::ToString($bytes)
        sameAs = @()
    }

    foreach ($Encoding in $EncodingCollection) {
        $EncodingName = $Encoding.HeaderName
        $ResultCollection += New-Object psobject -Property @{ 
            file = $FileName
            encoding = $EncodingName
            value = $Encoding.GetString($bytes)
            "== Operator" = @()
            "String.Equals" = @()
        }
    }

}


$ResultCollection = $ResultCollection | %  { Add-Member -MemberType ScriptMethod ToString { $this.file + "(" + $this.encoding + ")" } -InputObject $_ -PassThru -Force }

for ($i=0; $i -lt $ResultCollection.Count; $i++) {
    for ($j=$i+1; $j -lt $ResultCollection.Count; $j++) {
        if ($ResultCollection[$i].value.Equals( $ResultCollection[$j].value) ){
            $ResultCollection[$i]."String.Equals" += $ResultCollection[$j]
            $ResultCollection[$j]."String.Equals" += $ResultCollection[$i]
        }
        if ($ResultCollection[$i].value -eq $ResultCollection[$j].value ){
            $ResultCollection[$i]."== Operator" += $ResultCollection[$j]
            $ResultCollection[$j]."== Operator" += $ResultCollection[$i]
        }
    }
}

$ResultCollection | Sort -Property @('file', 'encoding') | Format-Table -Property @('file', 'encoding', 'value', '== Operator', 'String.Equals') -AutoSize -

pause