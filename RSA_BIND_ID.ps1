Function Get-BindID 
{ 
    [CmdletBinding(DefaultParameterSetName = "_AllParameterSets")]
    [OutputType()] 
    Param(
            [Parameter( 
                Mandatory = $false, 
                ParameterSetName = "local")]
            [switch]$local,

            [Parameter(
                Mandatory = $false,
                ParameterSetName = "csv")]
            [switch]$csv
    )

    Function Get-BindID-LocalString
    {
        Write-Verbose -Message "Gathering strings" 
        #Gather information to become the RSA Binding ID 
        $RSA = 'RSA Copyright 2008' 
        $SID = [wmi] "win32_userAccount.Domain='$Env:USERDOMAIN',Name='$ENV:UserName'" | Select-Object -ExpandProperty SID 
        $RSASTRING = $env:COMPUTERNAME + $SID + $RSA #String to be hashed 
         
        Write-Verbose -Message "$env:COMPUTERNAME" 
        Write-Verbose -Message "$SID" 
        Write-Verbose -Message "$RSA"
    } #Function Get-BindID-localstring

    Function Get-BindID-CreateBindID
    {
        #Create a SHA1 hash to the $RSASTRING 
        $sha1 = [Type]"System.Security.Cryptography.SHA1" 
        $crypto = $sha1::Create() 
        $utf8 = New-Object -TypeName System.Text.UTF8Encoding  
        $Hash = [System.BitConverter]::ToString( 
                    $crypto.ComputeHash( 
                        $utf8.GetBytes( 
                            "${RSASTRING}" 
                ) 
            ) 
        ).Replace( 
        "-", "" 
        ) 
        $BindID = $Hash.SubString( 
            0, 20 #Character length of the RSA Binding ID. 
        ) 
        Write-Output $BindID
        } #Function Get-BindID-CreateBindID 
} #Function Get-BindID
