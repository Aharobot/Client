[Setup]

AppId={{C8F411C9-82E4-45D2-A0E9-70E223F73510}}
// Application name
AppName=SIGViewer
// Application name and version number
AppVerName=SIGViewer 2.2.0
AppPublisher=National Institute of Informatics
AppPublisherURL=http://inamura.ex.nii.ac.jp/
AppSupportURL=http://inamura.ex.nii.ac.jp/
AppUpdatesURL=http://inamura.ex.nii.ac.jp/
DefaultDirName={pf}\SIGViewer_2.2.0
DefaultGroupName=SIGViewer
OutputBaseFilename=setup
OutputDir=SIGViewerSetup
Compression=lzma
SolidCompression=yes
ChangesEnvironment=true

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";
Name: modifypath; Description: &Add Java install directory to your environmental path; GroupDescription: "Settings:";

[Dirs]
Name: "{app}\SIGViewer/.ssh";Permissions: authusers-modify
Name: "{app}\SIGViewer/Release";Permissions: authusers-modify
Name: "{app}\SIGViewer/Release/shape";Permissions: users-full

[Files]
Source: "../Release/*" ; DestDir:{app}/SIGViewer/Release;  Flags: recursesubdirs createallsubdirs; permissions:users-full
Source: "../../OgreSDK_vc9_v1-8-0/media/*" ; DestDir:{app}/SIGViewer/media/;  Flags: recursesubdirs createallsubdirs; permissions:users-full
Source: "../../CEGUI-0.7.6/datafiles/*" ; DestDir:{app}/SIGViewer/datafiles/;  Flags: recursesubdirs createallsubdirs;permissions:users-full
Source: "./licenses/*" ; DestDir:{app}/SIGViewer/licenses/;  Flags: recursesubdirs createallsubdirs;permissions:users-full
Source: "resources.cfg" ; DestDir:{app}/SIGViewer/Release; permissions:users-full

[Icons]
Name: "{group}\SIGViewer"; Filename: "{app}\SIGViewer\release\SIGViewer.exe"; WorkingDir: "{app}\SIGViewer\Release"
Name: "{commondesktop}\SIGViewer 2.2.0"; Filename: "{app}\SIGViewer\release\SIGViewer.exe"; WorkingDir: "{app}\SIGViewer\Release"; Tasks: desktopicon
; begin(add)(2010/2/24) install SIGWorldEditor.exe





[Code]
var
        DX9RuntimePage: TInputOptionWizardPage;
        VC2008RuntimePage: TInputOptionWizardPage;
        OpenALPage: TInputOptionWizardPage;
        JREPage: TInputOptionWizardPage;
        JREPosPage: TInputDirWizardPage;
        jvmpath: string;  



procedure InitializeWizard;
begin
        // -----------------------------------------------
        //      DirectX 9.0 (Nov2008) Runtime Install Page
        // -----------------------------------------------  
        DX9RuntimePage := CreateInputOptionPage(
                wpWelcome,
                'Install Library for SIGViewer',
                'DirectX (Jun2010) runtime install',
                'SIGViewer needs DirectX (Jun2010) runtime. Do you want to install DirectX (Jun2010) runtime?', 
                True, False);
        DX9RuntimePage.Add('Yes. please proceed');
        DX9RuntimePage.Add('No. skip DirectX (Jun2010) runtime install');
        DX9RuntimePage.Values[0]:=True;

        // -----------------------------------------------
        //      VC++ Runtime Install Page
        // -----------------------------------------------
        VC2008RuntimePage := CreateInputOptionPage(
                DX9RuntimePage.ID,
                'Install Library for SIGViewer',
                'Visual C++ runtime install',
                'SIGViewer needs to install Visual C++ runtime. Do you accept it?',
                True, False);
        VC2008RuntimePage.Add('Yes. please proceed');
        VC2008RuntimePage.Add('No. skip VC++ runtime install');
        VC2008RuntimePage.Values[0]:=True;

        // -----------------------------------------------
        //      OpenAL Runtime Install Page
        // -----------------------------------------------
        OpenALPage := CreateInputOptionPage(
                VC2008RuntimePage.ID,
                'Install Library for SIGViewer',
                'OpenAL runtime install',
                'SIGViewer needs to install OpenAL runtime. Do you accept it?',
                True, False);
        OpenALPage.Add('Yes. please install OpenAL runtime');
        OpenALPage.Add('No. skip OpenAL runtime install');
        OpenALPage.Values[0]:=True;
        // -----------------------------------------------
        //      JRE Install Page
        // -----------------------------------------------
        JREPage := CreateInputOptionPage(
                OpenALPage.ID,
                'Install Library for SIGViewer',
                'JRE (Java Runtime Environment) install',
                'SIGViewer needs to install JRE 6.0. Do you accept it?',
                True, False);
        JREPage.Add('Yes. please install JRE 6.0');
        JREPage.Add('No. I have already installed JRE 6.0 No need to install it again.');
        JREPage.Values[0]:=True;
        jvmpath := '{pf}\Java\jre6\bin\client\';
end;

// **************************************************************
//      Installation of DirectX9 runtime
// **************************************************************
function InstallDX9Runtime: Boolean;
var
        rc: Integer;
        DX9RuntimePath: String;
begin
        Result:=False;

        if DX9RuntimePage.SelectedValueIndex = 0 then begin
                // ------------------------------------
                //      get path of the installer
                // ------------------------------------
                DX9RuntimePath := ExpandConstant('{src}\downloads\direct_x\DXSETUP.exe');

                // ------------------------------------
                //      run installer
                // ------------------------------------
                if Exec(
                        DX9RuntimePath,
                        '',
                        '',
                        SW_SHOW,
                        ewWaitUntilTerminated, rc) then begin
                        // exec succeeded. rc = return code
                end else begin
                        // exec failed. rc = error code
                        exit;
                end;
        end;

        Result:=True;
end;


// **************************************************************
//      Installation of Visual C++2008 runtime
// **************************************************************
function InstallVC2008Runtime: Boolean;
var
        rc: Integer;
        VC2008RuntimePath: String;
begin
        Result:=False;

        if VC2008RuntimePage.SelectedValueIndex = 0 then begin
                // ------------------------------------
                //      get path of the installer
                // ------------------------------------
                VC2008RuntimePath := ExpandConstant('{src}\downloads\VC2008_redist\vcredist_x86.exe');

                // ------------------------------------
                //      run installer
                // ------------------------------------
                if Exec(
                        VC2008RuntimePath,
                        '',
                        '',
                        SW_SHOW,
                        ewWaitUntilTerminated, rc) then begin
                        // exec succeeded. rc = return code
                end else begin
                        // exec failed. rc = error code
                        exit;
                end;
        end;

        Result:=True;
end;

// **************************************************************
//      Installation of OpenAL runtime
// **************************************************************
function InstallOpenALRuntime: Boolean;
var
        rc: Integer;
        OpenALPath: String;
begin
        Result:=False;

        if OpenALPage.SelectedValueIndex = 0 then begin
                // ------------------------------------
                //      get path of the installer
                // ------------------------------------
                OpenALPath := ExpandConstant('{src}\downloads\OpenAL\oalinst.exe');

                // ------------------------------------
                //      run installer
                // ------------------------------------
                if Exec(
                        OpenALPath,
                        '',
                        '',
                        SW_SHOW,
                        ewWaitUntilTerminated, rc) then begin
                        // exec succeeded. rc = return code
                end else begin
                        // exec failed. rc = error code
                        exit;
                end;
        end;

        Result:=True;
end;



// **************************************************************
//      Installation of JRE
// **************************************************************
function InstallJRE: Boolean;
var
        rc: Integer;
        JREInstellerPath: String;
begin
        if JREPage.SelectedValueIndex = 0 then begin
                // ------------------------------------
                //      get path of the installer
                // ------------------------------------
                JREInstellerPath := ExpandConstant('{src}\downloads\JRE6\jre-6u27-windows-i586-s.exe');

                // ------------------------------------
                //      run installer
                // ------------------------------------
                if Exec(
                        JREInstellerPath,
                        '',
                        '',
                        SW_SHOW,
                        ewWaitUntilTerminated, rc) then
                begin
                        // ------------------------------------
                        // ------------------------------------
                        //JREPosPage.Values[0] := ExpandConstant('{pf}\Java\jre6');
                        

                //end else begin
                        // exec failed
                  //      exit;
                end;
        end else begin
                // ---------------------------------------------------
                // ---------------------------------------------------
                //JREPosPage.Values[0] := ExpandConstant('{pf}\Java');
        end;
        
        Result := True;
end;

// **************************************************************
// **************************************************************
function NextButtonClick(CurPageID: Integer): Boolean;
begin
        Result := False;

        if CurPageID = DX9RuntimePage.ID then begin
                if not InstallDX9Runtime then exit;
        end else if CurPageID = VC2008RuntimePage.ID then begin
                if not InstallVC2008Runtime then exit;
        end else if CurPageID = OpenALPage.ID then begin
                if not InstallOpenALRuntime then exit;
        end else if CurPageID = JREPage.ID then begin
                if not InstallJRE then exit;
        end;        

        Result := True;
end;

const
        ModPathName = 'modifypath';
        ModPathType = 'user';

function ModPathDir(): TArrayOfString;
begin
        setArrayLength(Result, 1);
        Result[0] := ExpandConstant(jvmpath);
end;
#include "modpath.iss"

[Run]
;Filename: "{app}/SIGViewer/Release/SIGViewer.exe"; Description: "{cm:LaunchProgram,SIGViewer}"; Flags: nowait postinstall skipifsilent
;Filename: "{app}/SIGViewer/Release/SIGViewer.exe"; Description: "{cm:LaunchProgram,SIGViewer}"; Flags: postinstall skipifsilent nowait
