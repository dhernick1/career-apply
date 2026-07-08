Add-Type -AssemblyName System.IO.Compression.FileSystem
$out = "C:\Claude Workspace\Project\career-apply\docs\CareerApp\Hernick_Don_CoverLetter_Sage.docx"
$tmp = "$env:TEMP\hr_$(Get-Random)"
New-Item -ItemType Directory -Force "$tmp" | Out-Null
New-Item -ItemType Directory -Force "$tmp\_rels" | Out-Null
New-Item -ItemType Directory -Force "$tmp\word" | Out-Null
New-Item -ItemType Directory -Force "$tmp\word\_rels" | Out-Null
$enc = New-Object System.Text.UTF8Encoding $false

# -- XML components ----------------------------------------------------------
$ct = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
<Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
<Override PartName="/word/settings.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml"/>
</Types>'

$rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>'

$wrels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>
</Relationships>'

$settings = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:settings xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:defaultTabStop w:val="720"/>
<w:compat><w:compatSetting w:name="compatibilityMode" w:uri="http://schemas.microsoft.com/office/word" w:val="15"/></w:compat>
</w:settings>'

$styles = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:docDefaults>
<w:rPrDefault><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>
<w:sz w:val="22"/><w:szCs w:val="22"/><w:lang w:val="en-US"/></w:rPr></w:rPrDefault>
<w:pPrDefault><w:pPr><w:spacing w:after="0" w:line="240" w:lineRule="auto"/></w:pPr></w:pPrDefault>
</w:docDefaults>
<w:style w:type="paragraph" w:default="1" w:styleId="Normal">
<w:name w:val="Normal"/>
<w:pPr><w:spacing w:after="0" w:line="240" w:lineRule="auto"/></w:pPr>
<w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:sz w:val="22"/><w:szCs w:val="22"/></w:rPr>
</w:style>
<w:style w:type="character" w:default="1" w:styleId="DefaultParagraphFont">
<w:name w:val="Default Paragraph Font"/></w:style>
</w:styles>'

# -- Shorthand ----------------------------------------------------------------
$F   = '<w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>'
$CTR = '<w:jc w:val="center"/>'
$HBDR= '<w:pBdr><w:bottom w:val="single" w:sz="8" w:space="1" w:color="000000"/></w:pBdr>'

function XSP($b,$a) { "<w:spacing w:before=`"$b`" w:after=`"$a`" w:line=`"240`" w:lineRule=`"auto`"/>" }
function XRP($sz,$xb,$xi) {
    $xbb = if($xb){"<w:b/>"}else{""}
    $xii = if($xi){"<w:i/>"}else{""}
    "<w:rPr>$F$xbb$xii<w:sz w:val=`"$sz`"/><w:szCs w:val=`"$sz`"/></w:rPr>"
}
function XRN($txt,$sz=22,$xb=$false,$xi=$false) {
    $rp = XRP $sz $xb $xi
    "<w:r>$rp<w:t xml:space=`"preserve`">$txt</w:t></w:r>"
}
function PARA($txt,$before=0,$after=200) {
    "<w:p><w:pPr>$(XSP $before $after)</w:pPr>$(XRN $txt)</w:p>"
}

# -- Paragraphs ---------------------------------------------------------------
$p = @()
$p += "<w:p><w:pPr>$CTR$(XSP 0 20)</w:pPr>$(XRN 'DONALD T. HERNICK' 28 $true)</w:p>"
$p += "<w:p><w:pPr>$CTR$(XSP 0 20)</w:pPr>$(XRN 'Atlanta, GA (Snellville)  |  dhernick1@comcast.net  |  (678) 425-5218' 20)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 200)$HBDR</w:pPr></w:p>"

$p += PARA 'July 8, 2026' 100 200
$p += PARA 'Sage Hiring Team' 0 0
$p += PARA 'Sage North America Headquarters' 0 0
$p += PARA 'Ponce City Market, Atlanta, GA' 0 200
$p += "<w:p><w:pPr>$(XSP 0 200)</w:pPr>$(XRN 'Re: Director of Customer Insight &amp; Experience for North America' 22 $true)</w:p>"

$p += PARA 'Dear Sage Hiring Team,' 0 200

$p += PARA 'Sage is not maintaining a North American presence. You are building one. A new headquarters at Ponce City Market, two expansions in two years, and the region growing at 14 percent. The Director of Customer Insight &amp; Experience who steps into this moment gets a real mandate: make insight the engine of that growth.' 0 200

$p += PARA 'I have done this work. I built and led a global insight function for a $3 billion company, with a US team and a UK/EU team working as one hub-and-region system. I know what a regional leader owes a central hub in London, and what the hub owes the region, because I have run that exchange.' 0 200

$p += PARA 'For nine years I worked inside a technology company as a retained insight partner to B2B clients. I didn''t just deliver research. I translated complex data into decisions clients acted on, and they renewed year after year because of it. I have presented insight-driven narratives to C-suites for three decades, directed Voice of the Customer programs measuring satisfaction across a B2B customer base, and managed research partners against multimillion-dollar budgets.' 0 200

$p += PARA 'Atlanta is home. No relocation, no delay, three days at Ponce City Market from day one.' 0 200

$p += PARA 'I will follow up the week of July 20 to discuss how customer insight can keep North America Sage''s fastest-growing region.' 0 200

$p += PARA 'Sincerely,' 100 0
$p += PARA 'Donald T. Hernick' 0 0

# Section properties
$sectPr = '<w:sectPr><w:pgSz w:w="12240" w:h="15840"/><w:pgMar w:top="1080" w:right="1440" w:bottom="1080" w:left="1440" w:header="0" w:footer="0" w:gutter="0"/></w:sectPr>'

# -- Assemble document --------------------------------------------------------
$body = ($p -join '') + $sectPr
$doc = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
$doc += '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">'
$doc += "<w:body>$body</w:body></w:document>"

# -- Write files ---------------------------------------------------------------
[System.IO.File]::WriteAllText("$tmp\[Content_Types].xml",        $ct,       $enc)
[System.IO.File]::WriteAllText("$tmp\_rels\.rels",                $rels,     $enc)
[System.IO.File]::WriteAllText("$tmp\word\_rels\document.xml.rels",$wrels,   $enc)
[System.IO.File]::WriteAllText("$tmp\word\settings.xml",          $settings, $enc)
[System.IO.File]::WriteAllText("$tmp\word\styles.xml",            $styles,   $enc)
[System.IO.File]::WriteAllText("$tmp\word\document.xml",          $doc,      $enc)

# -- Zip ------------------------------------------------------------------------
if (Test-Path $out) { Remove-Item $out -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($tmp, $out)
Remove-Item $tmp -Recurse -Force

Write-Output "Done: $out"
