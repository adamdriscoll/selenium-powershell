Function Get-WildcardsIndices($Value) {
   
    $Escape = 0
    $Index = -1 
    $Value.ToCharArray() | ForEach-Object {
        $Index += 1
        $IsWildCard = $false
        switch ($_) {
            '`' { $Escape += 1; break }
            '*' { $IsWildCard = $Escape % 2 -eq 0; $Escape = 0 }
            Default { $Escape = 0 }
        }
        if ($IsWildCard) { return $Index }
 
    }
}