Add-Type -AssemblyName System.IO.Compression.FileSystem
$out = "C:\Claude Workspace\Project\career-apply\docs\CareerApp\Hernick_Don_Resume_Sage_CIE.docx"
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

# -- Shorthand fragments -----------------------------------------------------
$F   = '<w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>'
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
    $rp = XRP $sz $xb $false $false
    "<w:r>$rp<w:tab/></w:r><w:r>$rp<w:t xml:space=`"preserve`">$txt</w:t></w:r>"
}
# Bullet with bold lead-in label
function XBL($label,$txt) {
    $rpb = XRP 18 $true $false $false
    $rp  = XRP 18 $false $false $false
    "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr><w:r>$rpb<w:t xml:space=`"preserve`">$label</w:t></w:r><w:r>$rp<w:t xml:space=`"preserve`">$txt</w:t></w:r></w:p>"
}

# -- Paragraphs ---------------------------------------------------------------
# Header
$p = @()
$p += "<w:p><w:pPr>$CTR$(XSP 0 20)</w:pPr>$(XRN 'DONALD T. HERNICK' 28 $true)</w:p>"
$p += "<w:p><w:pPr>$CTR$(XSP 0 20)</w:pPr>$(XRN 'Atlanta, GA (Snellville)  |  dhernick1@comcast.net  |  (678) 425-5218  |  linkedin.com/in/DonHernick' 17)</w:p>"
$p += "<w:p><w:pPr>$CTR$(XSP 0 10)</w:pPr>$(XRN 'Customer &amp; Market Insight Leadership  |  B2B Technology, CPG &amp; Consumer Health' 20 $true)</w:p>"
$p += "<w:p><w:pPr>$CTR$(XSP 0 20)</w:pPr>$(XRN 'Turning Customer, Market and Competitor Insight into Commercial Growth Across B2B and B2C Businesses' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 30)$HBDR</w:pPr></w:p>"

# Summary
$p += "<w:p><w:pPr>$(XSP 40 20)$BBDR</w:pPr>$(XRN 'PROFESSIONAL SUMMARY' 18 $true $false $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 40)</w:pPr>$(XRN 'Senior customer insight and analytics leader with 35+ years across B2B technology services, CPG and consumer healthcare. Built and led a global insight function spanning US and UK/EU teams. Nine years inside a technology company as retained insight business partner to B2B clients, translating complex data into actionable insights that shaped client strategy and drove measurable commercial performance. Trusted advisor to C-suite and senior leadership. Based in Atlanta, GA.' 18)</w:p>"

# Leadership capabilities
$p += "<w:p><w:pPr>$(XSP 50 20)$BBDR</w:pPr>$(XRN 'LEADERSHIP AND FUNCTIONAL CAPABILITIES' 18 $true $false $true)</w:p>"
$p += XBL 'Insight Strategy and Business Partnering - ' 'Nine years as retained insight and analytics business partner to B2B clients; presented insight-driven narratives to C-suite and senior management audiences that directly informed strategic decisions; built insight-led culture through a marketing insights digital portal and global research centralization.'
$p += XBL 'Voice of the Customer and Experience Measurement - ' 'Directed Voice of the Customer (VoC) studies measuring customer satisfaction and supplier performance across a B2B customer base; designed and managed a quarterly consumer panel tracking brand awareness, favorability and conversion with integrated social listening across physical and online channels.'
$p += XBL 'Team Building and Agency Management - ' 'Directed a global multi-national market research team across the US and UK/EU as one hub-and-region system; managed research partners and agencies against a multimillion-dollar global research budget; led syndicated contract negotiations saving over $2 million per year for three consecutive years.'

# Experience section header
$p += "<w:p><w:pPr>$(XSP 50 20)$BBDR</w:pPr>$(XRN 'PROFESSIONAL EXPERIENCE' 18 $true $false $true)</w:p>"

# TELUS
$p += "<w:p><w:pPr>$(XSP 30 0)$TABR</w:pPr>$(XRN 'TELUS Agriculture &amp; Consumer Goods (formerly TABS Analytics), Atlanta, GA' 18 $true)$(XRNT '2017 - 2026' 18 $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 20)</w:pPr>$(XRN 'Global communications and information technology company; analytics platforms and data services for consumer goods businesses' 17 $false $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 30)</w:pPr>$(XRN 'Senior Consultant' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Served as retained insight and analytics business partner to B2B clients across Health and Beauty Care, Household Products, Food, Nutritional and Consumer Electronics categories in North America, the EU and the UK; translated complex syndicated and primary data into actionable insights informing client strategy.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Identified incremental market opportunities and competitive targeting strategies; built deep client relationships that drove multi-year client retention (repeat renewals) and account expansion as client contacts advanced in their careers.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Designed and managed a quarterly consumer panel tracking brand awareness, favorability and conversion, integrating social listening across brick-and-mortar and online channels to monitor customer sentiment and behavior.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 40)</w:pPr>$(XRN 'Presented insight-driven narratives to C-suite and senior management audiences, directly informing strategic decisions.' 18)</w:p>"

# CSM
$p += "<w:p><w:pPr>$(XSP 50 0)$TABR</w:pPr>$(XRN 'CSM Bakery Solutions, Tucker, GA' 18 $true)$(XRNT '2003 - 2016' 18 $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 20)</w:pPr>$(XRN 'Global food company with sales over $3 billion, owned by Rhone Capital (private equity)' 17 $false $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 20 0)</w:pPr>$(XRN 'North American Consumer Insight Leader (2015 - 2016)' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Professionalized insight management, availability and delivery through a marketing insights digital portal; managed North American primary and syndicated research projects and supplier relationships.' 18)</w:p>"
$p += "<w:p><w:pPr>$(XSP 20 0)</w:pPr>$(XRN 'Global Director of Insight Development (2014 - 2015)' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Directed a global multi-national market research team delivering consumer, business-to-business and sensory insights across North America and the EU, operating US and UK/EU teams as one hub-and-region system.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Directed development, fielding and insight generation for Voice of the Customer (VoC) studies measuring customer satisfaction and supplier performance across CSM''s B2B customer base.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Managed a portfolio of global and regional primary and syndicated data resources supporting Modern Trade, Foodservice, Artisan and Industrial channels; managed research partners and agencies against a multimillion-dollar global research budget.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Globally centralized market research activity, significantly decreasing costs while increasing research utilization and efficiency.' 18)</w:p>"
$p += "<w:p><w:pPr>$(XSP 20 0)</w:pPr>$(XRN 'Director of Marketing, Consumer Insight and Strategic Development (2009 - 2014)' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Built and led the market research team and insight portfolio across retail and foodservice channels; served as the insights partner to innovation teams, delivering consumer research at Stage-Gate checkpoints to inform product development decisions.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Co-authored the Foodservice Full Plate Category Management Best Practice for the Foodservice Advisory Board.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Partnered with executive management, Bain, BCG and McKinsey on market modeling, organizational design and divestiture positioning; named to the CSM Divestiture Team and recognized for the contribution. Created a Central Location Testing methodology saving over $600,000 per year.' 18)</w:p>"
$p += "<w:p><w:pPr>$(XSP 20 0)</w:pPr>$(XRN 'Director of Marketing, In-Store Bakery (2005 - 2009)' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Appointed by the CEO to lead the Global Marketing Team across North America and the EU; managed a portfolio of three major B2B brands with annual sales over $500 million; key commercial contact with Bain Consulting for the first formal long-term category and channel strategy.' 18)</w:p>"
$p += "<w:p><w:pPr>$(XSP 20 0)</w:pPr>$(XRN 'Director of Marketing (2003 - 2005)' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 40)</w:pPr>$(XRN 'Built and led an industry-leading marketing and customer marketing organization from the ground up; established Category Management in the fresh bakery space in the US grocery channel.' 18)</w:p>"

# Bayer
$p += "<w:p><w:pPr>$(XSP 50 0)$TABR</w:pPr>$(XRN 'Bayer Consumer Care, Morristown, NJ' 18 $true)$(XRNT '1997 - 2003' 18 $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 20)</w:pPr>$(XRN 'Consumer healthcare manufacturer of Bayer, Aleve, One-A-Day and Alka-Seltzer' 17 $false $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 20 0)</w:pPr>$(XRN 'National Category Development Manager, Global and US HQ (2001 - 2003)' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Developed the National Category Leadership strategy for the Nutritional and Upper Respiratory categories; presented category line reviews to Walmart, Target and national Food and Drug retailers.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Directed the Circana (IRI) Bayer client service team and led sales training in market research tools and studies; won the Divisional HQ Sales Bayer Care Award for leadership of the syndicated contract process, saving over $2 million per year for three consecutive years.' 18)</w:p>"
$p += "<w:p><w:pPr>$(XSP 20 0)</w:pPr>$(XRN 'Group Head Customer Marketing, Canada (1999 - 2001)' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Redesigned and re-staffed the Customer Marketing department on an expatriate leadership assignment; developed incremental contingency plans that drove the division past its 2000 sales budget, +10% vs. 1999, while increasing OPE +344%.' 18)</w:p>"
$p += "<w:p><w:pPr>$(XSP 20 0)</w:pPr>$(XRN 'National Customer Marketing Manager (1997 - 1999)' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 40)</w:pPr>$(XRN 'Managed a $17M trade budget supporting $131M in 1998 sales (+128% vs. 1997); key member of the One-A-Day Herbal launch core team, securing 98% trade acceptance and exceeding sales targets by 36%.' 18)</w:p>"

# Playtex
$p += "<w:p><w:pPr>$(XSP 50 0)$TABR</w:pPr>$(XRN 'Playtex Products (now Edgewell Personal Care), Westport, CT' 18 $true)$(XRNT '1986 - 1997' 18 $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 30)</w:pPr>$(XRN 'Progressive sales leadership: National Account Manager / National Sales Merchandising Manager / District Sales Manager / Regional Sales Trainer' 18 $false $true)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 30)</w:pPr>$(XRN 'Led HQ sales calls and new item launches for major drug and grocery accounts driving $23M in volume (+8.4%); exceeded quota at 105% and 107% vs. division averages of 95% and 90.6%.' 18)</w:p>"
$p += "<w:p><w:pPr>$NUM$(XSP 0 40)</w:pPr>$(XRN 'Advanced the Houston, TX district from 31st to 1st in the nation within 2 years as District Sales Manager.' 18)</w:p>"

# Education
$p += "<w:p><w:pPr>$(XSP 50 20)$BBDR</w:pPr>$(XRN 'EDUCATION' 18 $true $false $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 40)</w:pPr>$(XRN 'University of Florida - B.S. Business Administration, Marketing' 18)</w:p>"

# Skills
$p += "<w:p><w:pPr>$(XSP 50 20)$BBDR</w:pPr>$(XRN 'ADVANCED TECHNICAL SKILLS' 18 $true $false $true)</w:p>"
$p += "<w:p><w:pPr>$(XSP 0 0)</w:pPr>$(XRN 'Customer and Market Insights (CMI)  |  Voice of the Customer (VoC)  |  Customer satisfaction and experience measurement  |  Brand health tracking  |  Insight strategy development  |  C-suite business partnering  |  Research agency and partner management  |  Insight-led culture building  |  Advanced analytics  |  Qualitative and quantitative research: A&amp;U, Segmentation, Customer Satisfaction, Concept, Price Elasticity, Omnibus  |  Nielsen and Circana POS and panel  |  Spectra, Spire, Datassential, Technomic, Kantar Retail Shopper Insight Panel  |  Qualtrics  |  Stage-Gate certified  |  Executive storytelling  |  AI fluency' 18)</w:p>"

# Section properties
$sectPr = '<w:sectPr><w:pgSz w:w="12240" w:h="15840"/><w:pgMar w:top="720" w:right="720" w:bottom="720" w:left="720" w:header="0" w:footer="0" w:gutter="0"/></w:sectPr>'

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
[System.IO.File]::WriteAllText("$tmp\word\numbering.xml",         $numbering,$enc)
[System.IO.File]::WriteAllText("$tmp\word\styles.xml",            $styles,   $enc)
[System.IO.File]::WriteAllText("$tmp\word\document.xml",          $doc,      $enc)

# -- Zip ------------------------------------------------------------------------
if (Test-Path $out) { Remove-Item $out -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($tmp, $out)
Remove-Item $tmp -Recurse -Force

Write-Output "Done: $out"
