& "tshark.exe" -r .\eportal.pcapng -o tls.keylog_file:"sslkeylogfile.txt" -Y 'http.response_for.uri matches \"eportal.pwr.edu.pl/mod/quiz/\"'  -n -Tfields -e tcp.stream > tcp_streams.txt
gc .\tcp_streams.txt | sort | get-unique > .\tcp_streams2.txt
if (Test-Path -PathType Container -Path "$pwd/eportal" ) {
    Remove-Item "$pwd/eportal/*"
}
foreach($line in Get-Content .\tcp_streams2.txt) {
    & "tshark.exe" -r .\eportal.pcapng -o tls.keylog_file:"sslkeylogfile.txt" -Y "tcp.stream eq $line" -w "$line.pcapng"
	& "tshark.exe" -r "$line.pcapng" -o tls.keylog_file:"sslkeylogfile.txt" --export-objects "http,eportal"
	Remove-Item "$line.pcapng"
}
Remove-Item .\tcp_streams.txt
Remove-Item .\tcp_streams2.txt
Get-ChildItem "eportal" | Foreach-Object {
    if(!($_.Name -Match "attempt.php") -and !($_.Name -Match "review.php")) {
		Remove-Item -Path $_.FullName
	}
}
if (Test-Path -Path "$pwd/eportal/startattempt.php" ) {
    Remove-Item "$pwd/eportal/startattempt.php"
}
Remove-Item "$pwd/eportal/processattempt.php*"
$pages = 0;
Get-ChildItem "eportal" | Foreach-Object {
    if($_.Name -Match "page=") {
		$page = ($_.Name -split "page=")[1]
		$page = [int]$page+1;
		Rename-Item -Path $_.FullName -NewName ("page"+$page+".html")
		if ($page -gt $pages) {
			$pages = $page
		}
	} else { #elseif ($_.Name -Match "attempt.php"){
		Rename-Item -Path $_.FullName -NewName ("page1.html")
	} #else {
	#	Rename-Item -Path $_.FullName -NewName ("answers.html")
	#}
	if ($_.Name -Match "review.php") {
		Rename-Item -Path $_.FullName -NewName ("answers.html")
	}
}
& "node.exe" index.js $pages
& "node.exe" merge.js $pages