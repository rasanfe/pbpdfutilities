$PBExportHeader$n_cst_pdfdocument.sru
forward
global type n_cst_pdfdocument from nonvisualobject
end type
end forward

global type n_cst_pdfdocument from nonvisualobject
end type
global n_cst_pdfdocument n_cst_pdfdocument

type variables
String is_ErrorText

end variables

forward prototypes
private subroutine of_setlasterror (long al_error)
public function boolean of_merge (string as_filenames[], string as_targetpdf)
public function long of_split (string as_inputfile, string as_outputpath)
end prototypes

private subroutine of_setlasterror (long al_error);Choose Case al_error
	Case 1	
		is_ErrorText = ""
	Case -1
		is_ErrorText = "General error"
	Case -3
		is_ErrorText = "Invalid PDFDocument object"
	Case -4
		is_ErrorText = "Invalid PDFPage object"
	Case -13
		is_ErrorText = "The index is out of range2"
	Case -15
		is_ErrorText = "Invalid PDFImportContent object"
	Case -16
		is_ErrorText = "The start index is out of range"
	Case -17
		is_ErrorText = "Invalid index range"
	Case -19
		is_ErrorText = "Invalid file name"
	Case -22
		is_ErrorText = "Invalid password. The master password and the user password cannot be empty, and they cannot be the same."
	Case -23
		is_ErrorText = "Invalid PDFDocumentProperties object"
	Case -24
		is_ErrorText = "Invalid handle of PDFlib"
	Case -25
		is_ErrorText = "An exception occurred while executing the PDFlib operation"
	Case -26
		is_ErrorText ="Failed to open the PDF document"
	Case -27
		is_ErrorText = "Failed to create the PDF document"
	Case -32 
		is_ErrorText = "The PDF object does not exist"
	Case -33
		is_ErrorText = "The object already has its owner"
	Case -34 
		is_ErrorText = "The ReadOnly object is not allowed to be modified"
end choose	

	
end subroutine

public function boolean of_merge (string as_filenames[], string as_targetpdf);Long ll_Files, ll_File
String ls_file
Boolean lb_result=FALSE
Long ll_rtn
PDFDocument ln_PDFDoc

ln_PDFDoc =  CREATE PDFDocument

ll_Files = UpperBound(as_filenames[])

FOR ll_File =  1 TO ll_Files
	ls_file=as_filenames[ll_File]
	
	ll_rtn = ln_PDFDoc.importpdf(ls_file)
	
	IF ll_rtn <> 1 THEN EXIT
NEXT	

IF ll_rtn = 1 THEN
	ll_rtn =ln_PDFDoc.Save(as_targetpdf)
END IF	

IF ll_rtn = 1 THEN  lb_result = TRUE

of_SetLastError(ll_rtn)

Destroy ln_PDFDoc
Return lb_result

end function

public function long of_split (string as_inputfile, string as_outputpath);String ls_filename, ls_outputfile
Long ll_rtn
long ll_pag
nvo_fileservice ln_file
PDFDocument ln_PDFDoc

ln_file = CREATE nvo_FileService

ls_filename = ln_file.of_getfilenamewithoutextension(as_inputfile)

ll_pag = 0

DO WHILE TRUE
	ll_pag ++
	ln_PDFDoc =  CREATE PDFDocument
	ll_rtn = ln_PDFDoc.importpdf( as_inputFile, ll_pag, ll_pag, 1)
	IF ll_rtn = 1 THEN
		ls_outputFile=as_outputpath+ "\"+ls_filename+string(ll_pag)+".pdf"
		ll_rtn = ln_PDFDoc.Save(ls_outputFile)
		Destroy ln_PDFDoc
	ELSE
		IF ll_rtn = -16 THEN ll_rtn = 1 //The start index is out of range Saldremos con exito con este error del LOOP
		ll_pag --
		exit
	END IF
LOOP	

of_SetLastError(ll_rtn)

Return ll_pag

end function

on n_cst_pdfdocument.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pdfdocument.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

