$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type st_3 from statictext within w_main
end type
type rb_2 from radiobutton within w_main
end type
type rb_1 from radiobutton within w_main
end type
type tab_1 from tab within w_main
end type
type tabpage_1 from userobject within tab_1
end type
type uo_wb_1 from vs_web_browser within tabpage_1
end type
type tabpage_1 from userobject within tab_1
uo_wb_1 uo_wb_1
end type
type tabpage_2 from userobject within tab_1
end type
type uo_wb_2 from vs_web_browser within tabpage_2
end type
type tabpage_2 from userobject within tab_1
uo_wb_2 uo_wb_2
end type
type tab_1 from tab within w_main
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type p_1 from picture within w_main
end type
type st_infocopyright from statictext within w_main
end type
type st_myversion from statictext within w_main
end type
type st_platform from statictext within w_main
end type
type cb_join from commandbutton within w_main
end type
type sle_archivo from singlelineedit within w_main
end type
type st_2 from statictext within w_main
end type
type cb_1 from commandbutton within w_main
end type
type cb_2 from commandbutton within w_main
end type
type st_1 from statictext within w_main
end type
type sle_join from singlelineedit within w_main
end type
type cb_split from commandbutton within w_main
end type
type st_msg from statictext within w_main
end type
type gb_1 from groupbox within w_main
end type
type r_2 from rectangle within w_main
end type
end forward

global type w_main from window
integer width = 4631
integer height = 3368
boolean titlebar = true
string title = "PowerBuilder PDF Utilities"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
string icon = "AppIcon!"
boolean center = true
st_3 st_3
rb_2 rb_2
rb_1 rb_1
tab_1 tab_1
p_1 p_1
st_infocopyright st_infocopyright
st_myversion st_myversion
st_platform st_platform
cb_join cb_join
sle_archivo sle_archivo
st_2 st_2
cb_1 cb_1
cb_2 cb_2
st_1 st_1
sle_join sle_join
cb_split cb_split
st_msg st_msg
gb_1 gb_1
r_2 r_2
end type
global w_main w_main

type prototypes
Function boolean QueryPerformanceFrequency ( &
	Ref Double lpFrequency &
	) Library "kernel32.dll"

Function boolean QueryPerformanceCounter ( &
	Ref Double lpPerformanceCount &
	) Library "kernel32.dll"

end prototypes

type variables
Double idbl_frequency = 0
String is_empresa, is_ip
n_cst_pdfservice in_pdf
vs_web_browser uo_wb_1, uo_wb_2
Constant Integer UseSplitMerge = 1
Constant Integer UseGhostScript = 2

end variables

forward prototypes
public function double wf_perfstart ()
public function double wf_perfstop (double adbl_start)
public subroutine wf_version (statictext ast_version, statictext ast_patform)
end prototypes

public function double wf_perfstart ();Double ldbl_start

If idbl_frequency = 0 Then
	QueryPerformanceFrequency(idbl_frequency)
End If

QueryPerformanceCounter(ldbl_start)

Return ldbl_start

end function

public function double wf_perfstop (double adbl_start);Double ldbl_stop, ldbl_elapsed

QueryPerformanceCounter(ldbl_stop)

If idbl_frequency > 0 Then
	ldbl_elapsed = (ldbl_stop - adbl_start) / idbl_frequency
End If

Return ldbl_elapsed

end function

public subroutine wf_version (statictext ast_version, statictext ast_patform);String ls_version, ls_platform
environment env
integer rtn

rtn = GetEnvironment(env)

IF rtn <> 1 THEN 
	ls_version = string(year(today()))
	ls_platform="32"
ELSE
	ls_version = "20"+ string(env.pbmajorrevision)+ "." + string(env.pbbuildnumber)
	ls_platform=string(env.ProcessBitness)
END IF

ls_platform += " Bits"

ast_version.text=ls_version
ast_patform.text=ls_platform

end subroutine

on w_main.create
this.st_3=create st_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.tab_1=create tab_1
this.p_1=create p_1
this.st_infocopyright=create st_infocopyright
this.st_myversion=create st_myversion
this.st_platform=create st_platform
this.cb_join=create cb_join
this.sle_archivo=create sle_archivo
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_1=create st_1
this.sle_join=create sle_join
this.cb_split=create cb_split
this.st_msg=create st_msg
this.gb_1=create gb_1
this.r_2=create r_2
this.Control[]={this.st_3,&
this.rb_2,&
this.rb_1,&
this.tab_1,&
this.p_1,&
this.st_infocopyright,&
this.st_myversion,&
this.st_platform,&
this.cb_join,&
this.sle_archivo,&
this.st_2,&
this.cb_1,&
this.cb_2,&
this.st_1,&
this.sle_join,&
this.cb_split,&
this.st_msg,&
this.gb_1,&
this.r_2}
end on

on w_main.destroy
destroy(this.st_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.tab_1)
destroy(this.p_1)
destroy(this.st_infocopyright)
destroy(this.st_myversion)
destroy(this.st_platform)
destroy(this.cb_join)
destroy(this.sle_archivo)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.sle_join)
destroy(this.cb_split)
destroy(this.st_msg)
destroy(this.gb_1)
destroy(this.r_2)
end on

event open;in_pdf = CREATE n_cst_pdfservice
in_pdf.of_splitmergemetodh(UseSplitMerge)

wf_version(st_myversion, st_platform)

uo_wb_1 = tab_1.tabpage_1.uo_wb_1
uo_wb_2 = tab_1.tabpage_2.uo_wb_2
end event

event close;Destroy in_pdf
end event

type st_3 from statictext within w_main
integer x = 2121
integer y = 56
integer width = 1829
integer height = 156
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 33521664
string text = "PowerBuilder PDF Utilities"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_main
integer x = 3360
integer y = 448
integer width = 1152
integer height = 80
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Usar GhostScript 32"
end type

event clicked;in_pdf.of_splitmergemetodh( UseGhostScript)
end event

type rb_1 from radiobutton within w_main
integer x = 3360
integer y = 364
integer width = 1152
integer height = 80
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Usar Libreria NetCore  SplitMergePdf.DLL"
boolean checked = true
end type

event clicked;in_pdf.of_splitmergemetodh(UseSplitMerge)
end event

type tab_1 from tab within w_main
event create ( )
event destroy ( )
integer x = 133
integer y = 600
integer width = 4462
integer height = 2580
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4425
integer height = 2452
string text = "Pdf 1"
long tabtextcolor = 33554432
long tabbackcolor = 1073741824
string picturename = "Find1!"
long picturemaskcolor = 536870912
uo_wb_1 uo_wb_1
end type

on tabpage_1.create
this.uo_wb_1=create uo_wb_1
this.Control[]={this.uo_wb_1}
end on

on tabpage_1.destroy
destroy(this.uo_wb_1)
end on

type uo_wb_1 from vs_web_browser within tabpage_1
integer x = 50
integer y = 32
integer width = 4361
integer height = 2400
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
boolean visible = false
integer x = 18
integer y = 112
integer width = 4425
integer height = 2452
string text = "Pdf 2"
long tabtextcolor = 33554432
long tabbackcolor = 1073741824
string picturename = "FindNext1!"
long picturemaskcolor = 536870912
uo_wb_2 uo_wb_2
end type

on tabpage_2.create
this.uo_wb_2=create uo_wb_2
this.Control[]={this.uo_wb_2}
end on

on tabpage_2.destroy
destroy(this.uo_wb_2)
end on

type uo_wb_2 from vs_web_browser within tabpage_2
integer x = 50
integer y = 32
integer width = 4361
integer height = 2400
end type

type p_1 from picture within w_main
integer x = 5
integer y = 4
integer width = 1253
integer height = 248
boolean originalsize = true
string picturename = "logo.jpg"
boolean focusrectangle = false
end type

type st_infocopyright from statictext within w_main
integer x = 3072
integer y = 3216
integer width = 1289
integer height = 56
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 553648127
string text = "Copyright © Ramón San Félix Ramón  rsrsystem.soft@gmail.com"
boolean focusrectangle = false
end type

type st_myversion from statictext within w_main
integer x = 4059
integer y = 60
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Versión"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_platform from statictext within w_main
integer x = 4059
integer y = 148
integer width = 489
integer height = 84
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Bits"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_join from commandbutton within w_main
integer x = 2117
integer y = 456
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Join"
end type

event clicked;if trim(sle_join.text)="" then return

String ls_OutputFile, ls_filename
String ls_file1, ls_file2
boolean lb_result
Double ldbl_start, ldbl_elapsed

ls_file1=sle_archivo.text
ls_file2=sle_join.text

if ls_file1="" then
	messagebox("Atención", "¡ Debe Indicar un archivo donde al que unir el PDF !", Exclamation!)
	sle_Archivo.setfocus()
end if

if ls_file2="" then
	messagebox("Atención", "¡ Debe Indicar un archivo para unir el PDF !", Exclamation!)
	sle_join.setfocus()
end if

ldbl_start = wf_PerfStart()

lb_result = in_pdf.of_unir(ls_file1, ls_file2)

ldbl_elapsed = wf_PerfStop(ldbl_start)

if lb_result=true then
	st_msg.text ="Join Elapsed time: " + String(ldbl_elapsed, "#,##0.0000") + " seconds."
	if  uo_wb_1.Navigate(sle_archivo.text) <> 1 then
		Messagebox("Error","Al cargar el archivo PDF Unido", Stopsign!)
	else
		sle_join.text=""
		tab_1.tabpage_2.visible=false
		tab_1.SelectTab(1)
		cb_join.enabled=false
		cb_split.enabled=true
	end if
	
end if	

end event

type sle_archivo from singlelineedit within w_main
integer x = 251
integer y = 332
integer width = 1673
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_main
integer x = 73
integer y = 344
integer width = 169
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Pdf 1:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_main
integer x = 1934
integer y = 332
integer width = 174
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;integer li_rtn
string ls_path, ls_ruta
string  ls_current

ls_ruta="C:\Users\Ramon\Pictures\ControlCenter4\pdf\"
ls_current=GetCurrentDirectory ( )
li_rtn = GetFileOpenName("Archivo a cargar", sle_archivo.text, ls_path, "pdf", "Acrobat Reader (*.pdf), *.Pdf", ls_ruta)
ChangeDirectory ( ls_current )



if li_rtn < 1 then return
//contador=integer(left(right(trim(sle_archivo.text), 9), 5))	


if uo_wb_1.Navigate(sle_archivo.text) <> 1 then
	Messagebox("Error","Al cargar el archivo PDF", Stopsign!)
else
	cb_split.enabled=true
	sle_join.enabled=true
	cb_2.enabled=true
end if

end event

type cb_2 from commandbutton within w_main
integer x = 1934
integer y = 460
integer width = 174
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "..."
end type

event clicked;integer li_rtn
string ls_path, ls_ruta
string  ls_current

ls_ruta="C:\Users\Ramon\Pictures\ControlCenter4\pdf\"
ls_current=GetCurrentDirectory ( )
li_rtn = GetFileOpenName("Archivo a cargar", sle_join.text, ls_path, "pdf", "Acrobat Reader (*.pdf), *.Pdf", ls_ruta)
ChangeDirectory ( ls_current )



if li_rtn < 1 then return
//contador=integer(left(right(trim(sle_archivo.text), 9), 5))	

if uo_wb_2.Navigate(sle_join.text)<>1 then
	Messagebox("Error","Al cargar el archivo PDF", Stopsign!)
else
	tab_1.tabpage_2.visible=true
	tab_1.SelectTab(2)
	cb_join.enabled=true
	cb_split.enabled=false
end if
end event

type st_1 from statictext within w_main
integer x = 73
integer y = 472
integer width = 169
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Pdf 2:"
boolean focusrectangle = false
end type

type sle_join from singlelineedit within w_main
integer x = 251
integer y = 460
integer width = 1673
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_split from commandbutton within w_main
integer x = 2117
integer y = 324
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Split"
end type

event clicked;Integer li_Result
Double ldbl_start, ldbl_elapsed
String ls_filename

if trim(sle_archivo.text)="" then return

ls_filename=sle_Archivo.text

ldbl_start = wf_PerfStart()
	
li_result = in_pdf.of_dividir( ls_filename)
	
ldbl_elapsed = wf_PerfStop(ldbl_start)

IF li_result > 0 THEN
		st_msg.text = "Split elapsed time: " + String(ldbl_elapsed, "#,##0.0000") + " seconds Pages: "+string( li_Result)
END IF


end event

type st_msg from statictext within w_main
integer y = 3204
integer width = 3003
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_main
integer x = 3246
integer y = 300
integer width = 1321
integer height = 264
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Opciones"
end type

type r_2 from rectangle within w_main
long linecolor = 33554432
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 33521664
integer width = 4599
integer height = 260
end type

