Add-Type -AssemblyName System.IO.Compression.FileSystem
$out = "C:\Claude Workspace\Project\career-apply\docs\CareerApp\Hernick_Don_Resume_GeorgiaPacific.docx"
$tmp = "$env:TEMP\hr_$(Get-Random)"
New-Item -ItemType Directory -Force "$tmp" | Out-Null
New-Item -ItemType Directory -Force "$tmp\_rels" | Out-Null
New-Item -ItemType Directory -Force "$tmp\word" | Out-Null
New-Item -ItemType Directory -Force "$tmp\word\_rels" | Out-Null
$enc = New-Object System.Text.UTF8Encoding $false

# â”€â”€ XML components â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
$ct = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
<Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
<Override PartName="/word/settings.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml"/>
<Override PartName="/word/numbering.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.numbering+xml"/>
</Types>'

$rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>'

$wrels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering" Target="numbering.xml"/>
</Relationships>'

$settings = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:settings xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:defaultTabStop w:val="720"/>
<w:compat><w:compatSetting w:name="compatibilityMode" w:uri="http://schemas.microsoft.com/office/word" w:val="15"/></w:compat>
</w:settings>'

$numbering = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:numbering xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:abstractNum w:abstractNumId="0">
<w:multiLevelType w:val="singleLevel"/>
<w:lvl w:ilvl="0">
<w:start w:val="1"/><w:numFmt w:val="bullet"/>
<w:lvlText w:val="&#xF0B7;"/>
<w:lvlJc w:val="left"/>
<w:pPr><w:ind w:left="288" w:hanging="180"/></w:pPr>
<w:rPr><w:rFonts w:ascii="Symbol" w:hAnsi="Symbol"/><w:sz w:val="16"/><w:szCs w:val="16"/></w:rPr>
</w:lvl></w:abstractNum>
<w:num w:numId="1"><w:abstractNumId w:val="0"/></w:num>
</w:numbering>'

$styles = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:docDefaults>
<w:rPrDefault><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>
<w:sz w:val="18"/><w:szCs w:val="18"/><w:lang w:val="en-US"/></w:rPr></w:rPrDefault>
<w:pPrDefault><w:pPr><w:spacing w:after="0" w:line="240" w:lineRule="auto"/></w:pPr></w:pPrDefault>
</w:docDefaults>
<w:style w:type="paragraph" w:default="1" w:styleId="Normal">
<w:name w:val="Normal"/>
<w:pPr><w:spacing w:after="0" w:line="240" w:lineRule="auto"/></w:pPr>
<w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:sz w:val="18"/><w:szCs w:val="18"/></w:rPr>
</w:style>
<w:style w:type="character" w:default="1" w:styleId="DefaultParagraphFont">
<w:name w:val="Default Paragraph Font"/></w:style>
</w:styles>'

# â”€â”€ Shorthand fragments â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
$F   = '<w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>'
$S18 = '<w:sz w:val="18"/><w:szCs w:val="18"/>'
$S20 = '<w:sz w:val="20"/><w:szCs w:val="20"/>'
$S28 = '<w:sz w:val="28"/><w:szCs w:val="28"/>'
$B   = '<w:b/>'
$IT  = '<w:i/>'
$CP  = '<w:caps/>'
$CTR = '<w:jc w:val="center"/>'
$NUM = '<w:numPr><w:ilvl w:val="0"/><w:numId w:val="1"/></w:numPr>'
$TABR= '<w:tabs><w:tab w:val="right" w:pos="10800"/></w:tabs>'
$BBDR= '<w:pBdr><w:bottom w:val="single" w:sz="4" w:space="1" w:color="000000"/></w:pBdr>'
$HBDR= '<w:pBdr><w:bottom w:val="single" w:sz="8" w:space="1" w:color="000000"/></w:pBdr>'

function XSP($b,$a) { "<w:spacing w:before=`"$b`" w:after=`"$a`" w:line=`"240`" w:lineRule=`"auto`"/>" }
function XRP($sz,$xb,$xi,$xc) {
    $xbb = if($xb){"<w:b/>"}else{""}
    $xii = if($xi){"<w:i/>"}else{""}
    $xcc = if($xc){"<w:caps/>"}else{""}
    "<w:rPr>$F$xbb$xii<w:sz w:val=`"$sz`"/><w:szCs w:val=`"$sz`"/>$xcc</w:rPr>"
}
function XRN($txt,$sz=18,$xb=$false,$xi=$false,$xc=$false) {
    $rp = XRP $sz $xb $xi $xc
    "<w:r>$rp<w:t xml:space=`"preserve`">$txt</w:t></w:r>"
}
function XRNT($txt,$sz=18,$xb=$false) {
    $rp = XRP $sz $xb
    "<w:r>$rp<w:tab/></w:r><w:r>$rp<w:t xml:space=`"preserve`">$txt</w:t></w:r>"
}

# â”€â”€ Paragraphs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
# Header
$p1 = "<w:p><w:pPr>$CTR$(XSP 0 20)</w:pPr>$(XRN 'DONALD T. HERNICK' 28 $true)</w:p>"
$p2 = "<w:p><w:pPr>$CTR$(XSP 0 20)</w:pPr>$(XRN 'Snellville, GA  |  dhernick1@comcast.net  |  (678) 425-5218  |  linkedin.com/in/DonHernick' 17)</w:p>"
$p3 = "<w:p><w:pPr>$CTR$(XSP 0 20)</w:pPr>$(XRN 'Senior Consumer Insights &amp; Market Research Leader - CPG | Director | Team Builder' 20 $true)</w:p>"
$p4 = "<w:p><w:pPr>$(XSP 0 30)$HBDR</w:pPr></w:p>"

# Summary
$p5 = "<w:p><w:pPr>$(XSP 40 20)$BBDR</w:pPr>$(XRN 'PROFESSIONAL SUMMARY' 18 $true $false $true)</w:p>"
$p6 = "<w:p><w:pPr>$(XSP 0 40)</w:pPr>$(XRN 'Senior Consumer Insights and Market Research leader with 35+ years in CPG, Consumer Healthcare, and Fresh Foods. Built and directed high-performing research teams, managed multimillion-dollar insights agendas, and served as a strategic thought leader translating qualitative and quantitative research into actionable business strategies for executive stakeholders across global organizations.' 18)</w:p>"

# Experience section header
$p7 = "<w:p><w:pPr>$(XSP 50 20)$BBDR</w:pPr>$(XRN 'PROFESSIONAL EXPERIENCE' 18 $true $false $true)</w:p>"

# TELUS
$p8  = "<w:p><w:pPr>$(XSP 30 0)$TABR</w:pPr>$(XRN 'TELUS Agriculture &amp; Consumer Goods, Atlanta, GA' 18 $true)$(XRNT '2017-2026' 18 $true)</w:p>"
$p9  = "<w:p><w:pPr>$(XSP 0 30)</w:pPr>$(XRN 'Senior Consultant' 18 $false $true)</w:p>"
$p10 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Delivered consumer insights and actionable business strategies to retained CPG clients across Health and Beauty Care, Household Products, Food, Nutritional, and Consumer Electronics in North American, EU, and UK markets.' 18)</w:p>"
$p11 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Served as strategic thought leader to senior client stakeholders; identified incremental growth opportunities and competitive positioning strategies, delivering insights that drove repeat renewals and new business.' 18)</w:p>"
$p12 = "<w:p><w:pPr>$NUM$(XSP 0 40)</w:pPr>$(XRN 'Developed and managed a quarterly consumer panel study tracking Brand Awareness, Favorability, and Conversion; incorporated social listening data across brick-and-mortar and online retail channels to surface shifts in consumer sentiment and behavior.' 18)</w:p>"

# CSM
$p13 = "<w:p><w:pPr>$(XSP 50 0)$TABR</w:pPr>$(XRN 'CSM Bakery Solutions, Tucker, GA' 18 $true)$(XRNT '2003-2016' 18 $true)</w:p>"
$p14 = "<w:p><w:pPr>$(XSP 0 30)</w:pPr>$(XRN 'Director of Marketing / Global Director of Insight Development (progressive roles)' 18 $false $true)</w:p>"
$p15 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Globally centralized market research activity, significantly decreasing costs while increasing utilization; led a team of 5 direct and 4 indirect reports delivering insights across an international sales and product marketing organization.' 18)</w:p>"
$p16 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Built and directed a full-cycle consumer insights function covering the complete product lifecycle from innovation research and concept testing through commercialization and post-launch learning across retail and foodservice channels.' 18)</w:p>"
$p17 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Collaborated with cross-functional innovation pipeline teams as the consumer insights representative, translating voice of the consumer research into product development and commercialization decisions across global markets.' 18)</w:p>"
$p18 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Partnered with Bain, BCG, and McKinsey on market modeling, strategic development, and the CSM Divestiture; created a CLT methodology saving $600,000 per year in primary research costs.' 18)</w:p>"
$p19 = "<w:p><w:pPr>$NUM$(XSP 0 40)</w:pPr>$(XRN 'Managed comprehensive portfolio of primary and syndicated data resources; accountable for multimillion-dollar global research budget and all external research vendor relationships.' 18)</w:p>"

# Bayer
$p20 = "<w:p><w:pPr>$(XSP 50 0)$TABR</w:pPr>$(XRN 'Bayer Consumer Care, Morristown, NJ' 18 $true)$(XRNT '1997-2003' 18 $true)</w:p>"
$p21 = "<w:p><w:pPr>$(XSP 0 30)</w:pPr>$(XRN 'National Category Development Manager / Group Head Customer Marketing, Canada / National Customer Marketing Manager' 18 $false $true)</w:p>"
$p22 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Developed National Category Leadership strategy for Nutritional and Upper Respiratory categories; directed the Circana Bayer client service team and managed 5 direct reports.' 18)</w:p>"
$p23 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Supported item copy testing and packaging research for the consumer brand portfolio, translating findings into brand positioning and go-to-market recommendations.' 18)</w:p>"
$p24 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Won Divisional Bayer Care Award for syndicated contract leadership - $2M+ annual savings for three consecutive years.' 18)</w:p>"
$p25 = "<w:p><w:pPr>$NUM$(XSP 0 40)</w:pPr>$(XRN 'Managed $17M trade budget supporting $131M in 1998 sales (+128% vs. 1997); led One-A-Day Herbal launch to 98% trade acceptance, exceeding sales targets by 36%.' 18)</w:p>"

# Playtex
$p26 = "<w:p><w:pPr>$(XSP 50 0)$TABR</w:pPr>$(XRN 'Playtex Products (now Edgewell Personal Care), Westport, CT' 18 $true)$(XRNT '1986-1997' 18 $true)</w:p>"
$p27 = "<w:p><w:pPr>$(XSP 0 30)</w:pPr>$(XRN 'National Account Manager / National Sales Merchandising Manager / District Sales Manager (progressive roles)' 18 $false $true)</w:p>"
$p28 = "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Led HQ sales calls for major drug/grocery accounts driving $23M in volume (+8.4%); exceeded quota at 105% in 1996 vs. the division average of 95%.' 18)</w:p>"
$p29 = "<w:p><w:pPr>$NUM$(XSP 0 40)</w:pPr>$(XRN 'Advanced Houston district from 31st to 1st in the nation within 2 years as District Sales Manager.' 18)</w:p>"

# Education
$p30 = "<w:p><w:pPr>$(XSP 50 20)$BBDR</w:pPr>$(XRN 'EDUCATION' 18 $true $false $true)</w:p>"
$p31 = "<w:p><w:pPr>$(XSP 0 40)</w:pPr>$(XRN 'University of Florida - B.S. Business Administration, Marketing' 18)</w:p>"

# Skills
$p32 = "<w:p><w:pPr>$(XSP 50 20)$BBDR</w:pPr>$(XRN 'ADVANCED TECHNICAL SKILLS' 18 $true $false $true)</w:p>"
$p33 = "<w:p><w:pPr>$(XSP 0 0)</w:pPr>$(XRN 'Consumer insights  |  Market research  |  Qualitative and quantitative research  |  Nielsen / Circana / Spectra  |  Brand equity and awareness tracking  |  Copy testing and packaging research  |  Social listening  |  Voice of the consumer (VoC)  |  Innovation pipeline  |  Stage-Gate (certified)  |  Qualtrics  |  AI fluency  |  Category management (FDM / Foodservice)  |  Executive storytelling  |  Power BI' 18)</w:p>"

# Section properties
$sectPr = '<w:sectPr><w:pgSz w:w="12240" w:h="15840"/><w:pgMar w:top="720" w:right="720" w:bottom="720" w:left="720" w:header="0" w:footer="0" w:gutter="0"/></w:sectPr>'

# â”€â”€ Assemble document â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
$body  = $p1+$p2+$p3+$p4
$body += $p5+$p6
$body += $p7
$body += $p8+$p9+$p10+$p11+$p12
$body += $p13+$p14+$p15+$p16+$p17+$p18+$p19
$body += $p20+$p21+$p22+$p23+$p24+$p25
$body += $p26+$p27+$p28+$p29
$body += $p30+$p31
$body += $p32+$p33
$body += $sectPr

$doc = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
$doc += '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">'
$doc += "<w:body>$body</w:body></w:document>"

# â”€â”€ Write files â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
[System.IO.File]::WriteAllText("$tmp\[Content_Types].xml",        $ct,       $enc)
[System.IO.File]::WriteAllText("$tmp\_rels\.rels",                $rels,     $enc)
[System.IO.File]::WriteAllText("$tmp\word\_rels\document.xml.rels",$wrels,   $enc)
[System.IO.File]::WriteAllText("$tmp\word\settings.xml",          $settings, $enc)
[System.IO.File]::WriteAllText("$tmp\word\numbering.xml",         $numbering,$enc)
[System.IO.File]::WriteAllText("$tmp\word\styles.xml",            $styles,   $enc)
[System.IO.File]::WriteAllText("$tmp\word\document.xml",          $doc,      $enc)

# â”€â”€ Zip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
if (Test-Path $out) { Remove-Item $out -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($tmp, $out)
Remove-Item $tmp -Recurse -Force

Write-Output "Done: $out"
