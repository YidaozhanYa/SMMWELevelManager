VERSION 5.00
Object = "{A2A736C2-8DAC-4CDB-B1CB-3B077FBB14F9}#6.2#0"; "VB6Resizer2.ocx"
Begin VB.Form frmImport 
   BackColor       =   &H80000005&
   Caption         =   "Form1"
   ClientHeight    =   4245
   ClientLeft      =   60
   ClientTop       =   405
   ClientWidth     =   7800
   BeginProperty Font 
      Name            =   "΢���ź�"
      Size            =   9
      Charset         =   134
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmImport.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4245
   ScaleWidth      =   7800
   StartUpPosition =   3  '����ȱʡ
   Begin VB.CommandButton cmdDesktop 
      Caption         =   "����"
      Height          =   375
      Left            =   1800
      TabIndex        =   5
      Top             =   3720
      Width           =   855
   End
   Begin VB.ListBox List1 
      BeginProperty Font 
         Name            =   "΢���ź�"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   4020
      Left            =   2760
      OLEDropMode     =   1  'Manual
      Style           =   1  'Checkbox
      TabIndex        =   4
      Tag             =   "HW"
      Top             =   120
      Width           =   4935
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "ȡ��"
      Height          =   375
      Left            =   960
      TabIndex        =   3
      Top             =   3720
      Width           =   735
   End
   Begin VB.CommandButton cmdImport 
      Caption         =   "����"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   3720
      Width           =   735
   End
   Begin VB6ResizerLib2.VB6Resizer VB6Resizer1 
      Left            =   5160
      Top             =   2400
      _ExtentX        =   529
      _ExtentY        =   529
   End
   Begin VB.DirListBox Dirs 
      Height          =   2940
      Left            =   120
      TabIndex        =   1
      Tag             =   "H"
      Top             =   600
      Width           =   2535
   End
   Begin VB.DriveListBox Drvs 
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   2535
   End
End
Attribute VB_Name = "frmImport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdCancel_Click()
    Me.Hide
End Sub

Private Sub cmdDesktop_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Select Case Button
    Case 1
        Select Case cmdDesktop.Caption
        Case ConstStr("desktop")
            Dirs.Path = Environ("UserProfile") & "\Desktop"
        Case ConstStr("appdir")
            Dirs.Path = App.Path
        Case ConstStr("qq")
            Dirs.Path = Environ("UserProfile") & "\Documents\Tencent Files"
        End Select
    Case 2
        Select Case cmdDesktop.Caption
        Case ConstStr("desktop")
            cmdDesktop.Caption = ConstStr("appdir")
        Case ConstStr("appdir")
            cmdDesktop.Caption = ConstStr("qq")
        Case ConstStr("qq")
            cmdDesktop.Caption = ConstStr("desktop")
        End Select
    End Select
End Sub

Private Sub cmdImport_Click()
    Dim ItemNum As Long, RetText As String, fso As New FileSystemObject
    For ItemNum = 0 To List1.ListCount - 1
        If List1.Selected(ItemNum) Then
            RetText = RetText & List1.List(ItemNum) & " "
            fso.CopyFile Dirs.Path & "\" & List1.List(ItemNum), LevelPath & "\" & List1.List(ItemNum), True
        End If
    Next
    MsgBox RetText & ConstStr("import_completed")
End Sub

Private Sub Dirs_Change()
    On Error Resume Next
    List1.Clear
    Dim LevelFile As Variant
    For Each LevelFile In GetFileList(Dirs.Path, "*.swe")
        List1.AddItem LevelFile
    Next LevelFile
End Sub

Private Sub Drvs_Change()
    Dirs.Path = UCase(Split(Drvs.Drive, ":")(0)) & ":\"
End Sub


Private Sub Form_Load()
    Me.Caption = ConstStr("title") & " " & App.Major & "." & App.Minor & "." & App.Revision & " - ����ؿ�"    '���ڱ���
    cmdImport.Caption = ConstStr("import")
    cmdCancel.Caption = ConstStr("cancel")
    cmdDesktop.Caption = ConstStr("desktop")
    cmdDesktop.ToolTipText = ConstStr("right_change")
    List1.ToolTipText = ConstStr("drag_tooltip")
    Me.OLEDropMode = 1
End Sub


Private Sub List1_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim fso As New FileSystemObject, Paths() As String
    If LCase(Right(Data.Files(1), 4)) = ".swe" Then
        Paths = Split(Data.Files(1), "\")
        fso.CopyFile Data.Files(1), LevelPath & "\" & Paths(UBound(Paths)), True
        MsgBox Data.Files(1) & " " & ConstStr("import_completed")
    Else
        MsgBox ConstStr("not_a_level")
    End If
End Sub
