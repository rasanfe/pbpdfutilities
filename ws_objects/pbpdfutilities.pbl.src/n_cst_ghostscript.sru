$PBExportHeader$n_cst_ghostscript.sru
forward
global type n_cst_ghostscript from nonvisualobject
end type
type process_information from structure within n_cst_ghostscript
end type
type startupinfo from structure within n_cst_ghostscript
end type
end forward

type process_information from structure
	long		hprocess
	long		hthread
	unsignedlong		dwprocessid
	unsignedlong		dwthreadid
end type

type startupinfo from structure
	unsignedlong		cb
	string		lpreserved
	string		lpdesktop
	string		lptitle
	unsignedlong		dwx
	unsignedlong		dwy
	unsignedlong		dwxsize
	unsignedlong		dwysize
	unsignedlong		dwxcountchars
	unsignedlong		dwycountchars
	unsignedlong		dwfillattribute
	unsignedlong		dwflags
	unsignedinteger		wshowwindow
	unsignedinteger		cbreserved2
	longptr		lpreserved2
	longptr		hstdinput
	longptr		hstdoutput
	longptr		hstderror
end type

global type n_cst_ghostscript from nonvisualobject
end type
global n_cst_ghostscript n_cst_ghostscript

type prototypes
Function ULong GetTempPath ( &
	ULong nBufferLength, &
	Ref String lpBuffer &
	) Library "kernel32.dll" Alias For "GetTempPathW"

Function ULong GetTempFileName ( &
	String lpPathName, &
	String lpPrefixString, &
	ULong uUnique, &
	Ref String lpTempFileName &
	) Library "kernel32.dll"  Alias For "GetTempFileNameW"

Function Boolean CreateProcess ( &
	String lpApplicationName, &
	Ref String lpCommandLine, &
	longptr lpProcessAttributes, &
	longptr lpThreadAttributes, &
	Boolean bInheritHandles, &
	ULong dwCreationFlags, &
	longptr lpEnvironment, &
	String lpCurrentDirectory, &
	STARTUPINFO lpStartupInfo, &
	Ref PROCESS_INFORMATION lpProcessInformation &
	) Library "kernel32.dll" Alias For "CreateProcessW"

Function ULong WaitForSingleObject ( &
	Long hHandle, &
	ULong dwMilliseconds &
	) Library "kernel32.dll"

Function Boolean CloseHandle ( &
	Long hObject &
	) Library "kernel32.dll"

end prototypes

type variables
Private:

Constant UInt SW_HIDE = 0
Constant ULong STARTF_USESHOWWINDOW  = 1
Constant ULong CREATE_NEW_CONSOLE    = 16
Constant ULong NORMAL_PRIORITY_CLASS = 32
Constant ULong INFINITE = 4294967295	// 0xFFFFFFFF
Constant ULong MAX_PATH = 260

Constant String SybasePDF = "Sybase DataWindow PS"

Public:
Constant String GhostExe = "C:\Program Files (x86)\gs\gs9.55.0\bin\gswin32c.exe"
//Constant String GhostExe = "C:\Program Files\gs\gs9.55.0\bin\gswin64c.exe"

end variables

forward prototypes
private function long of_runandwait (string as_cmdline)
private function string of_getpsfilename ()
public function boolean of_saveaspdf (string as_pdfname, ref datastore ads_reports[])
public function boolean of_saveaspdf (string as_pdfname, ref datawindow adw_reports[])
private function boolean of_postscriptprint (ref datastore ads_report, string as_filename)
private function boolean of_postscriptprint (ref datawindow adw_report, string as_filename)
public function boolean of_ghostscript (string as_pdfname, string as_psnames[], string as_printername)
private function boolean of_ghostscript (string as_pdfname, string as_psnames[])
public function boolean of_split (string as_pdfname, integer ai_firstpage, integer ai_lastpage, string as_pdfoutput)
public function boolean of_split (string as_pdfname)
end prototypes

private function long of_runandwait (string as_cmdline);// run a program and wait for it to finish

Environment le_env
STARTUPINFO lstr_si
PROCESS_INFORMATION lstr_pi
LongPtr ll_null
Long ll_ExitCode
ULong lul_CreationFlags
String ls_null

GetEnvironment(le_env)

// initialize arguments
SetNull(ls_null)
If le_env.ProcessBitness = 64 Then
	lstr_si.cb = 104
Else
	lstr_si.cb = 68
End If
lstr_si.dwFlags = STARTF_USESHOWWINDOW
lstr_si.wShowWindow = SW_HIDE
lul_CreationFlags = CREATE_NEW_CONSOLE + NORMAL_PRIORITY_CLASS

// create process/thread and execute the passed program
If CreateProcess(ls_null, as_cmdline, ll_null, &
			ll_null, False, lul_CreationFlags, ll_null, &
			ls_null, lstr_si, lstr_pi) Then
	// wait until process ends or timeout period expires
	ll_ExitCode = WaitForSingleObject(lstr_pi.hProcess, INFINITE)
	// close process and thread handles
	CloseHandle(lstr_pi.hProcess)
	CloseHandle(lstr_pi.hThread)
Else
	// return failure
	ll_ExitCode = -1
End If

Return ll_ExitCode

end function

private function string of_getpsfilename ();// returns an unique temp file name for the PostScript file

String ls_TempPath, ls_TempFile
ulong lul_Return

ls_TempPath = Space(MAX_PATH + 1)

lul_Return = GetTempPath(MAX_PATH, ls_TempPath)
If (lul_Return > MAX_PATH) Or (lul_Return = 0) Then
	PopulateError(999, "Failed to determine the temp path")
	SetNull(ls_TempFile)
	Return ls_TempFile
End If

ls_TempFile = Space(MAX_PATH + 1)

lul_Return = GetTempFileName(ls_TempPath, "ps", 0, ls_TempFile)
If lul_Return = 0 Then
	PopulateError(999, "Failed to generate a temp file name")
	SetNull(ls_TempFile)
	Return ls_TempFile
End If

Return ls_TempFile

end function

public function boolean of_saveaspdf (string as_pdfname, ref datastore ads_reports[]);// save one or more DataStore objects to a single PDF

Long ll_idx, ll_max
String ls_PSfiles[]

SetPointer(HourGlass!)

ll_max = UpperBound(ads_reports)
For ll_idx = 1 To ll_max
	ls_PSfiles[ll_idx] = of_GetPSFilename()
	If Not of_PostScriptPrint(ads_reports[ll_idx], ls_PSfiles[ll_idx]) Then
		Return False
	End If
Next

Return of_GhostScript(as_pdfname, ls_PSfiles)

end function

public function boolean of_saveaspdf (string as_pdfname, ref datawindow adw_reports[]);// save one or more DataWindow objects to a single PDF

Long ll_idx, ll_max
String ls_PSfiles[]

SetPointer(HourGlass!)

ll_max = UpperBound(adw_reports)
For ll_idx = 1 To ll_max
	ls_PSfiles[ll_idx] = of_GetPSFilename()
	If Not of_PostScriptPrint(adw_reports[ll_idx], ls_PSfiles[ll_idx]) Then
		Return False
	End If
Next

Return of_GhostScript(as_pdfname, ls_PSfiles)

end function

private function boolean of_postscriptprint (ref datastore ads_report, string as_filename);// print the DataStore to a PostScript file

Long ll_RtnCode

ads_report.Object.DataWindow.Print.PrinterName = SybasePDF
ads_report.Object.DataWindow.Print.FileName    = as_filename

ll_RtnCode = ads_report.Print(False, False)
If ll_RtnCode < 0 Then
	PopulateError(999, "DataStore failed to print")
	Return False
End If

Return True

end function

private function boolean of_postscriptprint (ref datawindow adw_report, string as_filename);// print the DataWindow to a PostScript file

Long ll_RtnCode

adw_report.Object.DataWindow.Print.PrinterName = SybasePDF
adw_report.Object.DataWindow.Print.FileName    = as_filename

ll_RtnCode = adw_report.Print(False, False)
If ll_RtnCode < 0 Then
	PopulateError(999, "DataWindow failed to print")
	Return False
End If

Return True

end function

public function boolean of_ghostscript (string as_pdfname, string as_psnames[], string as_printername);// runs Ghostscript against the PostScript files

Long ll_RtnCode, ll_idx, ll_max
String ls_psnames, ls_cmdline

// build the command line
ll_max = UpperBound(as_psnames)
For ll_idx = 1 To ll_max
	ls_psnames += ' "' + as_psnames[ll_idx] + '"'
Next


//Ennciar String vacio como nombre de impresora para imprimir en un nuevo pdf con nombre: as_pdfname
if as_printerName = "" or trim(as_printerName) = "PDF"THEN
	ls_cmdline =	GhostExe + ' -q -empty -dPrinted -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite' + &
					' -sOutputFile="' + as_pdfname + '" -f' + ls_psnames

ELSE
	ls_cmdline =	GhostExe + ' -q -empty -dPrinted -dNOPAUSE -dBATCH -dSAFER -sDEVICE=mswinpr2' + &
			' -sOutputFile="%printer%'+as_printername + '" -f' + ls_psnames
END IF	

					
					
// run Ghostscript and wait for it to finish
ll_RtnCode = of_RunAndWait(ls_CmdLine)

// delete the PostScript files
//For ll_idx = 1 To ll_max
	//FileDelete(as_psnames[ll_idx])
//Next

If ll_RtnCode < 0 Then
	PopulateError(999, "Failed to run " + GhostExe)
	Return False
End If

Return True

end function

private function boolean of_ghostscript (string as_pdfname, string as_psnames[]);// runs Ghostscript against the PostScript files

Long ll_RtnCode, ll_idx, ll_max
String ls_psnames, ls_cmdline

// build the command line
ll_max = UpperBound(as_psnames)
For ll_idx = 1 To ll_max
	ls_psnames += ' "' + as_psnames[ll_idx] + '"'
Next
ls_cmdline =	GhostExe + ' -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite ' + &
					'-sOutputFile="' + as_pdfname + '" -c .setpdfwrite -f' + ls_psnames

			
					
// run Ghostscript and wait for it to finish
ll_RtnCode = of_RunAndWait(ls_CmdLine)

// delete the PostScript files
For ll_idx = 1 To ll_max
	//FileDelete(as_psnames[ll_idx])
Next

If ll_RtnCode < 0 Then
	PopulateError(999, "Failed to run " + GhostExe)
	Return False
End If

Return True

end function

public function boolean of_split (string as_pdfname, integer ai_firstpage, integer ai_lastpage, string as_pdfoutput);Long ll_RtnCode
String  ls_cmdline

ls_cmdline =	GhostExe + ' -q -dNOPAUSE -dBATCH -dSAFER -dFirstPage='+string(ai_firstpage)+' -dLastPage='+string(ai_lastpage)+' -sDEVICE=pdfwrite ' + &
					'-sOutputFile="' + as_pdfoutput + '"  -f "' + as_pdfname+'"'

					
// run Ghostscript and wait for it to finish
ll_RtnCode = of_RunAndWait(ls_CmdLine)

// delete the PostScript file
//FileDelete(as_pdfname)


If ll_RtnCode < 0 Then
	PopulateError(999, "Failed to run " + GhostExe)
	Return False
End If

Return True

end function

public function boolean of_split (string as_pdfname);Long ll_RtnCode
String  ls_cmdline
String ls_pdfoutput

ls_pdfoutput=mid(as_pdfname, 1, pos(as_pdfname, ".pdf") - 1)
ls_pdfoutput += "%d.pdf"

ls_cmdline =	GhostExe + ' -q -dNOPAUSE -dBATCH -dSAFER  -sDEVICE=pdfwrite ' + &
					'-sOutputFile="' + ls_pdfoutput + '"  -f "' + as_pdfname+'"'
					
// run Ghostscript and wait for it to finish
ll_RtnCode = of_RunAndWait(ls_CmdLine)

// delete the PostScript file
//FileDelete(as_pdfname)

If ll_RtnCode < 0 Then
	PopulateError(999, "Failed to run " + GhostExe)
	Return False
End If

Return True

end function

on n_cst_ghostscript.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_ghostscript.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

