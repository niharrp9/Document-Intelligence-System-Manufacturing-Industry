$ErrorActionPreference = 'Stop'

$outDir = Join-Path $PSScriptRoot 'output'
$stageDir = Join-Path $PSScriptRoot '.pptx-stage'
New-Item -ItemType Directory -Force -Path $outDir, $stageDir | Out-Null
Get-ChildItem -LiteralPath $stageDir -Force | Remove-Item -Recurse -Force

function Write-Part([string]$relativePath, [string]$content) {
  $target = Join-Path $stageDir $relativePath
  New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
  [System.IO.File]::WriteAllText($target, $content, [System.Text.UTF8Encoding]::new($false))
}

Write-Part '[Content_Types].xml' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>
  <Override PartName="/ppt/slides/slide1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
  <Override PartName="/ppt/slideMasters/slideMaster1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/>
  <Override PartName="/ppt/slideLayouts/slideLayout1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>
  <Override PartName="/ppt/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>
  <Override PartName="/ppt/presProps.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presProps+xml"/>
  <Override PartName="/ppt/viewProps.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.viewProps+xml"/>
</Types>
'@

Write-Part '_rels/.rels' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>
</Relationships>
'@

Write-Part 'ppt/presentation.xml' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:sldMasterIdLst><p:sldMasterId id="2147483648" r:id="rId1"/></p:sldMasterIdLst>
  <p:sldIdLst><p:sldId id="256" r:id="rId2"/></p:sldIdLst>
  <p:sldSz cx="12192000" cy="6858000" type="screen16x9"/>
  <p:notesSz cx="6858000" cy="9144000"/>
  <p:defaultTextStyle/>
</p:presentation>
'@

Write-Part 'ppt/_rels/presentation.xml.rels' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="slideMasters/slideMaster1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide1.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/presProps" Target="presProps.xml"/>
  <Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/viewProps" Target="viewProps.xml"/>
</Relationships>
'@

Write-Part 'ppt/presProps.xml' '<p:presentationPr xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"/>'
Write-Part 'ppt/viewProps.xml' '<p:viewPr xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:normalViewPr/><p:slideViewPr><p:cSldViewPr><p:cViewPr varScale="1"><p:scale><a:sx xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" n="1" d="1"/><a:sy xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" n="1" d="1"/></p:scale></p:cViewPr></p:cSldViewPr></p:slideViewPr><p:notesTextViewPr/></p:viewPr>'

Write-Part 'ppt/theme/theme1.xml' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Executive"><a:themeElements><a:clrScheme name="Executive"><a:dk1><a:srgbClr val="102A43"/></a:dk1><a:lt1><a:srgbClr val="FFFFFF"/></a:lt1><a:dk2><a:srgbClr val="243B53"/></a:dk2><a:lt2><a:srgbClr val="F4F7FA"/></a:lt2><a:accent1><a:srgbClr val="146C94"/></a:accent1><a:accent2><a:srgbClr val="20A39E"/></a:accent2><a:accent3><a:srgbClr val="F4A261"/></a:accent3><a:hlink><a:srgbClr val="146C94"/></a:hlink><a:folHlink><a:srgbClr val="7B5EA7"/></a:folHlink></a:clrScheme><a:fontScheme name="Office"><a:majorFont><a:latin typeface="Aptos Display"/></a:majorFont><a:minorFont><a:latin typeface="Aptos"/></a:minorFont></a:fontScheme><a:fmtScheme name="Office"><a:fillStyleLst/><a:lnStyleLst/><a:effectStyleLst/><a:bgFillStyleLst/></a:fmtScheme></a:themeElements></a:theme>
'@

Write-Part 'ppt/slideMasters/slideMaster1.xml' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:cSld name="Blank"><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr/></p:spTree></p:cSld><p:sldLayoutIdLst><p:sldLayoutId id="1" r:id="rId1"/></p:sldLayoutIdLst><p:txStyles><p:titleStyle/><p:bodyStyle/><p:otherStyle/></p:txStyles></p:sldMaster>
'@
Write-Part 'ppt/slideMasters/_rels/slideMaster1.xml.rels' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="../theme/theme1.xml"/></Relationships>
'@
Write-Part 'ppt/slideLayouts/slideLayout1.xml' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" type="blank" preserve="1"><p:cSld name="Blank"><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr/></p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sldLayout>
'@
Write-Part 'ppt/slideLayouts/_rels/slideLayout1.xml.rels' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster1.xml"/></Relationships>
'@

$sp = @()
function Add-Text([int]$id, [string]$name, [int]$x, [int]$y, [int]$cx, [int]$cy, [string]$text, [int]$size, [string]$color, [bool]$bold = $false) {
  $b = if ($bold) { ' b="1"' } else { '' }
  $escaped = [System.Security.SecurityElement]::Escape($text)
  $script:sp += @"
<p:sp><p:nvSpPr><p:cNvPr id="$id" name="$name"/><p:cNvSpPr txBox="1"/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x="$x" y="$y"/><a:ext cx="$cx" cy="$cy"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln><a:noFill/></a:ln></p:spPr><p:txBody><a:bodyPr wrap="square" lIns="0" rIns="0" tIns="0" bIns="0"/><a:lstStyle/><a:p><a:pPr/><a:r><a:rPr lang="en-US" sz="$size"$b><a:solidFill><a:srgbClr val="$color"/></a:solidFill><a:latin typeface="Aptos"/></a:rPr><a:t>$escaped</a:t></a:r><a:endParaRPr lang="en-US" sz="$size"/></a:p></p:txBody></p:sp>
"@
}
function Add-Line([int]$id, [int]$x, [int]$y, [int]$cx, [int]$cy, [string]$color) {
  $script:sp += "<p:sp><p:nvSpPr><p:cNvPr id=`"$id`" name=`"Divider`"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x=`"$x`" y=`"$y`"/><a:ext cx=`"$cx`" cy=`"$cy`"/></a:xfrm><a:prstGeom prst=`"rect`"><a:avLst/></a:prstGeom><a:solidFill><a:srgbClr val=`"$color`"/></a:solidFill><a:ln><a:noFill/></a:ln></p:spPr><p:txBody><a:bodyPr/><a:lstStyle/><a:p/></p:txBody></p:sp>"
}

Add-Text 2 'Title' 600000 430000 10800000 550000 'A grounded document assistant for faster, more reliable answers' 2600 '102A43' $true
Add-Text 3 'Subtitle' 600000 1030000 10800000 300000 'Turning maintenance and quality guidance into an accessible business resource' 1300 '52606D'
Add-Line 4 600000 1450000 10800000 30000 '20A39E'
Add-Text 5 'Problem label' 600000 1800000 3200000 300000 'THE PROBLEM' 1200 '146C94' $true
Add-Text 6 'Problem' 600000 2200000 3200000 1700000 'Teams lose time locating the right policy or procedure across long reference documents. Inconsistent answers create avoidable delays and rework.' 1500 '243B53'
Add-Line 7 3900000 1800000 30000 2700000 'CBD5E1'
Add-Text 8 'Solution label' 4300000 1800000 3200000 300000 'THE SOLUTION' 1200 '146C94' $true
Add-Text 9 'Solution' 4300000 2200000 3200000 1700000 'A chat experience that searches approved vehicle-safety and manufacturing-quality documents, then returns an answer with the supporting source.' 1500 '243B53'
Add-Line 10 7600000 1800000 30000 2700000 'CBD5E1'
Add-Text 11 'Impact label' 8000000 1800000 3200000 300000 'BUSINESS IMPACT' 1200 '146C94' $true
Add-Text 12 'Impact' 8000000 2200000 3200000 1700000 'Employees get a consistent starting point for questions. Leaders gain confidence that guidance reflects approved internal material and can scale across teams.' 1500 '243B53'
Add-Line 13 600000 5270000 10800000 20000 '20A39E'
Add-Text 14 'Footer' 600000 5450000 10800000 260000 'Scope: a decision-support assistant that directs people to the relevant source. It does not replace expert review for consequential decisions.' 1050 '52606D'

Write-Part 'ppt/slides/slide1.xml' ("<?xml version=`"1.0`" encoding=`"UTF-8`" standalone=`"yes`"?><p:sld xmlns:a=`"http://schemas.openxmlformats.org/drawingml/2006/main`" xmlns:r=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships`" xmlns:p=`"http://schemas.openxmlformats.org/presentationml/2006/main`"><p:cSld><p:bg><p:bgPr><a:solidFill><a:srgbClr val=`"FFFFFF`"/></a:solidFill></p:bgPr></p:bg><p:spTree><p:nvGrpSpPr><p:cNvPr id=`"1`" name=`"`"/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr/>" + ($sp -join '') + "</p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sld>")
Write-Part 'ppt/slides/_rels/slide1.xml.rels' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/></Relationships>
'@

$target = Join-Path $outDir 'rag-document-assistant-executive-summary.pptx'
if (Test-Path $target) { Remove-Item -LiteralPath $target -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($stageDir, $target)
Write-Output $target
