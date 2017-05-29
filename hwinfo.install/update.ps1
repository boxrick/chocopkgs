Import-Module au

$releases = 'https://www.hwinfo.com/download.php'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*[$]url64\s*=\s*)('.*')"        = "`$1'$($Latest.URL64)'"
	    "(?i)(^\s*[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(?i)(^\s*[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*[$]checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {
	$Matches = $null
	$download_page = (iwr $releases -UseBasicParsing).Content -match '(?<=<h1>.*v)\d\.\d+'
	$version = $Matches[0]
	$urlvers = $version.Replace(".","")
	$url   = "https://www.hwinfo.com/files/hw32_$urlvers.exe"
	$url64 = "https://www.hwinfo.com/files/hw64_$urlvers.exe"

	return @{ Version = $version; URL32 = $url; URL64 = $url64 }
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
	Update-Package -NoCheckUrl
}