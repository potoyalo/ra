
Opt("MustDeclareVars", 1)

If $CmdLine[0] = 0 Then Exit

ShellExecute($CmdLine[1], PrepareParameters(), '', 'runas')

#Region ProcessingParameters

Func PrepareParameters()

	Local $RawParameters = $CmdLineRaw
	Local $Parameters = ''
	Local $Param = ''
	Local $Quotes = ''

	ExtractParameter($RawParameters, 1)
	For $i = 2 To $CmdLine[0]
		$Param = ExtractParameter($RawParameters, $i)

		$Quotes = ''
		If StringLeft($Param, 1) == '"' Then $Quotes = '"'

		#Region SpecialChecks

		If IsRelativePath($CmdLine[$i]) Then $Param = $Quotes & ReplaceRelativePath($CmdLine[$i]) & $Quotes

		#EndRegion SpecialChecks

		$Parameters &= $Param & ' '
	Next

	Return $Parameters

EndFunc   ;==>PrepareParameters

Func ExtractParameter(ByRef $RawParameters, $NumberParam)

	Local $Count = StringLen($CmdLine[$NumberParam])
	If StringLeft($RawParameters, 1) == '"' Then $Count += 2

	Local $Param = StringLeft($RawParameters, $Count)
	$RawParameters = StringTrimLeft($RawParameters, $Count + 1)

	Return $Param

EndFunc   ;==>ExtractParameter

Func IsRelativePath($Path)

	Select
		Case StringLeft($Path, 2) == '.\'
			Return True
		Case StringLeft($Path, 3) == '..\'
			Return True
		Case Else
			Return False
	EndSelect

EndFunc   ;==>IsRelativePath

Func ReplaceRelativePath($Path)

	If StringLeft($Path, 3) = '..\' Then $Path = '.\' & $Path

	Return @WorkingDir & StringTrimLeft($Path, 1)

EndFunc   ;==>ReplaceRelativePath

#EndRegion ProcessingParameters
