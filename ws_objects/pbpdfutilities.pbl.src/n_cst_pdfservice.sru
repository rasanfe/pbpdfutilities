$PBExportHeader$n_cst_pdfservice.sru
forward
global type n_cst_pdfservice from nonvisualobject
end type
end forward

global type n_cst_pdfservice from nonvisualobject
end type
global n_cst_pdfservice n_cst_pdfservice

type variables
Private:
nvo_splitmerge in_pdf1
n_cst_ghostscript in_pdf2
nvo_fileservice in_file

Constant Integer UseSplitMerge = 1
Constant Integer UseGhostScript = 2
Integer is_SplitMergeMetodh = UseSplitMerge
end variables

forward prototypes
public function boolean of_unir (string as_ruta1, string as_ruta2)
public function integer of_dividir (string as_ruta)
public subroutine of_splitmergemetodh (integer ai_splitmergemetodh)
private function boolean of_control_dependencias ()
private function boolean of_control_pdf (string as_ruta)
end prototypes

public function boolean of_unir (string as_ruta1, string as_ruta2);string ls_file1, ls_file2, ls_dir, ls_join
Boolean lb_Result=True
String ls_files[2]

IF not of_control_dependencias() THEN RETURN FALSE

IF not (of_control_pdf(as_ruta1) AND of_control_pdf(as_ruta1)) THEN RETURN FALSE

ls_file1=in_File.of_GetFileName(as_ruta1)
ls_file2=in_File.of_GetFileName(as_ruta2)

ls_dir=in_File.of_GetDirectoryName(as_ruta1)+"\"
ls_join =ls_dir+in_File.of_GetFileNameWithoutExtension(ls_file1)+"_join.pdf"  

ls_files[1]=as_ruta1
ls_files[2]=as_ruta2

IF  is_SplitMergeMetodh  = UseSplitMerge then
	lb_Result  = in_pdf1.of_mergefiles(ls_files[], ls_join)
ELSE
	lb_Result =  in_pdf2.of_ghostscript( ls_join, ls_files[], "PDF") 
END IF
			
if lb_Result then
	
	lb_Result =  FileDelete(as_ruta2)
	
	if lb_result=false then
		messagebox ("Atención", "¡ Error Elimiando Archivo  "+as_ruta2+" Después de unirlo !", Exclamation!)
	else
		lb_Result = in_File.of_filerename(ls_join, as_ruta1) 
	end if	
else
	messagebox ("Atención", "¡ Error Uniendo Archivos !", Exclamation!)
	FileDelete(ls_join)
	lb_Result = false
end if	
	
RETURN lb_Result
end function

public function integer of_dividir (string as_ruta);Integer li_result
String ls_directorio

IF not of_control_dependencias() THEN RETURN 0
IF not of_control_pdf(as_ruta) THEN RETURN 0

ls_directorio = in_File.of_GetDirectoryName(as_ruta)

IF  is_SplitMergeMetodh  = UseSplitMerge THEN
	
	li_result = in_pdf1.of_splitFiles( as_ruta, ls_directorio)
	 
	 //Checks the result
	IF in_pdf1.il_ErrorType < 0 THEN
	  messagebox ("Atención", in_file.is_ErrorText, Exclamation!)
	END IF
ELSE
		If not in_pdf2.of_split( as_ruta) Then
			messagebox ("Atención", Error.Text, Exclamation!)
		end if	
		//Con GhostScript no se el nº de páginas generadas.
		li_result = 1
END IF	
 
RETURN li_result
end function

public subroutine of_splitmergemetodh (integer ai_splitmergemetodh);is_SplitMergeMetodh=ai_SplitMergeMetodh
end subroutine

private function boolean of_control_dependencias ();IF  is_SplitMergeMetodh  = UseSplitMerge then
	IF NOT FileExists(gs_dir+"SplitMergePdf.dll") THEN
		messagebox ("Atención", "¡ Necesita el Archivo SplitMergePdf.dll !", Exclamation!)
		Return FALSE
	END IF
	
	IF NOT FileExists(gs_dir+"itextsharp.dll") THEN
		messagebox ("Atención", "¡ Necesita el Archivo itextsharp.dll !", Exclamation!)
		Return FALSE
	END IF
ELSE
	IF NOT FileExists(In_pdf2.GhostExe) THEN
		messagebox ("Atención", "¡ Necesita el Archivo gswin32c.exe !", Exclamation!)
		Return FALSE
	END IF	
END IF	

RETURN TRUE
end function

private function boolean of_control_pdf (string as_ruta);String ls_file, ls_extension

ls_file=in_File.of_GetFileName(as_ruta)
ls_extension = in_File.of_GetExtension(as_ruta)
 
if Not FileExists(as_ruta) then
	messagebox ("Atención", "¡ El Archivo  "+ls_file+" No existe !", Exclamation!)
	Return false
end if	

if ls_file = "" then
	messagebox ("Atención", "¡ Tiene que pasar la ruta completa del PDF !", Exclamation!)
	Return false
end if	
			
if  ls_extension <> ".pdf" then
	messagebox ("Atención", "¡ Los archivos han de ser PDF !", Exclamation!)
	Return false
end if	

RETURN TRUE
end function

on n_cst_pdfservice.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pdfservice.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;in_pdf1 =  CREATE nvo_splitmerge
in_pdf2 =  CREATE n_cst_ghostscript
in_file = CREATE nvo_FileService
end event

event destructor;destroy in_pdf1
destroy in_pdf2
destroy in_file
end event

