$PBExportHeader$pbpdfutilities.sra
$PBExportComments$Generated Application Object
forward
global type pbpdfutilities from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String gs_dir
end variables

global type pbpdfutilities from application
string appname = "pbpdfutilities"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 21.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "icono.ico"
string appruntimeversion = "22.0.0.1878"
boolean manualsession = false
boolean unsupportedapierror = false
end type
global pbpdfutilities pbpdfutilities

type prototypes
//Funcion para tomar el directorio de la aplicacion
FUNCTION	uLong	GetModuleFileName ( uLong lhModule, ref string sFileName, ulong nSize )  LIBRARY "Kernel32.dll" ALIAS FOR "GetModuleFileNameW"
end prototypes
on pbpdfutilities.create
appname="pbpdfutilities"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pbpdfutilities.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
String ls_Path
unsignedlong lul_handle
environment env
String  ls_platform
integer rtn

rtn = GetEnvironment(env)
ls_platform=string(env.ProcessBitness)

ls_Path = space(1024)
setnull(lul_handle)
GetModuleFilename(lul_handle, ls_Path, 1024)

if right(UPPER(ls_path), 7)="220.EXE" or right(UPPER(ls_path), 7)="X64.EXE" then
	ls_path="C:\projecto pw2022\Blog\Publicado\pbPDFUtilities\pbpdfutilities.exe"
end if

gs_dir=left(ls_path, len(ls_path) - 18)



Open(w_main)

end event

